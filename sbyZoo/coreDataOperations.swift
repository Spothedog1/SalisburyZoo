//
//  coreDataOperations.swift
//  sbyZoo
//
//  Created by Ron Basumallik on 11/3/16.
//  Copyright © 2016 RonCorp. All rights reserved.
//

import CoreData
import UIKit
import Firebase

class coreDataOperations {
    let ref = FIRDatabase.database().reference(withPath: "Exhibits")

    func fetch() -> [animal] {
        var arr:[animal] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return arr
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Animal")
        
        do {
            let animals = try managedContext.fetch(fetchRequest)
            for animalObj in animals {
                let name = animalObj.value(forKey: "name") as! String
                let information = animalObj.value(forKey: "information") as? String
                let imageURL = animalObj.value(forKey: "imageURL") as? String
                // Audio
                
                let animalObject = animal(name: name, information: information, image: nil, imageReference: imageURL, audioReference: nil)
                arr.append(animalObject)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return arr
    }
    
    func delete(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Animal")
        
        do {
            let animals = try managedContext.fetch(fetchRequest)
            for animal in animals {
                managedContext.delete(animal)
                try managedContext.save()
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}


