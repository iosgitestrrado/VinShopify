//
//  ServiceTypListModel.swift
//  Vinner
//
//  Created by softnotions on 18/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import Foundation
import SwiftyJSON

class ServiceTypListModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let serviceTypListData: [ServiceTypListData]?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        serviceTypListData = json["data"].arrayValue.map { ServiceTypListData($0) }
    }

}

class ServiceTypListData {

    let serviceTypeId: String?
    let serviceType: String?

    init(_ json: JSON) {
        serviceTypeId = json["service_type_id"].stringValue
        serviceType = json["service_type"].stringValue
    }

}
