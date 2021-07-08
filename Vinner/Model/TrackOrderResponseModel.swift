//
//  TrackOrderResponseModel.swift
//  Vinner
//
//  Created by MAC on 15/12/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import Foundation
import SwiftyJSON

class TrackOrderResponseModel {
   let httpcode: Int?
   let status: String?
   let message: String?
    let viewTrackOrderData: ViewTrackOrderData?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
//        track_orderData = Track_orderData(json["data"])
        viewTrackOrderData = ViewTrackOrderData(json["data"])

    }

}
class ViewTrackOrderData {

    let track_orderData: Track_orderData?


    init(_ json: JSON) {
        track_orderData = Track_orderData(json["track_order"])

    }

}
class Track_orderData {

    let expt_to: String?
    let expt_from: String?
    let track_id: String?
    let track_link: String?
    
    let id: String?
    let order_id: String?
    let order_date: String?
    let d_status: String?
    
    let ship_operator: String?
    let products: [Products]?
  
    init(_ json: JSON) {
        expt_to = json["expt_to"].stringValue
        expt_from = json["expt_from"].stringValue
        track_id = json["track_id"].stringValue
        track_link = json["track_link"].stringValue
        
        id = json["id"].stringValue
        order_id = json["order_id"].stringValue
        order_date = json["order_date"].stringValue
        d_status = json["d_status"].stringValue
        ship_operator = json["ship_operator"].stringValue
        products = json["products"].arrayValue.map { Products($0) }

    }

}
class Products {

    let id: String?
    let name: String?

    init(_ json: JSON) {
        id = json["id"].stringValue
        name = json["name"].stringValue
    }

}
