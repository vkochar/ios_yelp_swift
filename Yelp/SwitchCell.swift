//
//  SwitchCell.swift
//  Yelp
//
//  Created by Varun on 9/22/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import Foundation

@objc protocol SwitchCellDelegate {
    func switchCell(_ switchCell: SwitchCell, didChangeValue value: Bool)
}

class SwitchCell: UITableViewCell {
    
    @IBOutlet weak var onSwitch: UISwitch!
    @IBOutlet weak var switchLabel: UILabel!
    
    weak var delegate: SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setFilter(name: String?, isOn: Bool?) {
        switchLabel.text = name
        onSwitch.isOn = isOn ?? false
        onSwitch.isHidden = false
    }
    
    @IBAction func onSwitchChanged(_ sender: Any) {
        delegate?.switchCell(self, didChangeValue: onSwitch.isOn)
    }
}

