//
//  CountryList.swift
//  Vinner
//
//  Created by softnotions on 07/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import Foundation
import SwiftyJSON

class CountryListModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let countryData: [CountryData]?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        countryData = json["data"].arrayValue.map { CountryData($0) }
    }

}
class CountryData {

    let countryId: String?
    let countryName: String?
    let countryCode: String?

    init(_ json: JSON) {
        countryId = json["country_id"].stringValue
        countryName = json["country_name"].stringValue
        countryCode = json["country_code"].stringValue
    }

}
