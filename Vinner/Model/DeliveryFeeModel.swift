//
//  DeliveryFeeModel.swift
//  Vinner
//
//  Created by softnotions on 19/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import Foundation
import SwiftyJSON

class DeliveryFeeModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let deliveryFeeData: DeliveryFeeData?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        deliveryFeeData = DeliveryFeeData(json["data"])
    }

}

class DeliveryFeeData {

    let totalWeight: Int?
    let price: String?
    let deliveryFee: String?
    let subTotal: String?
    let totalAmount: String?
    let currency: String?
    let deliveryExpDate: String?

    init(_ json: JSON) {
        totalWeight = json["total_weight"].intValue
        price = json["price"].stringValue
        deliveryFee = json["delivery_fee"].stringValue
        subTotal = json["sub_total"].stringValue
        totalAmount = json["total_amount"].stringValue
        currency = json["currency"].stringValue
        deliveryExpDate = json["delivery_exp_date"].stringValue
    }

}
