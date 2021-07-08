//
//  OrderDetailModel.swift
//  Vinner
//
//  Created by softnotions on 15/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import Foundation
import SwiftyJSON

class OrderDetailModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let orderDetailModelData: OrderDetailModelData?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        orderDetailModelData = OrderDetailModelData(json["data"])
    }

}
class OrderDetailModelData {

    let orderDate: String?
    let orderId: String?
    let orderTotal: String?
    let itemsCount: Int?
    let productDetails: [ProductDetail]?
    let currency: String?
    let ordered: String?
    let delivered: String?
    let paymentMethod: String?
    let billingAddress: [BillingAddress]?
    let shippingAddress: [ShippingAddress]?
    let totalAmount: String?
    let shippingCost: String?
    let grandTotal: String?
     let tax: String?
    let paymentStatus: [PaymentStatus]?
    let deliveryStatus: String?
    
    init(_ json: JSON) {
        orderDate = json["order_date"].stringValue
        orderId = json["order_id"].stringValue
        orderTotal = json["order_total"].stringValue
        itemsCount = json["items_count"].intValue
        productDetails = json["product_details"].arrayValue.map { ProductDetail($0) }
        currency = json["currency"].stringValue
        ordered = json["ordered"].stringValue
        delivered = json["delivered"].stringValue
        deliveryStatus = json["delivery_status"].stringValue
        paymentMethod = json["payment_method"].stringValue
        billingAddress = json["billing_address"].arrayValue.map { BillingAddress($0) }
        shippingAddress = json["shipping_address"].arrayValue.map { ShippingAddress($0) }
        totalAmount = json["total_amount"].stringValue
        shippingCost = json["shipping_cost"].stringValue
        grandTotal = json["grand_total"].stringValue
        tax = json["tax"].stringValue
        paymentStatus = json["payment_status"].arrayValue.map { PaymentStatus($0) }
    }

}
class ProductDetail {

    let name: String?
    let image: String?
    let price: String?
    let rating: String?
    let qty: String?
    let subtotal: String?
    let id: String?
    let review_id: String?


    init(_ json: JSON) {
        name = json["name"].stringValue
        image = json["image"].stringValue
        price = json["price"].stringValue
        rating = json["rating"].stringValue
        qty = json["qty"].stringValue
        subtotal = json["subtotal"].stringValue
        id = json["id"].stringValue
        review_id = json["review_id"].stringValue

    }

}
class BillingAddress {

    let addressType: String?
    let houseFlat: String?
    let roadName: String?
    let landmark: String?
    let zip: String?
    let name : String?
    let country : String?

    init(_ json: JSON) {
        addressType = json["address_type"].stringValue
        houseFlat = json["house_flat"].stringValue
        roadName = json["road_name"].stringValue
        landmark = json["landmark"].stringValue
        zip = json["zip"].stringValue
        name = json["name"].stringValue
        country = json["country"].stringValue

    }

}
class ShippingAddress {

    let sAddressType: String?
    let sHouseFlat: String?
    let sRoadName: String?
    let sLandmark: String?
    let sZip: String?
    let name : String?
    let s_country: String?

    init(_ json: JSON) {
        sAddressType = json["s_address_type"].stringValue
        sHouseFlat = json["s_house_flat"].stringValue
        sRoadName = json["s_road_name"].stringValue
        sLandmark = json["s_landmark"].stringValue
        sZip = json["s_zip"].stringValue
        name = json["name"].stringValue
        s_country = json["s_country"].stringValue

    }

}

class PaymentStatus {

    let vendor: String?
    let status: String?

    init(_ json: JSON) {
        vendor = json["vendor"].stringValue
        status = json["status"].stringValue
    }

}
