//
//  NotificationResponseModel.swift
//  Vinner
//
//  Created by MAC on 16/02/21.
//  Copyright © 2021 softnotions. All rights reserved.
//

import Foundation
import SwiftyJSON

class NotificationResponseModel {

    let httpcode: Int?
    let status: String?
    let message: String?
    let notificationListModelData: NotificationListModelData?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        notificationListModelData = NotificationListModelData(json["data"])
    }

}

class NotificationListModelData {

    let notificationListDetails: [NotificationListDetails]?
   
    init(_ json: JSON) {
        notificationListDetails = json["notifications"].arrayValue.map { NotificationListDetails($0) }
       

    }

}


class NotificationListDetails {

    let notify_type: String?
    let title: String?
    let desc: String?
    let ref_id: String?
    let created: String?


    init(_ json: JSON) {
        notify_type = json["notify_type"].stringValue
        title = json["title"].stringValue
        desc = json["desc"].stringValue
        ref_id = json["ref_id"].stringValue
        created = json["created"].stringValue

    }

}
