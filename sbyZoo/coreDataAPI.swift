//
//  coreDataAPI.swift
//  sbyZoo
//
//  Created by Ron Basumallik on 1/4/17.
//  Copyright © 2017 RonCorp. All rights reserved.
//

import CoreData

class coreDataAPI {
    let coreData = CoreDataStack()
    
    // Sets animal discovery to true
    func update(name: String) {
        let managedContext = self.coreData.managedObjectContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Animal")
        let predicate = NSPredicate(format: "name = %@", name)
        fetchRequest.predicate = predicate
        
        do{
            let animals: [NSManagedObject] = try managedContext.fetch(fetchRequest)
            let animal = animals[0]
            animal.setValue(true, forKey: "complete")
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Couldn not save. \(error), \(error.userInfo)")
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // Checks to see if animal is already added
    func isAnimal(name: String) -> Bool {
        let managedContext = self.coreData.managedObjectContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Animal")
        let predicate = NSPredicate(format: "name = %@", name)
        fetchRequest.predicate = predicate
        
        do {
            let animals: [NSManagedObject] = try managedContext.fetch(fetchRequest)
            print(animals)
            if (animals.count == 1){
                return true
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return false
    }
    
    // Fetches all animals
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
                let habitat = animalObj.value(forKey: "habitat") as? String
                let scientificName = animalObj.value(forKey: "scientificName") as? String
                let status = animalObj.value(forKey: "status") as? String
                let animalObject = animal(name: name, description: information, image: nil, imageReference: imageURL, complete: complete, habitat: habitat, scientificName: scientificName, status: status)
                arr.append(animalObject)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return arr
    }
    
    // Adds animal
    func add(a: animal){
        let managedContext = self.coreData.managedObjectContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Animal", in: managedContext)!
        let animalEntity = NSManagedObject(entity: entity, insertInto: managedContext)
        animalEntity.setValue(a.name, forKeyPath: "name")
        
        if let info = a.description {
            animalEntity.setValue(info, forKeyPath: "information")
        }
        
        if let imageRef = a.imageReference {
            animalEntity.setValue(imageRef, forKeyPath: "imageURL")
        }
        animalEntity.setValue(false, forKeyPath: "complete")
        
        if let habitat = a.habitat {
            animalEntity.setValue(habitat, forKey: "habitat")
        }
        
        if let scientificName = a.scientificName {
            animalEntity.setValue(scientificName, forKey: "scientificName")
        }
        
        if let status = a.status {
            animalEntity.setValue(status, forKey: "status")
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Couldn not save. \(error), \(error.userInfo)")
        }
    }
    
    // Deletes all animals
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
