//
//  ProfileUpRespModel.swift
//  Vinner
//
//  Created by softnotions on 12/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import Foundation
import SwiftyJSON

class ProfileUpRespModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let profileUpData: ProfileUpData?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        profileUpData = ProfileUpData(json["data"])
    }

}
class ProfileUpData {

    let redirect: String?

    init(_ json: JSON) {
        redirect = json["redirect"].stringValue
    }

}
