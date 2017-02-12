//
//  newsInformationViewController.swift
//  sbyZoo
//
//  Created by Ron Basumallik on 1/5/17.
//  Copyright © 2017 RonCorp. All rights reserved.
//

import Foundation
import UIKit

class newsInformationViewContoller: UIViewController, UIScrollViewDelegate {
    var article: news?
    @IBOutlet weak var scrollView: UIScrollView!
    let contentView = UIView()
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    let viewPadding: CGFloat = (UIScreen.main.bounds.width) * 0.021333
    var viewHeight: CGFloat = 0.0
    var text: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTitle()
        createImage()
        createText()
        self.scrollView.backgroundColor = UIColor(red: 140.0/255, green: 198.0/255, blue: 62.0/255, alpha: 1.0)
        self.scrollView.contentSize = self.contentView.frame.size
        self.scrollView.addSubview(self.contentView)
    }
    
    func createTitle(){
        let titleLabel = UILabel(frame: CGRect(x: 0,y: 0,width: 150,height: 50))
        titleLabel.text = self.article!.title
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
        if let a = self.article {
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
                                print("Downloading Image: \(a.title)")
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
        var text = ""
        if let dateUnwrapped = self.article!.date {
            text += "\(dateUnwrapped)\n\n"
        }
        if let articleUnwrapped = self.article!.article {
            text += "\(articleUnwrapped)\n"
        }

        self.text = text
        
        let animalInformationLabel: UILabel = UILabel(frame: CGRect(x: self.viewPadding, y: self.viewHeight + self.viewPadding, width: self.screenWidth - (2*self.viewPadding), height: CGFloat.greatestFiniteMagnitude))
        animalInformationLabel.numberOfLines = 0
        animalInformationLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        animalInformationLabel.font = UIFont(name: "Raleway-Light", size: 20)
        animalInformationLabel.text = text
        animalInformationLabel.textColor = UIColor.white
        animalInformationLabel.sizeToFit()
        animalInformationLabel.frame.origin = CGPoint(x: self.viewPadding, y: self.viewHeight + self.viewPadding)
        self.contentView.frame = CGRect(x: 0, y: 0, width: self.screenWidth, height: animalInformationLabel.frame.maxY)
        self.contentView.addSubview(animalInformationLabel)
    }

    
}
