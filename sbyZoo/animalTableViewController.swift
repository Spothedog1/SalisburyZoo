//
//  animalTableViewController.swift
//  sbyZoo
//
//  Created by Ron Basumallik on 10/19/16.
//  Copyright © 2016 RonCorp. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CoreData

class animalTableViewController: UITableViewController, addExhibitProtocol {
    let ref = FIRDatabase.database().reference(withPath: "Exhibits")
    var exhibitName: String?
    var animals: [animal]?
    let color = UIColor(red: 140.0/255, green: 198.0/255, blue: 62.0/255, alpha: 1.0)
    
    override func viewDidLoad() {
        let imageViewRight:UIImageView = UIImageView()
        imageViewRight.frame = CGRect(x: 25, y: 10, width: 25, height: 25)
        let rightImage:UIImage = UIImage(named: "qr")!
        imageViewRight.image = rightImage
        let rightView:UIView = UIView()
        rightView.frame = CGRect(x: 0,y: 0,width: 45,height: 45)
        rightView.addSubview(imageViewRight)
        let rightGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(animalTableViewController.pushProfileToCamera))
        rightView.addGestureRecognizer(rightGestureRecognizer)
        let rightItem:UIBarButtonItem = UIBarButtonItem()
        rightItem.customView = rightView
        self.navigationItem.rightBarButtonItem = rightItem
        
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.animals = appDelegate?.animals
        
        self.tableView.rowHeight = (UIScreen.main.bounds.width/1.61803398875)
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "bamboo"))
        
        let titleLabel = UILabel(frame: CGRect(x: 0,y: 0,width: 150,height: 50))
        titleLabel.text = "Your Animals"
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = UIFont(name: "Twiddlestix", size: 20)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = NSTextAlignment.center
        
        let titleView = UIView(frame: CGRect(x: 0,y: 0,width: 150,height: 50))
        titleView.addSubview(titleLabel)
        
        self.navigationItem.titleView = titleView
        
        if let animalArray = animals {
            for animal in animalArray {
                if let imageURL = animal.imageReference {
                    let ref = FIRStorage.storage().reference(forURL: imageURL)
                    ref.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                        if (error != nil) {
                            print(error)
                        } else {
                            let image = UIImage(data: data!)
                            animal.image = image
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    
    func pushProfileToCamera(){
        print("Button Pressed")
        self.performSegue(withIdentifier: "QRSegue", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let animalArray = animals {
            return animalArray.count
        } else {
            return 0
        }
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customAnimalCell", for: indexPath) as! customAnimalCell
        let animal = animals![indexPath.row]
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
        let imageView = UIImageView(frame: frame)
        imageView.contentMode = .scaleAspectFill
        if let image = animal.image {
            imageView.image = image
        }
        cell.backgroundView = UIView()
        cell.backgroundView!.addSubview(imageView)

        cell.customizeCell(label: animal.name)
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("animalTableViewController has loaded")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "AnimalSegue", sender: (indexPath as NSIndexPath).row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AnimalSegue" {
            if let row = sender {
                let animalViewController = segue.destination as! animalInformationViewController
                let index = row as! Int
                animalViewController.animal = animals![index]
            }
        } else if segue.identifier == "QRSegue" {
            let qrViewController = segue.destination as! qrViewController
            qrViewController.delegate = self
        }
    }
    
    
    func addExhibit(exhibit: String){
        let ref = FIRDatabase.database().reference(withPath: "Exhibits")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        ref.child(exhibit).observeSingleEvent(of: .value, with: {
            snapshot in
            for item in snapshot.children {
                let animalObject = animal(snapshot: item as! FIRDataSnapshot)
                let managedContext = appDelegate.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: "Animal", in: managedContext)!
                let animalEntity = NSManagedObject(entity: entity, insertInto: managedContext)
                animalEntity.setValue(animalObject.name, forKey: "name")
                animalEntity.setValue(animalObject.information, forKey: "information")
                animalEntity.setValue(animalObject.imageReference, forKey: "imageURL")
                animalEntity.setValue(animalObject.audioReference, forKey: "audio")
                self.animals!.append(animalObject)

                do {
                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
            if let animalArray = self.animals {
                for animal in animalArray {
                    if let imageURL = animal.imageReference {
                        let ref = FIRStorage.storage().reference(forURL: imageURL)
                        ref.data(withMaxSize: 1 * 1024 * 1024) { (data, error) -> Void in
                            if (error != nil) {
                                print(error)
                            } else {
                                let image = UIImage(data: data!)
                                animal.image = image
                                appDelegate.animals = self.animals
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
}
