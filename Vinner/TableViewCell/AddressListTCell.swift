//
//  AddressListTCell.swift
//  Vinner
//
//  Created by softnotions on 02/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit

class AddressListTCell: UITableViewCell {

    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var imgDefault: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblHouseName: UILabel!
    @IBOutlet weak var lblAddrType: UILabel!
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
