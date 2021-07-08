//
//  CategoryCCell.swift
//  Vinner
//
//  Created by softnotions on 20/07/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import SDWebImage

class CategoryCCell: UICollectionViewCell {
    @IBOutlet weak var viewWidth: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblCatName: UILabel!
    @IBOutlet weak var imgCategory: SDAnimatedImageView!
    @IBOutlet weak var viewImgBG: UIView!
    @IBOutlet weak var viewBG: UIView!
    
    //image constraints
    
    @IBOutlet weak var imgTop: NSLayoutConstraint!
    @IBOutlet weak var imgLeading: NSLayoutConstraint!
    @IBOutlet weak var imgTrailing: NSLayoutConstraint!
    @IBOutlet weak var imgBottomConstraint: NSLayoutConstraint!
}
