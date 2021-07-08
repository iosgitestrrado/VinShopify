//
//  SettingsTCell.swift
//  Vinner
//
//  Created by softnotions on 27/07/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit

class SettingsTCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgContent: UIImageView!
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
