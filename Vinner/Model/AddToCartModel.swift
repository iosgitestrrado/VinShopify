//
//  AddToCartModel.swift
//  Vinner
//
//  Created by softnotions on 10/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import Foundation
import SwiftyJSON

class AddToCartModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let addToCartData: AddToCartData?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        addToCartData = AddToCartData(json["data"])
    }

}

class AddToCartData {

    let cartId: Int?
    let vendorId: String?
    let ptoductId: String?
    let productName: String?
    let productQty: String?
    let productPrice: String?
    let productTotal: String?
    let totalAmount: String?
    let grandTotal: String?

    init(_ json: JSON) {
        cartId = json["cart_id"].intValue
        vendorId = json["vendor_id"].stringValue
        ptoductId = json["ptoduct_id"].stringValue
        productName = json["product_name"].stringValue
        productQty = json["product_qty"].stringValue
        productPrice = json["product_price"].stringValue
        productTotal = json["product_total"].stringValue
        totalAmount = json["total_amount"].stringValue
        grandTotal = json["grand_total"].stringValue
    }

}
