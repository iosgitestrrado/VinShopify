//
//  ProductDetailResponseModel.swift
//  Vinner
//
//  Created by softnotions on 04/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import Foundation
import SwiftyJSON

class ProductDetailResponseModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let productDetailData: ProductDetailData?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        productDetailData = ProductDetailData(json["data"])
    }

}

class ProductDetailData {

   let product: Product?
   let reviews: [Reviews]?
   let relatedProducts: [RelatedProducts]?

   init(_ json: JSON) {
       product = Product(json["product"])
           reviews = json["reviews"].arrayValue.map { Reviews($0) }
           relatedProducts = json["related_products"].arrayValue.map { RelatedProducts($0) }
       }


}

class Product {

    let productId: String?
    let productName: String?
    let price: String?
    let currency: String?
    let rating: String?
    let reatedCustomers: Any?
    let description: String?
    let category: String?
    let productImage: [String]?
    let current_stock: String?
    let qty: String?
    let unit: String?
    let return_policy: String?
    let height: String?
    let length: String?
    let weight: String?
    let width: String?
    let product_url: String?

    let weight_unit: String?
    let dimension_unit: String?



    init(_ json: JSON) {
        productId = json["product_id"].stringValue
        productName = json["product_name"].stringValue
        price = json["price"].stringValue
        currency = json["currency"].stringValue
        rating = json["rating"].stringValue
        current_stock = json["current_stock"].stringValue
        qty = json["qty"].stringValue
        unit = json["unit"].stringValue
        return_policy = json["return_policy"].stringValue

        reatedCustomers = json["reated_customers"]
        description = json["description"].stringValue
        category = json["category"].stringValue
        productImage = json["product_image"].arrayValue.map { $0.stringValue }
        
        
        height = json["height"].stringValue
        length = json["length"].stringValue
        weight = json["weight"].stringValue
        width = json["width"].stringValue
        
        weight_unit = json["weight_unit"].stringValue
        dimension_unit = json["dim_unit"].stringValue
        product_url = json["product_url"].stringValue

        }

}

class Reviews {

    let user: String?
    let reviewTitle: String?
    let review: String?
    let rating: String?
    let reviewDate: String?

    init(_ json: JSON) {
        user = json["user"].stringValue
        reviewTitle = json["review_title"].stringValue
        review = json["review"].stringValue
        rating = json["rating"].stringValue
        reviewDate = json["review_date"].stringValue
    }

}


class RelatedProducts {

    let productId: String?
    let productTitle: String?
    let prdQty: String?
    let unit: String?
    let price: String?
    let currency: String?
    let productImage: String?
    let rating: String?

    init(_ json: JSON) {
        productId = json["product_id"].stringValue
        productTitle = json["product_title"].stringValue
        prdQty = json["prd_qty"].stringValue
        unit = json["unit"].stringValue
        price = json["price"].stringValue
        currency = json["currency"].stringValue
        productImage = json["product_image"].stringValue
        rating = json["rating"].stringValue
    }

}
