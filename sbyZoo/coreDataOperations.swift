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

class coreDataOperations{
    let ref = FIRDatabase.database().reference(withPath: "Exhibits")
    let coreData = CoreDataStack()
    
    func isAnimal(name: String) -> Bool {
        var exist: Bool = false

        let managedContext = self.coreData.managedObjectContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Animal")
        
        do {
            let animals: [NSManagedObject] = try managedContext.fetch(fetchRequest)
            for animal in animals as [NSManagedObject] {
                if var animalName = animal.value(forKey: "name") as? String {
                    if (animalName == name){
                        return true
                    }
                }
    
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return exist
    }
    
    func fetch() -> [animal] {
        var arr:[animal] = []
        let managedContext = self.coreData.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Animal")
    
        do {
            let animals: [NSManagedObject] = try managedContext.fetch(fetchRequest)
            for animalObj in animals as [NSManagedObject]{
                let name = animalObj.value(forKey: "name") as! String
                let information = animalObj.value(forKey: "information") as? String
                let imageURL = animalObj.value(forKey: "imageURL") as? String
                let complete = animalObj.value(forKey: "complete") as! NSNumber
                let animalObject = animal(name: name, information: information, image: nil, imageReference: imageURL, complete: complete)
                arr.append(animalObject)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return arr
    }
    
    func add(a: animal){
        let managedContext = self.coreData.managedObjectContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Animal", in: managedContext)!
        let animalEntity = NSManagedObject(entity: entity, insertInto: managedContext)
        animalEntity.setValue(a.name, forKeyPath: "name")
        
        if let info = a.information {
            animalEntity.setValue(info, forKeyPath: "information")
        }
        
        if let imageRef = a.imageReference {
            animalEntity.setValue(imageRef, forKeyPath: "imageURL")
        }
        animalEntity.setValue(false, forKeyPath: "complete")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Couldn not save. \(error), \(error.userInfo)")
        }
    }
    
    func delete(){
        let managedContext = self.coreData.managedObjectContext
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


