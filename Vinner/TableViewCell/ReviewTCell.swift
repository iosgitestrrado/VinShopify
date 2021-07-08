//
//  ReviewTCell.swift
//  Vinner
//
//  Created by softnotions on 27/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import SDWebImage
import Cosmos

class ReviewTCell: UITableViewCell {
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var imgProfile: SDAnimatedImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var reviewRating: CosmosView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblReviewContent: UILabel!
    
    @IBOutlet weak var lblReviewDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
