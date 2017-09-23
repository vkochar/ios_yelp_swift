//
//  SwitchCell.swift
//  Yelp
//
//  Created by Varun on 9/22/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import Foundation

class SwitchCell: UITableViewCell {
 
    @IBOutlet weak var onSwitch: UISwitch!
    @IBOutlet weak var switchLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setFilterName(name: String?) {
        switchLabel.text = name
    }
}
