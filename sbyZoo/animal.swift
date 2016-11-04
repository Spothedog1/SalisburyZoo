//
//  animal.swift
//  The animal class is a model of an animal object. 
//  Name is only required field, the rest are optional.
//  sbyZoo
//
//  Created by Ron Basumallik on 10/19/16.
//  Copyright © 2016 RonCorp. All rights reserved.
//

import Firebase

class animal {
    var name: String
    var information: String?
    var image: UIImage? // Image from Firebase Storage
    var imageReference: String? // Filename as stored in Firebase Storage
    var audioReference: String? // Filename as stored in Firebase Storage
    
    init(snapshot: FIRDataSnapshot){
        self.name = snapshot.key
        let snapshotValue = snapshot.value as! NSDictionary // Cast snapshot to NSDictionary
        
        if let information = snapshotValue["Information"] { // Safe Optional Unwrapping
            self.information = (information as! String)
        }
        if let image = snapshotValue["Image"] { // Safe Optional Unwrapping
            self.imageReference = (image as! String)
        }
        if let audio = snapshotValue["Audio"] { // Safe Optional Unwrapping
            self.audioReference = (audio as! String)
        }
    }
    
    init(name: String, information: String?, image: UIImage?, imageReference: String?, audioReference: String?){
        self.name = name
        self.information = information
        self.image = image
        self.imageReference = imageReference
        self.audioReference = audioReference
    }
}
