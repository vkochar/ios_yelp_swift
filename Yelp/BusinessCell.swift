//
//  BusinessCell.swift
//  Yelp
//
//  Created by Varun on 9/21/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import AFNetworking

class BusinessCell: UITableViewCell {

    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceIndicatorLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var reviewsImageView: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var business: Business! {
        didSet {
            nameLabel.text = business.name
            addressLabel.text = business.address
            categoryLabel.text = business.categories
            distanceLabel.text = business.distance
            reviewsLabel.text = "\(business.reviewCount!) Reviews"
            reviewsImageView.setImageWith(business.ratingImageURL!)
            if let imageUrl = business.imageURL {
                businessImageView.setImageWithAnimation(url: imageUrl)
            } else {
                businessImageView.image = nil
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        businessImageView.layer.cornerRadius = 5
        businessImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
