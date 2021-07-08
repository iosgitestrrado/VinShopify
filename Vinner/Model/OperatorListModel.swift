//
//  OperatorListModel.swift
//  Vinner
//
//  Created by softnotions on 19/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import Foundation
import SwiftyJSON

class OperatorListModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let operatorData: [OperatorData]?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        operatorData = json["data"].arrayValue.map { OperatorData($0) }
    }

}

class OperatorData {

    let shippingOperatorId: String?
    let operatorField: String?

    init(_ json: JSON) {
        shippingOperatorId = json["shipping_operator_id"].stringValue
        operatorField = json["operator"].stringValue
    }

}
