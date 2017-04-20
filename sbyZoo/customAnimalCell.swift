//
//  customAnimalCell.swift
//  sbyZoo
//
//  Created by Ron Basumallik on 10/19/16.
//  Copyright © 2016 RonCorp. All rights reserved.
//

import UIKit

class customAnimalCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    func customizeCell(label: String){
        self.nameLabel.text = label
        self.nameLabel.textColor = UIColor.white
        self.nameLabel.font = UIFont(name: "Twiddlestix", size: 20)
        self.nameLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.75)
        self.nameLabel.lineBreakMode = .byWordWrapping
        self.nameLabel.numberOfLines = 0
        
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
}
