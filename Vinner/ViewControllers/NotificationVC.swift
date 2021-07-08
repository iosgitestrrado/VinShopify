//
//  NotificationVC.swift
//  Vinner
//
//  Created by softnotions on 01/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NotificationVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
var sections: Array<String> = ["Section 1", "Section 2", "Section 3"]
    @IBOutlet weak var tableNotification: UITableView!
    let sharedData = SharedDefault()
    var notificationResponseModel: NotificationResponseModel?
    var  notificationListModelData =  [NotificationListModelData]()
    
    var  notificationListDetails =  [NotificationListDetails]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addBackButton(title: "Notifications")
        // Do any additional setup after loading the view.
        tableNotification.delegate = self
        tableNotification.dataSource = self
        self.GetNotifications()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if tableView == tableNotification {
            let cellNotify = tableNotification.dequeueReusableCell(withIdentifier: "NotificationTCell", for: indexPath) as! NotificationTCell
            //cellBal.layer.cornerRadius = 15
            //cellBal.clipsToBounds = true
            //cellBal.selectionStyle = .none
            
//            cellNotify.viweBGLeading.constant = 0.0
//            cellNotify.layer.borderWidth = 1
//            cellNotify.layer.borderColor = Constants.borderColor.cgColor
//            cellNotify.layer.cornerRadius = 5
//            cellNotify.clipsToBounds = true
            
            if self.notificationListDetails[indexPath.row].notify_type == "place_order"
            {
                cellNotify.imgNotification.image = UIImage(named: "Cart_Notification")
            }
            else if self.notificationListDetails[indexPath.row].notify_type == "delivery_status"
            {
                
                cellNotify.imgNotification.image = UIImage(named: "Delivery_Notification")
            }
            else if self.notificationListDetails[indexPath.row].notify_type == "payment_status"
            {
                cellNotify.imgNotification.image = UIImage(named: "Money_Notification")

            }
            else if self.notificationListDetails[indexPath.row].notify_type == "review_status"
            {
                cellNotify.imgNotification.image = UIImage(named: "Star_Notification")

            }
            cellNotify.lblTitle.text = self.notificationListDetails[indexPath.row].title
            cellNotify.lblDescribe.text = self.notificationListDetails[indexPath.row].desc
            
            cellNotify.selectionStyle = .none
            cell = cellNotify
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tableNotification ",indexPath.row)
        print("tableNotification section ",indexPath.section)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationListDetails.count
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//           return self.sections[section]
//       }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
//
//        let label = UILabel()
//        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
//        label.text = "Notification Times"
//        //label.font = UIFont().futuraPTMediumFont(16) // my custom font
//        //label.textColor = UIColor.charcolBlackColour() // my custom colour
//
//        headerView.addSubview(label)
//
//        return headerView
//    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    // MARK: - get order list
    func GetNotifications(){
        self.view.activityStartAnimating()
        
        let loginURL = Constants.baseURL+Constants.notificationsURL
        print("loginURL",loginURL)
        
        var postDict = Dictionary<String,String>()
        postDict = ["access_token":sharedData.getAccessToken()
            
        ]
        
        AF.request(loginURL, method: .post, parameters: postDict, encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
            print("Response:***:",data.description)
            
            switch (data.result) {
            case .failure(let error) :
                self.view.activityStopAnimating()
                
                if error._code == NSURLErrorTimedOut {
                    self.showToast(message: "Request timed out! Please try again!")
                }
                else if error._code == 4 {
                    self.showToast(message: "Internal server error! Please try again!")
                }
                else if error._code == -1003 {
                    self.showToast(message: "Server error! Please contact support!")
                }
            case .success :
                do {
                    let response = JSON(data.data!)
                    self.notificationResponseModel = NotificationResponseModel(response)
                    let statusCode = Int((self.notificationResponseModel?.httpcode)!)
                    if statusCode == 200{
                       
                            self.notificationListDetails.removeAll()
                        self.notificationListDetails = (self.notificationResponseModel?.notificationListModelData?.notificationListDetails)!
                        
                        
                        if self.notificationListDetails.count == 0
                        {
                            self.showToast(message:"No records found.")

                        }
                        else
                        {
                            self.tableNotification.reloadData()
                        }
                           
                            self.view.activityStopAnimating()

                    }
                    if statusCode == 400{
                        self.view.activityStopAnimating()
                        self.showToast(message: (self.notificationResponseModel?.message)!)
                    }
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    
    
}
