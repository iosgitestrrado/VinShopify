//
//  VerifyOTPResponseModel.swift
//  Vinner
//
//  Created by softnotions on 03/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import Foundation
import SwiftyJSON

class VerifyOTPResponseModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let verifyOTPData: VerifyOTPData?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        verifyOTPData = VerifyOTPData(json["data"])
    }
}

class VerifyOTPData {

    let accessToken: String?
    let email: String?
    let username: String?
    let mobile: String?
    let redirect: String?

    init(_ json: JSON) {
        accessToken = json["access_token"].stringValue
        email = json["email"].stringValue
        username = json["username"].stringValue
        mobile = json["mobile"].stringValue
        redirect = json["redirect"].stringValue
    }

}
