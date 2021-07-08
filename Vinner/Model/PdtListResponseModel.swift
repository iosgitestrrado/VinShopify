//
//  PdtListResponseModel.swift
//  Vinner
//
//  Created by softnotions on 04/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PdtListResponseModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let pdtListData: [PdtListData]?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        pdtListData = json["data"].arrayValue.map { PdtListData($0) }
    }

}

class PdtListData {

   let productId: String?
    let productTitle: String?
    let prdQty: String?
    let unit: String?
    let price: String?
    let currency: String?
    let productImage: String?
    let rating: String?
    let category: String?
    let current_stock: String?

    init(_ json: JSON) {
        productId = json["product_id"].stringValue
        productTitle = json["product_title"].stringValue
        prdQty = json["prd_qty"].stringValue
        unit = json["unit"].stringValue
        price = json["price"].stringValue
        currency = json["currency"].stringValue
        productImage = json["product_image"].stringValue
        rating = json["rating"].stringValue
        category = json["category"].stringValue
        current_stock = json["current_stock"].stringValue

    }



}
