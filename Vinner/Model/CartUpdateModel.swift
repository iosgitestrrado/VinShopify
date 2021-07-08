//
//  CartUpdateModel.swift
//  Vinner
//
//  Created by softnotions on 10/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//
import Foundation
import SwiftyJSON

class CartUpdateModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let cartUpdateData: CartUpdateData?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        cartUpdateData = CartUpdateData(json["data"])
    }

}

class CartUpdateData {

    let productQty: String?
    let productTotal: String?
    let totalAmount: String?
    let grandTotal: String?

    init(_ json: JSON) {
        productQty = json["product_qty"].stringValue
        productTotal = json["product_total"].stringValue
        totalAmount = json["total_amount"].stringValue
        grandTotal = json["grand_total"].stringValue
    }

}
