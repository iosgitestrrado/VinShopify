//
//  StatusTCell.swift
//  Vinner
//
//  Created by softnotions on 28/07/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit

class StatusTCell: UITableViewCell {

    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
