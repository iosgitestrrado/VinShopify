//
//  NotificationTCell.swift
//  Vinner
//
//  Created by softnotions on 01/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import SDWebImage

class NotificationTCell: UITableViewCell {

    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var viweBGLeading: NSLayoutConstraint!
    @IBOutlet weak var lblDescribe: UILabel!
    @IBOutlet weak var lblTitle: UILabel!

    @IBOutlet weak var imgNotification: UIImageView!
    

    @IBOutlet weak var viewBG: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewImage.layer.cornerRadius = 25
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
