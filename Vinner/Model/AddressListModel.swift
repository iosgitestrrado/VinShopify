//
//  AddressListModel.swift
//  Vinner
//
//  Created by softnotions on 11/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//
import Foundation
import SwiftyJSON

class AddressListModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let addressListData: [AddressListData]?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        addressListData = json["data"].arrayValue.map { AddressListData($0) }
    }

}

class AddressListData {

    let adrsId: String?
    let addressType: String?
    let address1: String?
    let zip: String?
    let roadName: String?
    let landmark: String?
    let defaultField: String?
    let city: String?
    let country: String?
    let name: String?

    init(_ json: JSON) {
        adrsId = json["adrs_id"].stringValue
        addressType = json["address_type"].stringValue
        address1 = json["house_flat"].stringValue
        zip = json["zip"].stringValue
        roadName = json["road_name"].stringValue
        landmark = json["landmark"].stringValue
        defaultField = json["default"].stringValue
        country = json["country"].stringValue
        city = json["city"].stringValue
        name = json["name"].stringValue

    }

}
