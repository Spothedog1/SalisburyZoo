//
//  animalNavigationController.swift
//  sbyZoo
//
//  Created by Ron Basumallik on 10/18/16.
//  Copyright © 2016 RonCorp. All rights reserved.
//

import Foundation
import UIKit

class animalNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = .lightContent
        let color = UIColor(red: 140.0/255, green: 198.0/255, blue: 62.0/255, alpha: 1.0)
        self.navigationBar.barTintColor = color
        self.navigationBar.tintColor = UIColor.white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }

}
