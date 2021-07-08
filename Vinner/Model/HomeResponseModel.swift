//
//  HomeResponseModel.swift
//  Vinner
//
//  Created by softnotions on 05/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import Foundation
import SwiftyJSON

class HomeResponseModel {
   let httpcode: Int?
   let status: String?
   let message: String?
    let homeData: HomeData?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        homeData = HomeData(json["data"])
    }

}
class HomeData {

    let logo: String?
    let notify_count: Int?
    let push_count: Int?

    let bannerSlider: [BannerSlider]?
    let featured: [Featured]?
    let categories: [Categories]?
    let profiledata: Profiledata?
    let regions: [Regions]?
    let cartcount: String?

    init(_ json: JSON) {
        logo = json["logo"].stringValue
        bannerSlider = json["banner_slider"].arrayValue.map { BannerSlider($0) }
        featured = json["featured"].arrayValue.map { Featured($0) }
        categories = json["categories"].arrayValue.map { Categories($0) }
        profiledata = Profiledata(json["profiledata"])
        regions = json["regions"].arrayValue.map { Regions($0) }
        cartcount = json["cartcount"].stringValue
        notify_count = json["notify_count"].intValue
        push_count = json["push_count"].intValue

    }

}
class BannerSlider {

    let sliderId: String?
    let sliderName: String?
    let sliderImage: String?

    init(_ json: JSON) {
        sliderId = json["slider_id"].stringValue
        sliderName = json["slider_name"].stringValue
        sliderImage = json["slider_image"].stringValue
    }

}

class Featured {

    let prdId: String?
    let prdName: String?
    let prdImage: String?
    let qty: String?
    let unit: String?
    let current_stock: String?

    let price: String?
    let currency: String?
    let rating: String?

    init(_ json: JSON)
    {
        prdId = json["prd_id"].stringValue
        prdName = json["prd_name"].stringValue
        prdImage = json["prd_image"].stringValue
        qty = json["qty"].stringValue
        unit = json["unit"].stringValue
        current_stock = json["current_stock"].stringValue
        price = json["price"].stringValue
        currency = json["currency"].stringValue
        rating = json["rating"].string
    }

}


class Categories {

    let categoryId: String?
    let categoryName: String?
    let categoryImage: String?

    init(_ json: JSON) {
        categoryId = json["category_id"].stringValue
        categoryName = json["category_name"].stringValue
        categoryImage = json["category_image"].stringValue
    }

}

class Profiledata {

  let name: String?
    let email: String?
    let mobile: String?
    let address1: String?
    let address2: String?
    let post: String?
    let state: String?
    let district: String?
    let image: String?

    init(_ json: JSON) {
        name = json["name"].stringValue
        email = json["email"].stringValue
        mobile = json["mobile"].stringValue
        address1 = json["address1"].stringValue
        address2 = json["address2"].stringValue
        post = json["post"].stringValue
        state = json["state"].stringValue
        district = json["district"].stringValue
        image = json["image"].stringValue
    }

}
class Regions {

    let countryId: String?
    let countryCode: String?
    let countryName: String?

    init(_ json: JSON) {
        countryId = json["country_id"].stringValue
        countryCode = json["country_code"].stringValue
        countryName = json["country_name"].stringValue
    }

}
