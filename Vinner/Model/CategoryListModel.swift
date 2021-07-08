//
//  CategoryListModel.swift
//  Vinner
//
//  Created by softnotions on 06/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//


import Foundation
import SwiftyJSON

class CategoryListModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let categoryListData: [CategoryListData]?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        categoryListData = json["data"].arrayValue.map { CategoryListData($0) }
    }

}

class CategoryListData {

    let categoryId: String?
    let categoryName: String?
    let categoryImage: String?

    init(_ json: JSON) {
        categoryId = json["category_id"].stringValue
        categoryName = json["category_name"].stringValue
        categoryImage = json["category_image"].stringValue
    }

}
