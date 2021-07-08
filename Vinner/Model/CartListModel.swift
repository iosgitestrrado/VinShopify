//
//  CartListModel.swift
//  Vinner
//
//  Created by softnotions on 10/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import Foundation
import SwiftyJSON
class CartListModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let cartListData: CartListData?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        cartListData = CartListData(json["data"])
    }

}

class CartListData {

    let cart: Cart?
    let cartItems: [CartItems]?
    let address: Address?

    init(_ json: JSON) {
        cart = Cart(json["cart"])
        cartItems = json["cart_items"].arrayValue.map { CartItems($0) }
        address = Address(json["address"])
    }

}

class Cart {

    let totalAmount: String?
    let grandTotal: String?
    let currency: String?

    init(_ json: JSON) {
        totalAmount = json["total_amount"].stringValue
        grandTotal = json["grand_total"].stringValue
        currency = json["currency"].stringValue
    }

}

class CartItems {

    let cartItemId: String?
    let cartId: String?
    let productId: String?
    let productName: String?
    let productQuantity: String?
    let productTotal: String?
    let currency: String?
    let categoryName: String?
    let delivery: String?
    let productImage: String?
    let current_stock:String

    init(_ json: JSON) {
        cartItemId = json["cart_item_id"].stringValue
        cartId = json["cart_id"].stringValue
        productId = json["product_id"].stringValue
        productName = json["product_name"].stringValue
        productQuantity = json["product_quantity"].stringValue
        productTotal = json["product_total"].stringValue
        currency = json["currency"].stringValue
        categoryName = json["category_name"].stringValue
        delivery = json["delivery"].stringValue
        productImage = json["product_image"].stringValue
        current_stock = json["current_stock"].stringValue

    }

}

class Address {
    
    let addressId: String?
    let addressType: String?
    let houseFlat: String?
    let zip: String?
    let roadName: String?
    let landmark: String?
    let defaultField: String?
    let city: String?
    let country: String?
    let name: String?


    init(_ json: JSON) {
        addressId = json["address_id"].stringValue
        addressType = json["address_type"].stringValue
        houseFlat = json["house_flat"].stringValue
        zip = json["zip"].stringValue
        roadName = json["road_name"].stringValue
        landmark = json["landmark"].stringValue
        defaultField = json["default"].stringValue
        city = json["city"].stringValue
        country = json["country"].stringValue
        name = json["name"].stringValue

    }

}
