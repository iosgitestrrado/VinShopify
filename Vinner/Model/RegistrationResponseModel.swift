//
//  RegistrationResponseModel.swift
//  Vinner
//
//  Created by softnotions on 03/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import Foundation
import SwiftyJSON

class RegistrationResponseModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let registrationData: RegistrationData?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        registrationData = RegistrationData(json["data"])
    }

}
class RegistrationData {

    let accessToken: String?
    let name: String?
    let email: String?
    let mobile: String?
    let redirect: String?

    init(_ json: JSON) {
        accessToken = json["access_token"].stringValue
        name = json["name"].stringValue
        email = json["email"].stringValue
        mobile = json["mobile"].stringValue
        redirect = json["redirect"].stringValue
    }

}
