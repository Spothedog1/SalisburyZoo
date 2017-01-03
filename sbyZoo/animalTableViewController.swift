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

class animalTableViewController: UITableViewController, addExhibitProtocol, UISearchResultsUpdating {
    let ref = FIRDatabase.database().reference(withPath: "Exhibits")
    var exhibitName: String?
    var animals: [animal]?
    var filteredAnimals: [animal]?
    let color = UIColor(red: 140.0/255, green: 198.0/255, blue: 62.0/255, alpha: 1.0)
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    let coreData = coreDataOperations()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        let imageViewLeft:UIImageView = UIImageView()
        imageViewLeft.frame = CGRect(x:25, y:10, width: 25, height: 25)
        let leftImage:UIImage = UIImage(named: "trash")!
        imageViewLeft.image = leftImage
        let leftView:UIView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        leftView.addSubview(imageViewLeft)
        let leftGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(animalTableViewController.deleteList))
        leftView.addGestureRecognizer(leftGestureRecognizer)
        let leftItem:UIBarButtonItem = UIBarButtonItem()
        leftItem.customView = leftView
        self.navigationItem.leftBarButtonItem = leftItem
        
        self.animals = (appDelegate?.animals)!.reversed()
        
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
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.barTintColor = self.color
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredAnimals = self.animals!.filter { animal in
            let stringMatch = animal.name.lowercased().contains(searchText.lowercased())
            let complete = animal.complete
            return stringMatch && complete
        }
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func pushProfileToCamera(){
        self.performSegue(withIdentifier: "QRSegue", sender: nil)
    }
    
    func deleteList(){
        self.coreData.delete()
        self.animals! = []
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredAnimals!.count
        } else {
            return animals!.count
        }
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let storageRef = FIRStorage.storage().reference(forURL: "gs://sbyzoo-d5f5e.appspot.com")
        let cell = tableView.dequeueReusableCell(withIdentifier: "customAnimalCell", for: indexPath) as! customAnimalCell
        var animal = self.animals![indexPath.row]
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
        let imageView = UIImageView(frame: frame)
        imageView.contentMode = .scaleAspectFill
        
        if (searchController.isActive && searchController.searchBar.text != "") {
            animal = self.filteredAnimals![indexPath.row]
        }
        
        if (animal.complete){
            cell.customizeCell(label: animal.name)
            if let image = animal.image {
                imageView.image = image
            } else if (animal.name == "Flamingo"){
                imageView.image = UIImage(named: "flamingo")
                animal.image = UIImage(named: "flamingo")
            } else if let imageURL = animal.imageReference {
                storageRef.child(imageURL).data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) -> Void in
                    DispatchQueue.main.async {
                        if (error != nil){
                            print(error!)
                        } else {
                            let image = UIImage(data: data!)
                            animal.image = image
                            imageView.image = image
                        }
                    }
                })
            }
        } else {
            cell.customizeCell(label: "?")
            imageView.image = UIImage(named: "undiscovered")
        }
        cell.backgroundView = UIView()
        cell.backgroundView!.addSubview(imageView)
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "AnimalSegue", sender: (indexPath as NSIndexPath).row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AnimalSegue" {
            if let row = sender {
                let index = row as! Int
                let animal: animal
                if (searchController.isActive && searchController.searchBar.text != "") {
                    animal = self.filteredAnimals![index]
                    self.filteredAnimals![index].complete = true
                } else {
                    animal = self.animals![index]
                    self.animals![index].complete = true
                }
                let name = animal.name
                self.coreData.update(name: name)
                let animalViewController = segue.destination as! animalInformationViewController
                animalViewController.animal = animal
            }
        } else if segue.identifier == "QRSegue" {
            let qrViewController = segue.destination as! qrViewController
            qrViewController.delegate = self
        }
    }
    func addExhibit() {
        self.animals! = (self.coreData.fetch()).reversed()
        self.tableView.reloadData()
    }
    
//    func addExhibit(exhibit: String){
//        let ref = FIRDatabase.database().reference(withPath: "Exhibits")
//        ref.child(exhibit).observeSingleEvent(of: .value, with: {
//            ( snapshot ) in
//            let count = snapshot.childrenCount
//            
//            for item in snapshot.children {
//                let animalObject = animal(snapshot: item as! FIRDataSnapshot)
//                let exists = self.coreData.isAnimal(name: animalObject.name)
//                if (!(exists)){
//                    self.coreData.add(a: animalObject)
//                    self.animals!.insert(animalObject, at: 0)
//                } else {
//                    print("Already Added")
//                }
//            }
//            self.tableView.reloadData()
//
//        }) { (error) in
//            print(error)
//        }
//    }
}
