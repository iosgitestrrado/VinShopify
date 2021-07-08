//
//  IndustryListModel.swift
//  Vinner
//
//  Created by softnotions on 06/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import Foundation
import SwiftyJSON

class IndustryListModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let industryListData: [IndustryListData]?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        industryListData = json["data"].arrayValue.map { IndustryListData($0) }
    }

}
class IndustryListData {

    let industryId: String?
    let industryName: String?
    let industryImage: String?

    init(_ json: JSON) {
        industryId = json["industry_id"].stringValue
        industryName = json["industry_name"].stringValue
        industryImage = json["industry_image"].stringValue
    }

}
