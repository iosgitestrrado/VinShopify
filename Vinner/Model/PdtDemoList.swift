//
//  PdtDemoList.swift
//  Vinner
//
//  Created by softnotions on 18/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import Foundation
import SwiftyJSON

class PdtDemoList {

    let httpcode: Int?
    let status: String?
    let message: String?
    let pdtDemoData: [PdtDemoData]?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        pdtDemoData = json["data"].arrayValue.map { PdtDemoData($0) }
    }

}
class PdtDemoData {

    let productId: String?
    let productTitle: String?

    init(_ json: JSON) {
        productId = json["product_id"].stringValue
        productTitle = json["product_title"].stringValue
    }

}
