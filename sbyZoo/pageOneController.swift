//
//  pageOneController.swift
//  sbyZoo
//
//  Created by Ron Basumallik on 4/20/17.
//  Copyright © 2017 RonCorp. All rights reserved.
//

import Foundation
import UIKit

class pageOneController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 140.0/255, green: 198.0/255, blue: 62.0/255, alpha: 1.0)
        let frame = self.view.frame
        
        let cancelButton = UIButton(type: .custom)
        if let image = UIImage(named: "close") {
            cancelButton.setImage(image, for: .normal)
        }
        
        var x = frame.width * 0.0625
        var width = frame.width * 0.15625
        
        
        cancelButton.frame = CGRect(x: x, y: x, width: width, height: width)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        self.view.addSubview(cancelButton)
        
        
        var y = cancelButton.frame.maxY
        width = frame.width-(2*x)
        
        let label = UILabel(frame: CGRect(x: x, y: y, width: width, height: frame.height * 0.15))
        label.textAlignment = .center
        label.text = "Welcome to the Salisbury Zoo App!"
        label.textColor = UIColor.white
        label.font = UIFont(name: "Twiddlestix", size: 20)
        label.lineBreakMode = .byWordWrapping // or NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 0
        self.view.addSubview(label)
        
        y = label.frame.maxY
        
        let qrLabel = UILabel(frame: CGRect(x: x, y: y, width: width, height: frame.height * 0.2))
        qrLabel.textAlignment = .center
        qrLabel.text = "When walking around the Zoo, you'll see these codes posted at exhibits"
        qrLabel.textColor = UIColor.white
        qrLabel.font = UIFont(name: "Twiddlestix", size: 20)
        qrLabel.lineBreakMode = .byWordWrapping
        qrLabel.numberOfLines = 0
        self.view.addSubview(qrLabel)
        
        width = frame.width-(4*x)
        
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 2*x, y: qrLabel.frame.maxY, width: width, height: width)
        imageView.image = UIImage(named: "code")
        imageView.contentMode = .scaleAspectFit
        
        self.view.addSubview(imageView)
        
        
    }
    
    func cancel(sender: UIButton!) {
        self.performSegue(withIdentifier: "cancelOnboardOne", sender: self)
    }
    
}
