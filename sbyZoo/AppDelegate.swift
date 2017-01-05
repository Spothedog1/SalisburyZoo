//
//  AppDelegate.swift
//  sbyZoo
//
//  Created by Ron Basumallik on 10/17/16.
//  Copyright © 2016 RonCorp. All rights reserved.
//

import UIKit
import Firebase
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var animals: [animal]?
    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack()
    var firebase: firebaseAPI?
    
    override init(){
        super.init()
        FIRApp.configure()
        let auth = FIRAuth.auth()
        auth?.signInAnonymously() { (user, error) in
            if ((error) != nil) {
                print(error)
            } else {
                print("Authenticated")
                self.firebase = firebaseAPI()
                let queue = DispatchQueue(label: "imageDownload", qos: DispatchQoS.userInitiated)
                queue.async {
                    for animal in self.animals! {
                        if (animal.image == nil) {
                            if let imageURL = animal.imageReference {
                                if let api = self.firebase {
                                    api.downloadImage(imageURL, completionHandler: { (error, image) -> Void in
                                        if (error){
                                            print("Image Downloading Error")
                                        } else {
                                            if let animalImage = image {
                                                print("Downloading Image: \(animal.name)")
                                                animal.image = animalImage
                                            }
                                        }
                                    })
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        let data = coreDataAPI()
        self.animals = data.fetch()

        let isFlamingo:Bool = data.isAnimal(name: "Flamingo")
        
        if (!(isFlamingo)){
            let flamingoImage = UIImage(named: "flamingo")
            let flamingo = animal(name: "Flamingo", information: "Flamingoes are a type of wadding bird.", image: flamingoImage, imageReference: nil, complete: 0)
            data.add(a: flamingo)
            self.animals?.append(flamingo)
        }
        
        return true
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        coreDataStack.saveContext()
    }
    
    

}

