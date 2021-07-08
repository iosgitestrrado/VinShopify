//
//  BagTableCell.swift
//  Vinner
//
//  Created by softnotions on 22/07/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import SDWebImage
import Cosmos

class BagTableCell: UITableViewCell {

    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var lblDelivery: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnDec: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblPdtName: UILabel!
    @IBOutlet weak var imgProduct: SDAnimatedImageView!
    @IBOutlet weak var viewTableBG: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
