//
//  rootTabBarController.swift
//  sbyZoo
//
//  Created by Ron Basumallik on 10/18/16.
//  Copyright © 2016 RonCorp. All rights reserved.
//

import UIKit

class rootTabBarController: UITabBarController {
    override func viewDidLoad() {        
        let color = UIColor(red: 140.0/255, green: 198.0/255, blue: 62.0/255, alpha: 1.0)
        UITabBar.appearance().tintColor = color
        UITabBar.appearance().backgroundColor = UIColor.white
        super.viewDidLoad()
    }
}
