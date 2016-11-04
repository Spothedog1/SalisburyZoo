//
//  qrViewController.swift
//  sbyZoo
//
//  Created by Ron Basumallik on 11/4/16.
//  Copyright © 2016 RonCorp. All rights reserved.
//

import UIKit
import AVFoundation

protocol addExhibitProtocol {
    func addExhibit(exhibit: String)
}

class qrViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate{
    var objCaptureSession: AVCaptureSession?
    var objCaptureVideoPreviewLayer: AVCaptureVideoPreviewLayer?
    var vwQRCode: UIView?
    var topView: UIView?
    var delegate: addExhibitProtocol!
    var i: Int = 0

    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func buttonAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.createButtonView()
        self.configureVideoCapture()
        self.addVideoPreviewLayer()
        self.initializeQRView()
    }
    
    func createButtonView(){
        let greenColor = UIColor(red: 140.0/255, green: 198.0/255, blue: 62.0/255, alpha: 1.0)
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height * 0.09375
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        view.backgroundColor = greenColor
        
        let x = width/2 - 50
        let y = height/2 - 20
        let button = UIButton(frame: CGRect(x: x, y: y, width: 100, height: 50))
        button.backgroundColor = greenColor
        button.setTitle("Cancel", for: .normal)
        button.titleLabel!.font = UIFont(name: "Twiddlestix", size: 20)
        button.titleLabel!.textColor = UIColor.white
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.view.addSubview(button)
        
        view.addSubview(button)
        self.topView = view
        self.view.addSubview(self.topView!)
    }
    
    func configureVideoCapture() {
        let objCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        var error: NSError?
        let objCaptureDeviceInput: AnyObject!
        
        do {
            objCaptureDeviceInput = try AVCaptureDeviceInput(device: objCaptureDevice) as AVCaptureDeviceInput
        } catch let error1 as NSError {
            error = error1
            objCaptureDeviceInput = nil
        }
        if (error != nil){
            let alertView: UIAlertView = UIAlertView(title: "Device Error", message: "Device not Supported for this Application", delegate: nil, cancelButtonTitle: "Ok Done")
            alertView.show()
            return
        }
        objCaptureSession = AVCaptureSession()
        objCaptureSession?.addInput(objCaptureDeviceInput as! AVCaptureInput)
        let objCaptureMetadataOutput = AVCaptureMetadataOutput()
        objCaptureSession?.addOutput(objCaptureMetadataOutput)
        objCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        objCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
    }
    
    func addVideoPreviewLayer() {
        objCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: objCaptureSession)
        objCaptureVideoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        objCaptureVideoPreviewLayer?.frame = view.layer.bounds
        self.view.layer.addSublayer(objCaptureVideoPreviewLayer!)
        objCaptureSession?.startRunning()
        self.view.bringSubview(toFront: topView!)
    }
    
    func initializeQRView(){
        vwQRCode = UIView()
        let greenColor = UIColor(red: 140.0/255, green: 198.0/255, blue: 62.0/255, alpha: 1.0).cgColor
        vwQRCode?.layer.borderColor = greenColor
        vwQRCode?.layer.borderWidth = 5
        self.view.addSubview(vwQRCode!)
        self.view.bringSubview(toFront: vwQRCode!)
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0 {
            vwQRCode?.frame = CGRect.zero
            return
        }
        let objMetadataMachineReadableCodeObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if objMetadataMachineReadableCodeObject.type == AVMetadataObjectTypeQRCode {
            let objBarCode = objCaptureVideoPreviewLayer?.transformedMetadataObject(for: objMetadataMachineReadableCodeObject as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            vwQRCode?.frame = objBarCode.bounds;
            if objMetadataMachineReadableCodeObject.stringValue != nil {
                self.i += 1
                if (i == 1){
                    self.delegate?.addExhibit(exhibit: objMetadataMachineReadableCodeObject.stringValue)
                    self.buttonAction()
                }
            }
        }
    }
}
