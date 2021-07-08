//
//  StateList.swift
//  Vinner
//
//  Created by softnotions on 07/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import Foundation
import SwiftyJSON

class StateListModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let stateData: [StateData]?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        stateData = json["data"].arrayValue.map { StateData($0) }
    }

}
class StateData {

    let stateId: String?
    let stateName: String?
    let countryId: String?

    init(_ json: JSON) {
        stateId = json["state_id"].stringValue
        stateName = json["state_name"].stringValue
        countryId = json["country_id"].stringValue
    }

}
