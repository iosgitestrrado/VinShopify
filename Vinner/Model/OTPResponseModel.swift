//
//  OTPResponseModel.swift
//  Vinner
//
//  Created by softnotions on 03/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import Foundation
import SwiftyJSON

class OTPResponseModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let otpResponseData: OTPResponseData?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        otpResponseData = OTPResponseData(json["data"])
    }

}

class OTPResponseData {

    let otp: Int?

    init(_ json: JSON) {
        otp = json["otp"].intValue
    }

}


