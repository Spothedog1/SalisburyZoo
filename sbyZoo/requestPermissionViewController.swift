//
//  requestPermissionViewController.swift
//  sbyZoo
//
//  Created by Ron Basumallik on 4/20/17.
//  Copyright © 2017 RonCorp. All rights reserved.
//

import Foundation
import UIKit

class requestPermissionViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height * 0.2
        DispatchQueue.main.async {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: height))
            button.addTarget(self, action: #selector(self.cancelScan), for: .touchUpInside)
            button.backgroundColor = UIColor(red: 140.0/255, green: 198.0/255, blue: 62.0/255, alpha: 1.0)
            button.setTitle("Back", for: .normal)
            button.titleLabel?.textColor = UIColor.white
            button.titleLabel!.font = UIFont(name: "Twiddlestix", size: 20)
            self.view.addSubview(button)
            self.view.backgroundColor = UIColor(red: 140.0/255, green: 198.0/255, blue: 62.0/255, alpha: 1.0)
            let label = UILabel(frame: CGRect(x: 0, y: button.frame.maxY, width: width, height: 3 * height))
            label.textAlignment = .center
            label.text = "Please go to your settings and allow camera permissions"
            label.textColor = UIColor.white
            label.font = UIFont(name: "Twiddlestix", size: 20)
            label.lineBreakMode = .byWordWrapping // or NSLineBreakMode.ByWordWrapping
            label.numberOfLines = 0
            self.view.addSubview(label)
            
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func cancelScan(){
        self.dismiss(animated: true, completion: nil)
    }
    
}
