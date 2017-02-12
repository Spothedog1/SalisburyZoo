//
//  customNewsCell.swift
//  sbyZoo
//
//  Created by Ron Basumallik on 1/5/17.
//  Copyright © 2017 RonCorp. All rights reserved.
//

import UIKit

class customNewsCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    func customizeCell(label: String){
        self.nameLabel.text = label
        self.nameLabel.textAlignment = NSTextAlignment.left
        self.nameLabel.textColor = UIColor.white
        self.nameLabel.font = UIFont(name: "Raleway-Light", size: 20)
        self.nameLabel.backgroundColor = UIColor(red: 90.0/255, green: 70.0/255, blue: 196.0/255, alpha: 1.0)
        self.backgroundColor = UIColor(red: 90.0/255, green: 70.0/255, blue: 196.0/255, alpha: 1.0)
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
}
