//
//  ProductListCCell.swift
//  Vinner
//
//  Created by softnotions on 21/07/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage
class ProductListCCell: UICollectionViewCell {
    
    @IBOutlet weak var viewSEarchOutStock: UIView!
    @IBOutlet weak var viewOutStock: UIView!
    @IBOutlet weak var lblOUtOfStock: UILabel!
    @IBOutlet weak var viewOutOfStockSearch: UIView!
    @IBOutlet weak var ProductRatingView: CosmosView!
    @IBOutlet weak var viewOutOfStock: UIView!
    @IBOutlet weak var imgWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var lblPdtPrice: UILabel!
//    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblPdt: UILabel!
    @IBOutlet weak var imgPdt: SDAnimatedImageView!
    @IBOutlet weak var viewBG: UIView!
}
