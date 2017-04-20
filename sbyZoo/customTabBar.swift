//
//  customTabBar.swift
//  sbyZoo
//
//  Created by Ron Basumallik on 4/19/17.
//  Copyright © 2017 RonCorp. All rights reserved.
//

import Foundation
import UIKit

class customTabBar: UITabBar {
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 70
        
        return sizeThatFits
    }
    
}
