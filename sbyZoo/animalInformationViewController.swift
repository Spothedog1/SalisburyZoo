//
//  animalInformationViewController.swift
//  sbyZoo
//
//  Created by Ron Basumallik on 10/19/16.
//  Copyright © 2016 RonCorp. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class animalInformationViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    var animal: animal?
    var viewHeight: CGFloat = 0.0
    var myUtterance = AVSpeechUtterance(string: "")
    let synth = AVSpeechSynthesizer()
    let contentView = UIView()
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let viewPadding: CGFloat = (UIScreen.main.bounds.width) * 0.021333
    
    func createTitle(){
        let titleLabel = UILabel(frame: CGRect(x: 0,y: 0,width: 150,height: 50))
        titleLabel.text = self.animal!.name
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = UIFont(name: "Twiddlestix", size: 18)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = NSTextAlignment.center
        let titleView = UIView(frame: CGRect(x: 0,y: 0,width: 150,height: 50))
        titleView.addSubview(titleLabel)
        self.navigationItem.titleView = titleView
    }
    
    func createImageView(image: UIImage) -> UIImageView{
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        let imageRatio = (imageWidth)/(imageHeight)
        let viewHeight = (self.screenWidth - (2*self.viewPadding)) / imageRatio
        self.viewHeight = viewHeight
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: self.screenWidth, height: viewHeight)
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
    
    func createImage(){
        if let a = self.animal {
            if let image  = a.image {
                let imageView = createImageView(image: image)
                self.contentView.addSubview(imageView)
            } else if let imageURL = a.imageReference {
                firebaseAPI().downloadImage(imageURL, completionHandler: { (error, image) -> Void in
                    DispatchQueue.main.async {
                        if (error){
                            print("Image Downloading Error")
                        } else {
                            if let animalImage = image {
                                print("Downloading Image: \(a.name)")
                                let imageView = self.createImageView(image: animalImage)
                                self.contentView.addSubview(imageView)
                            }
                        }
                    }
                })
            } else {
                self.viewHeight = 0.0
            }
        }
    }
    
    func createText(){
        if let description = self.animal!.information {
            let animalInformationLabel: UILabel = UILabel(frame: CGRect(x: self.viewPadding, y: self.viewHeight + self.viewPadding, width: self.screenWidth - (2*self.viewPadding), height: CGFloat.greatestFiniteMagnitude))
            animalInformationLabel.numberOfLines = 0
            animalInformationLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
            animalInformationLabel.font = UIFont(name: "AppleSDGothicNeo-Light ", size: 20)
            animalInformationLabel.text = description
            animalInformationLabel.textColor = UIColor.white
            animalInformationLabel.sizeToFit()
            animalInformationLabel.frame.origin = CGPoint(x: self.viewPadding, y: self.viewHeight + self.viewPadding)
            self.contentView.frame = CGRect(x: 0, y: 0, width: self.screenWidth, height: animalInformationLabel.frame.maxY)
            self.contentView.addSubview(animalInformationLabel)
        }
    }
    
    func readText(){
        myUtterance = AVSpeechUtterance(string: self.animal!.information!)
        myUtterance.rate = 0.5
        synth.speak(myUtterance)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageViewRight:UIImageView = UIImageView()
        imageViewRight.frame = CGRect(x: 25, y: 10, width: 25, height: 25)
        let rightImage:UIImage = UIImage(named: "audio")!
        
        imageViewRight.image = rightImage
        imageViewRight.image = imageViewRight.image!.withRenderingMode(.alwaysTemplate)
        imageViewRight.tintColor = UIColor.white
        
        let rightView:UIView = UIView()
        rightView.frame = CGRect(x: 0,y: 0,width: 45,height: 45)
        rightView.addSubview(imageViewRight)
        let rightGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(animalInformationViewController.readText))
        rightView.addGestureRecognizer(rightGestureRecognizer)
        let rightItem:UIBarButtonItem = UIBarButtonItem()
        rightItem.customView = rightView
        self.navigationItem.rightBarButtonItem = rightItem
        
        if self.animal != nil {
            createTitle()
            createImage()
            createText()
            self.scrollView.backgroundColor = UIColor(red: 140.0/255, green: 198.0/255, blue: 62.0/255, alpha: 1.0)
            self.scrollView.contentSize = self.contentView.frame.size
            self.scrollView.addSubview(self.contentView)
        }
    }
}
