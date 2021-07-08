//
//  ViewReviewMOdel.swift
//  Vinner
//
//  Created by MAC on 10/12/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import Foundation
import SwiftyJSON

class ViewReviewResponseModel {
   let httpcode: Int?
   let status: String?
   let message: String?
    let homeData: HomeData?

    init(_ json: JSON) {
        httpcode = json["httpcode"].intValue
        status = json["status"].stringValue
        message = json["message"].stringValue
        homeData = HomeData(json["data"])
    }

}
