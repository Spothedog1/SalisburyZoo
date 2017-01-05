//
//  firebaseAPI.swift
//  sbyZoo
//
//  Created by Ron Basumallik on 1/4/17.
//  Copyright © 2017 RonCorp. All rights reserved.
//

import Firebase

class firebaseAPI {
    let storageReference = FIRStorage.storage().reference(forURL: "gs://sbyzoo-d5f5e.appspot.com")
    let exhibitDatabaseRef = FIRDatabase.database().reference(withPath: "Exhibits")
    let newsDatabaseRef = FIRDatabase.database().reference(withPath: "News")
    
    // Returns all exhibits as an array of animal objects
    func getExhibits(completionHandler: @escaping ([animal]) -> Void) {
        var animals: [animal] = []
        self.exhibitDatabaseRef.observeSingleEvent(of: .value, with: {
            (snapshot) in
            for child in snapshot.children {
                let animalObject = animal(snapshot: child as! FIRDataSnapshot)
                animals.append(animalObject)
            }
            completionHandler(animals)
        })
    }
    
    // Returns all animals in specified exhibit as an array of animal objects
    func getExhibit(_ exhibit: String, completionHandler: @escaping ([animal]) -> Void) {
        var animals: [animal] = []
        self.exhibitDatabaseRef.child(exhibit).observeSingleEvent(of: .value, with: {
            (snapshot) in
            for child in snapshot.children {
                let animalObject = animal(snapshot: child as! FIRDataSnapshot)
                animals.append(animalObject)
            }
            completionHandler(animals)
        })
    }
    
    // Downloads animals image from Firebase Storage
    func downloadImage(_ imageURL: String, completionHandler: @escaping (Bool, UIImage?) -> Void) {
        var image: UIImage?
        self.storageReference.child(imageURL).data(withMaxSize: 2 * 1024 * 1024, completion: {(data, error) -> Void in
            if (error != nil){
                completionHandler(true, nil)
            } else {
                if let imageData = data{
                    image = UIImage(data: imageData)
                    completionHandler(false, image)
                } else {
                    completionHandler(true, nil)
                }
            }
        })
    }
}

