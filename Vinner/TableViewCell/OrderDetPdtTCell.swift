//
//  ProductTCell.swift
//  Vinner
//
//  Created by softnotions on 02/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import SDWebImage
import Cosmos

class OrderDetPdtTCell: UITableViewCell {

    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var btnReview: UIButton!
    @IBOutlet weak var lblSeller: UILabel!
    @IBOutlet weak var lblPdtPrice: UILabel!
    @IBOutlet weak var lblPdtName: UILabel!
    @IBOutlet weak var imgPdt: SDAnimatedImageView!
    @IBOutlet weak var viewBG: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
