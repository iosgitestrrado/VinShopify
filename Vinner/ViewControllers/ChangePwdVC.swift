//
//  ChangePwdVC.swift
//  Vinner
//
//  Created by softnotions on 31/07/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import SDWebImage

class ChangePwdVC: UIViewController {

    @IBOutlet weak var imgProfile: SDAnimatedImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imgProfile.layer.cornerRadius = imgProfile.frame.size.height/2
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
