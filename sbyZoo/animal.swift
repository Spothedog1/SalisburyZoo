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
    var description: String?
    var habitat: String?
    var scientificName: String?
    var status: String?
    var image: UIImage? // Image from Firebase Storage
    var imageReference: String? // Filename as stored in Firebase Storage
    var complete: Bool
    
    init(snapshot: FIRDataSnapshot){
        self.name = snapshot.key
        let snapshotValue = snapshot.value as! NSDictionary // Cast snapshot to NSDictionary
        self.complete = false
        
        if let descriptionUnwrapped = snapshotValue["description"] { // Safe Optional Unwrapping
            self.description = (descriptionUnwrapped as! String)
        }
        if let imageReferenceUnwrapped = snapshotValue["image"] { // Safe Optional Unwrapping
            self.imageReference = (imageReferenceUnwrapped as! String)
        }
        if let habitatUnwrapped = snapshotValue["habitat"] {
            self.habitat = (habitatUnwrapped as! String)
        }
        if let scientificNameUnwrapped = snapshotValue["sn"] {
            self.scientificName = (scientificNameUnwrapped as! String)
        }
        if let statusUnwrapped = snapshotValue["status"] {
            self.status = (statusUnwrapped as! String)
        }
    }
    
    init(name: String, description: String?, image: UIImage?, imageReference: String?, complete: NSNumber, habitat: String?, scientificName: String?, status: String?){
        self.name = name
        
        if let descriptionUnwrapped = description {
            self.description = descriptionUnwrapped
        }
        if let img = image as UIImage! {
            self.image = img
        }
        if let imageReferenceUnwrapped = imageReference {
            self.imageReference = imageReferenceUnwrapped
        }
        if let habitatUnwrapped = habitat {
            self.habitat = habitatUnwrapped
        }
        if let scientificNameUnwrapped = scientificName {
            self.scientificName = scientificNameUnwrapped
        }
        if let statusUnwrapped = status {
            self.status = statusUnwrapped
        }

        self.complete = complete == 1 ? true : false
    }
}
