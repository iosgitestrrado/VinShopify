//
//  ViewReviewResponseModel.swift
//  Vinner
//
//  Created by MAC on 10/12/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import Foundation
import SwiftyJSON

class ViewReviewResponseModel {
   let httpcode: Int?
   let status: String?
   let message: String?
    let viewReviewData: ViewReviewData?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        viewReviewData = ViewReviewData(json["data"])
    }

}
class ViewReviewData {

    let review: Review?
   

    init(_ json: JSON) {
        review = Review(json["review"])

    }

}
class Review {

    let product_id: String?
    let rating: String?
    let review: String?
    let review_date: String?
    let review_id: String?
    let review_title: String?
    let status: String?
    let user_id: String?

    init(_ json: JSON) {
        product_id = json["product_id"].stringValue
        rating = json["rating"].stringValue
        review = json["review"].stringValue
        review_date = json["review_date"].stringValue
        review_id = json["review_id"].stringValue
        review_title = json["review_title"].stringValue
        status = json["status"].stringValue
        user_id = json["user_id"].stringValue

    }

}
