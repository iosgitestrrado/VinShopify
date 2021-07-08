//
//  CityList.swift
//  Vinner
//
//  Created by softnotions on 07/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import Foundation
import SwiftyJSON

class CityListModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let cityData: [CityData]?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        cityData = json["data"].arrayValue.map { CityData($0) }
    }

}
class CityData {

    let stateId: String?
    let stateName: String?
    let countryId: String?

    init(_ json: JSON) {
        stateId = json["state_id"].stringValue
        stateName = json["state_name"].stringValue
        countryId = json["country_id"].stringValue
    }

}
