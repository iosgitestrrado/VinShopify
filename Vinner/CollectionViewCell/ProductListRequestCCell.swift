//
//  ProductListRequestCCell.swift
//  Vinner
//
//  Created by softnotions on 21/07/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage
class ProductListRequestCCell: UICollectionViewCell {
    
       @IBOutlet weak var ratingView: CosmosView!
       @IBOutlet weak var lblPdtPrice: UILabel!
       @IBOutlet weak var lblPdtName: UILabel!
       @IBOutlet weak var imgPdt: SDAnimatedImageView!
       @IBOutlet weak var viewBG: UIView!
    
    @IBOutlet weak var viewOutOfStock: UIView!
    
    @IBOutlet weak var viewOutStock: UIView!
    @IBOutlet weak var lblOUtOfStock: UILabel!

}
