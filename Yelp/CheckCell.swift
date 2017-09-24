//
//  CheckCell.swift
//  Yelp
//
//  Created by Varun on 9/24/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol CheckCellDelegate {
    func checkCell(_ checkCell: CheckCell, onTap isChecked: Bool)
}

class CheckCell: UITableViewCell {

    @IBOutlet weak var checkLabel: UILabel!
    @IBOutlet weak var checkView: UIButton!
    
    weak var delegate: CheckCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checkView.setImage(#imageLiteral(resourceName: "radio_unchecked"), for: UIControlState.normal)
        checkView.setImage(#imageLiteral(resourceName: "radio_checked"), for: UIControlState.selected)
    }
    
    @IBAction func onCheckedChange(_ sender: Any) {
        checkView.isSelected = !checkView.isSelected
        delegate?.checkCell(self, onTap: checkView.isSelected)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func set(label: String?, isChecked: Bool?) {
        checkLabel.text = label
        checkView.isSelected = isChecked ?? false
    }
}
