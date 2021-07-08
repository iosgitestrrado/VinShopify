//
//  OrderListTCell.swift
//  Vinner
//
//  Created by softnotions on 14/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import SDWebImage
import Cosmos

class OrderListTCell: UITableViewCell {
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var imgPdt: SDAnimatedImageView!
    @IBOutlet weak var btnReview: UIButton!
    @IBOutlet weak var lblDelivery: UILabel!
    @IBOutlet weak var lblPdtName: UILabel!
    @IBOutlet weak var pdtRating: CosmosView!
    @IBOutlet weak var lblOrderDate: UILabel!
    
    @IBOutlet weak var lblOrderID: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
