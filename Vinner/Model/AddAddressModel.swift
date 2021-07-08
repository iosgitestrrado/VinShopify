//
//  AddAddressModel.swift
//  Vinner
//
//  Created by softnotions on 11/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import Foundation
import SwiftyJSON

class AddAddressModel {

    let httpcode: Int?
    let status: String?
    let message: String?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
    }

}
