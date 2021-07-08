//
//  CountryTCell.swift
//  Vinner
//
//  Created by softnotions on 20/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit

class CountryTCell: UITableViewCell {

    @IBOutlet weak var lblCountry2: UILabel!
    @IBOutlet weak var imgCountry2: UIImageView!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var imgCountry: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
