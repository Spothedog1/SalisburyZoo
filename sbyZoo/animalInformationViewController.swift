//
//  animalInformationViewController.swift
//  sbyZoo
//
//  Created by Ron Basumallik on 10/19/16.
//  Copyright © 2016 RonCorp. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class animalInformationViewController: UIViewController, UIScrollViewDelegate {
    var animal: animal?
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    var viewHeight: CGFloat?
    var imageView: UIImageView?
    
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let viewPadding: CGFloat = (UIScreen.main.bounds.width) * 0.021333
    
    func createTextView(_ text: String, topOfFrame: CGFloat) -> UITextView? {
        let animalInformationLabel: UITextView = UITextView()
        let animalInformationLabelFrame = CGRect(x: self.viewPadding, y: topOfFrame + self.viewPadding,
                                                 width: self.screenWidth - (2*self.viewPadding), height: 1000)
        animalInformationLabel.frame = animalInformationLabelFrame
        animalInformationLabel.text = text
        animalInformationLabel.font = UIFont(name: "Helvetica Neue", size: 18)
        
        let updatedAnimalInformationLabelFrame = CGRect(x: self.viewPadding, y: topOfFrame + self.viewPadding,
                                                        width: self.screenWidth - (2*self.viewPadding),
                                                        height: animalInformationLabel.contentSize.height)
        
        animalInformationLabel.frame = updatedAnimalInformationLabelFrame
        return animalInformationLabel
    }
    
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
    
    func createImage(){
        if let a = self.animal {
            if (a.image != nil) {
                let image = a.image!
                let imageWidth = image.size.width
                let imageHeight = image.size.height
                let imageRatio = (imageWidth) / (imageHeight)
                
                let viewHeight = (self.screenWidth - (2*self.viewPadding)) / imageRatio
                self.viewHeight = viewHeight
                let imageView = UIImageView(image: image)
                imageView.frame = CGRect(x: 0, y: 0, width: self.screenWidth, height: viewHeight)
                imageView.image = image
                imageView.contentMode = .scaleAspectFill
                
                self.imageView!.addSubview(imageView)
            } else {
                print("No Image")
            }
        }

    }
    
    func createText(){
        if let description = self.animal!.information {
            let animalInformationLabel: UITextView = UITextView()
       
            animalInformationLabel.text = description
            animalInformationLabel.font = UIFont(name: "Twiddlestix", size: 20)
//            animalInformationLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.75)
            animalInformationLabel.textColor = UIColor.white
            
            let origin = CGPoint(x: 0, y: self.viewHeight! + self.viewPadding)
            animalInformationLabel.frame = CGRect(origin: origin, size: CGSize(width: self.screenWidth - (2*self.viewPadding), height: CGFloat.greatestFiniteMagnitude))
            
            animalInformationLabel.sizeThatFits(CGSize(width: self.screenWidth - (2*self.viewPadding), height: CGFloat.greatestFiniteMagnitude))
            let newSize = animalInformationLabel.sizeThatFits(CGSize(width: self.screenWidth - (2*self.viewPadding), height: CGFloat.greatestFiniteMagnitude))
            let animalInformationLabelFrame = CGRect(x: self.viewPadding, y: self.viewHeight! + (2*self.viewPadding), width: self.screenWidth - (2*self.viewPadding), height: newSize.height)
            

            animalInformationLabel.frame = animalInformationLabelFrame
            animalInformationLabel.isScrollEnabled = false
            self.imageView!.addSubview(animalInformationLabel)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.animal != nil {
            let image = UIImage(named: "bamboo")
            self.imageView = UIImageView(image: image)
            self.imageView!.frame = self.contentView.frame
            self.imageView!.contentMode = .scaleAspectFill

            createTitle()
//            createImage()
//            createText()
            self.contentView.addSubview(imageView!)
            
        }
    }
}
