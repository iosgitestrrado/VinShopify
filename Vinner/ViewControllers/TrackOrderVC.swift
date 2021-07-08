//
//  TrackOrderVC.swift
//  Vinner
//
//  Created by softnotions on 23/07/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire
import SwiftyJSON

class TrackOrderVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var txtOrderID: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    let sharedData = SharedDefault()
    var trackOrderResponseModel:TrackOrderResponseModel?
    var products = [Products]()
    var track_orderData: Track_orderData?
    var iRowCount:Int? = 0
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.addBackButton(title: "Track Order")
        
//        let image : UIImage = UIImage(named: "logo")!
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
//        imageView.contentMode = .scaleToFill
//        imageView.image = image
        //navigationItem.titleView = imageView

//        navigationView.addSubview(imageView)

//        navigationItem.titleView = imageView
        
        txtOrderID.text = ""
        txtOrderID.delegate = self
        
    }
    
    

    
    // MARK: - Textfield Delegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addBottomBorderTextfield(textField: txtOrderID, placeHolderText: "Order ID")
        
//        self.tabBar.barTintColor = GREEN_Theme
//            self.tabBar.isTranslucent = true
//            self.tabBar.tintColor = .white
        
//        self.tabBar.barTintColor = UIColor.green.cgColor
//           self.tabBar.isTranslucent = true
//           self.tabBar.tintColor = .white
//        
        
        
    }
    // MARK: - tableview delegate
       
//       var tableViewHeight: CGFloat {
//           tableStatus.layoutIfNeeded()
//
//           return tableStatus.contentSize.height
//       }
//
//       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//           var cell = UITableViewCell()
//           if tableView == tableStatus {
//               let statusTableCell = tableStatus.dequeueReusableCell(withIdentifier: "StatusTCell", for: indexPath) as! StatusTCell
//            statusTableCell.viewBG.layer.cornerRadius = 5.0
//            statusTableCell.lblStatus.text = self.track_orderData?.d_status
//
//            if self.track_orderData?.d_status == "delivered"
//            {
//                statusTableCell.lblStatus.text = "Delivered"
//
//            }
//            else if self.track_orderData?.d_status == "pending"
//            {
//                statusTableCell.lblStatus.text = "Pending"
//
//            }
//            else if self.track_orderData?.d_status == "on_delivery"
//            {
//                statusTableCell.lblStatus.text = "On delivery"
//
//            }
//            statusTableCell.lblAddress.text = self.track_orderData?.track_link
//            statusTableCell.lblAddress.text = self.track_orderData?.ship_operator
//               cell = statusTableCell
//           }
//
//           return cell
//       }
//       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//           print("tableNotification ",indexPath.row)
//           print("tableNotification section ",indexPath.section)
//
//       }
//       func numberOfSections(in tableView: UITableView) -> Int {
//        return  iRowCount!
//       }
//
//       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return iRowCount!
//       }
//       // Make the background color show through
//       func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//           let headerView = UIView()
//           headerView.backgroundColor = UIColor.clear
//           return headerView
//       }
//
//       func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//           return 0.0
//       }
    @IBAction func btnSubmitAction(_ sender: UIButton)
    {
        if txtOrderID.text?.count == 0
        {
            self.txtOrderID.resignFirstResponder()
            self.showToast(message: "Order Id is missing")
        }
        else
        {
//            self.GetTrackOrderDetails()
            
            let next = self.storyboard?.instantiateViewController(withIdentifier: "TrackOrderDetailsViewController") as? TrackOrderDetailsViewController
            next!.sTrackOrderId = self.txtOrderID.text
            self.navigationController?.pushViewController(next!, animated: true)
            
            
            
        }
    }
    // MARK: - get order detail
    func GetTrackOrderDetails()
    {
        self.view.activityStartAnimating()

        let loginURL = Constants.baseURL+Constants.trackOrderUrl
        print("loginURL",loginURL)
        
        var postDict = Dictionary<String,String>()
        postDict = ["access_token":sharedData.getAccessToken(),
                    "order_id":txtOrderID.text!
  
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
                    self.trackOrderResponseModel = TrackOrderResponseModel(response)
                    let statusCode = Int((self.trackOrderResponseModel?.httpcode)!)
                    if statusCode == 200{
                        self.txtOrderID.resignFirstResponder()

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {

                            self.track_orderData = (self.trackOrderResponseModel?.viewTrackOrderData?.track_orderData!)!

                            print("TRack  ID",self.track_orderData?.track_id)
                            print("TRack order expt_to",self.track_orderData?.expt_to ?? "")
                            print("TRack order expt_from",self.track_orderData?.expt_from ?? "")
                            print("TRack order track_id",self.track_orderData?.track_id ?? "")
                            print("TRack order track_link",self.track_orderData?.track_link ?? "")
                            print("TRack order order_id",self.track_orderData?.order_id ?? "")
                            print("TRack order order_date",self.track_orderData?.order_date ?? "")
                            print("TRack order d_status",self.track_orderData?.d_status ?? "")
                            print("TRack order ship_operator",self.track_orderData?.ship_operator ?? "")
                            self.iRowCount = 1
                            self.products = (self.track_orderData?.products)!
                            self.view.activityStopAnimating()
                           
                        }
                    }
                    if statusCode == 400{
                        self.txtOrderID.resignFirstResponder()
                        self.view.activityStopAnimating()
                        self.showToast(message: (self.trackOrderResponseModel?.message)!)

                    }
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
