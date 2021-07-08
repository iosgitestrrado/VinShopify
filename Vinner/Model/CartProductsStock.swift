//
//  CartProductsStock.swift
//  Vinner
//
//  Created by MAC on 04/02/21.
//  Copyright © 2021 softnotions. All rights reserved.
//

import Foundation
//
import Foundation
import SwiftyJSON

class CartProductsStockModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let cartProductsStockData: [CartProductsStockData]?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        cartProductsStockData = json["data"].arrayValue.map { CartProductsStockData($0) }
    }

}

class CartProductsStockData {

    let product_id: String?
    let qty: String?
    let stock: String?
    let out_of_stock: String?

    init(_ json: JSON) {
        product_id = json["product_id"].stringValue
        qty = json["qty"].stringValue
        stock = json["stock"].stringValue
        out_of_stock = json["out_of_stock"].stringValue
    }

}
