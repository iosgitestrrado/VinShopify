//
//  ProfileModel.swift
//  Vinner
//
//  Created by softnotions on 12/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import Foundation
import SwiftyJSON

class ProfileModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let profileData: ProfileData?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        profileData = ProfileData(json["data"])
    }

}
class ProfileData {

    let userId: String?
    let name: String?
    let address1: String?
    let address2: String?
    let post: String?
    let state: String?
    let mobile: String?
    let email: String?
    let district: String?
    let path: String?
    let city: String?

    init(_ json: JSON) {
        userId = json["user_id"].stringValue
        name = json["name"].stringValue
        address1 = json["address1"].stringValue
        address2 = json["address2"].stringValue
        post = json["post"].stringValue
        state = json["state"].stringValue
        mobile = json["mobile"].stringValue
        email = json["email"].stringValue
        district = json["district"].stringValue
        path = json["path"].stringValue
        city = json["city"].stringValue

    }

}
