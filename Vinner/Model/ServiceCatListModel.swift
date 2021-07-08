//
//  ServiceCatListModel.swift
//  Vinner
//
//  Created by softnotions on 18/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import Foundation
import SwiftyJSON

class ServiceCatListModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let serviceCatListData: [ServiceCatListData]?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        serviceCatListData = json["data"].arrayValue.map { ServiceCatListData($0) }
    }

}
class ServiceCatListData {

    let serviceCategoryId: String?
    let serviceCategoryName: String?

    init(_ json: JSON) {
        serviceCategoryId = json["service_category_id"].stringValue
        serviceCategoryName = json["service_category_name"].stringValue
    }

}
