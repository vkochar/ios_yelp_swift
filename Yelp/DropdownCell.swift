//
//  DropdownCell.swift
//  Yelp
//
//  Created by Varun on 9/24/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol DropdownCellDelegate {
    func dropdownCell(_ dropdownCell: DropdownCell, onTap shouldExpand: Bool)
}

class DropdownCell: UITableViewCell {

    @IBOutlet weak var dropdownLabel: UILabel!
    @IBOutlet weak var dropdownView: UIButton!
    
    weak var delegate: DropdownCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func onTapDropdownButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.dropdownCell(self, onTap: sender.isSelected)
    }
    
    func set(label: String?) {
        dropdownLabel.text = label
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
