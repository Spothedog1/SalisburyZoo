//
//  news.swift
//  sbyZoo
//
//  Created by Ron Basumallik on 1/5/17.
//  Copyright © 2017 RonCorp. All rights reserved.
//
import Firebase

class news {
    var title: String
    var date: String?
    var article: String?
    var imageReference: String?
    var image: UIImage?
    
    init(snapshot: FIRDataSnapshot){
        let snapshotValue = snapshot.value as! NSDictionary
        
        self.title = snapshot.key
        
        if let dateUnwrapped = snapshotValue["date"] {
            self.date = dateUnwrapped as! String
        }
        
        if let articleUnwrapped = snapshotValue["info"] {
            self.article = articleUnwrapped as! String
        }
        
        if let imageReferenceUnwrapped = snapshotValue["image"] {
            self.imageReference = imageReferenceUnwrapped as! String
        }
    }
    
    // The u prefix just means unwrapped
    init(title: String, date: String?, article: String?, imageReference: String?, image: UIImage?){
        self.title = title
        if let uDate = date {
            self.date = uDate
        }
        if let uArticle = article {
            self.article = uArticle
        }
        if let uImageReference = imageReference {
            self.imageReference = uImageReference
        }
        if let uImage = image as UIImage! {
            self.image = uImage
        }
    }
}
