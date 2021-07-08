//
//  OrderListModel.swift
//  Vinner
//
//  Created by softnotions on 14/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import Foundation
import SwiftyJSON

class OrderListModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let orderListModelData: [OrderListModelData]?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        orderListModelData = json["data"].arrayValue.map { OrderListModelData($0) }
    }

}

class OrderListModelData {

    let saleId: String?
    let productDetails: [ProductDetails]?
    let delivaryDatetime: String?
    let delivery_status: String?
    let order_id: String?
    let order_date : String?

    init(_ json: JSON) {
        saleId = json["sale_id"].stringValue
        productDetails = json["product_details"].arrayValue.map { ProductDetails($0) }
        delivaryDatetime = json["delivary_datetime"].stringValue
        delivery_status = json["delivery_status"].stringValue
        order_id = json["order_id"].stringValue
        order_date = json["order_date"].stringValue

    }

}
class ProductDetails
{

    let name: String?
    let image: String?
    let rating: String?
    let id: String?
    let review_id: String?

    init(_ json: JSON)
    {
        id = json["id"].stringValue
        name = json["name"].stringValue
        image = json["image"].stringValue
        rating = json["rating"].stringValue
        review_id = json["review_id"].stringValue

    }

}


