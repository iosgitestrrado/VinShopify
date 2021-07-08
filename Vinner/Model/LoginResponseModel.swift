//
//  LoginRespModel.swift
//  Vinner
//
//  Created by softnotions on 03/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import Foundation
import SwiftyJSON

class LoginResponseModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let loginData: LoginData?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        loginData = LoginData(json["data"])
    }

}
class LoginData {

    let accessToken: Int?
    let name: String?
    let email: String?
    let mobile: String?
    let redirect: String?

    init(_ json: JSON) {
        accessToken = json["access_token"].intValue
        name = json["name"].stringValue
        email = json["email"].stringValue
        mobile = json["mobile"].stringValue
        redirect = json["redirect"].stringValue
    }

}
