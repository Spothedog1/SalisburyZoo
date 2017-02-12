//
//  informationViewController.swift
//  sbyZoo
//
//  Created by Ron Basumallik on 2/9/17.
//  Copyright © 2017 RonCorp. All rights reserved.
//

import Foundation
import UIKit

class informationViewController: UIViewController {
    var topView: UIView?
    @IBOutlet weak var textView: UITextView!
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createButtonView()
        let margin = self.topView!.layoutMarginsGuide
        self.textView.leadingAnchor.constraint(equalTo: margin.leadingAnchor).isActive = true
        self.textView.trailingAnchor.constraint(equalTo: margin.trailingAnchor).isActive = true
        self.textView.font = UIFont(name: "Raleway-Light", size: 20)
        self.textView.text = "Welcome to the Salisbury Zoo Mobile App!\n\nAs you explore the zoo you will notice QR Codes posted at different exhibits. You can collect animals by scanning these QR Codes by pressing the plus button at the top right of the home screen.\n\nNewly discovered animals will be hidden from you until you click on them. Collect as many animals as you can!"
    }
    
    func cancelInfo(){
        self.dismiss(animated: true, completion: nil)
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
        button.setTitle("Back", for: .normal)
        button.titleLabel!.font = UIFont(name: "Twiddlestix", size: 20)
        button.titleLabel!.textColor = UIColor.white
        button.addTarget(self, action: #selector(cancelInfo), for: .touchUpInside)
        
        self.view.addSubview(button)
        
        view.addSubview(button)
        self.topView = view
        self.view.addSubview(self.topView!)
    }
}
