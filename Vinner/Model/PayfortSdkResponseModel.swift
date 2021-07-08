//
//  PayfortSdkResponseModel.swift
//  Vinner
//
//  Created by MAC on 23/03/21.
//  Copyright © 2021 softnotions. All rights reserved.
//

import Foundation
import SwiftyJSON
class PayfortSdkResponseModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let sdk_token: Sdk_token?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        sdk_token = Sdk_token(json["data"])
    }

}

class Sdk_token {
    
    let sdk_tokenData: Sdk_tokenData?
    
    init(_ json: JSON) {
       
        sdk_tokenData = Sdk_tokenData(json["sdk_token"])
    }
    
}

class Sdk_tokenData {

    let response_code: String?
    let device_id: String?
    let response_message: String?
    let service_command: String?
    let sdk_token: String?
    let signature: String?
    let merchant_identifier: String?
    let access_code: String?
    let language: String?
    let status: String?
    let merchant_reference: String?

    init(_ json: JSON) {
        response_code = json["response_code"].stringValue
        device_id = json["device_id"].stringValue
        response_message = json["response_message"].stringValue
        service_command = json["service_command"].stringValue
        sdk_token = json["sdk_token"].stringValue
        signature = json["signature"].stringValue
        merchant_identifier = json["merchant_identifier"].stringValue
        merchant_reference = json["merchant_reference"].stringValue

        access_code = json["access_code"].stringValue
        language = json["language"].stringValue
        status = json["status"].stringValue

    }


}
