//
//  TrackOrderDetailsViewController.swift
//  Vinner
//
//  Created by MAC on 15/02/21.
//  Copyright © 2021 softnotions. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TrackOrderDetailsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    @IBOutlet weak var lblOrderId: UILabel!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var tbleProducts: UITableView!
    @IBOutlet weak var lblDeliveryStatus: UILabel!
    @IBOutlet weak var lblShippingoperator: UILabel!
    @IBOutlet weak var lblOrderdate: UILabel!
    
    let sharedData = SharedDefault()
    var trackOrderResponseModel:TrackOrderResponseModel?
    var products = [Products]()
    var track_orderData: Track_orderData?
    var iRowCount:Int? = 0
    var sTrackOrderId:String? = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton(title: "Track Order Details")
        
        tbleProducts.delegate = self
        tbleProducts.dataSource = self

        view1.layer.cornerRadius = 8.0
        view1.layer.borderColor = UIColor.lightGray.cgColor
        view1.layer.borderWidth = 2.0
        self.GetTrackOrderDetails()
        // Do any additional setup after loading the view.
    }
    // MARK: - tableview delegate
       
       var tableViewHeight: CGFloat {
        tbleProducts.layoutIfNeeded()
           
           return tbleProducts.contentSize.height
       }
    func numberOfSections(in tableView: UITableView) -> Int {
     return  1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           var cell = UITableViewCell()
           if tableView == tbleProducts {
               let statusTableCell = tbleProducts.dequeueReusableCell(withIdentifier: "StatusTCell", for: indexPath) as! StatusTCell
            statusTableCell.viewBG.layer.cornerRadius = 5.0
            
            statusTableCell.lblStatus.text = String(indexPath.row + 1)
            statusTableCell.lblAddress.text = self.products[indexPath.row].name
            
               cell = statusTableCell
           }
           
           return cell
       }
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           print("tableNotification ",indexPath.row)
           print("tableNotification section ",indexPath.section)
           
       }
       

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - get order detail
    func GetTrackOrderDetails()
    {
        self.view.activityStartAnimating()

        let loginURL = Constants.baseURL+Constants.trackOrderUrl
        print("loginURL",loginURL)
        
        var postDict = Dictionary<String,String>()
        postDict = ["access_token":sharedData.getAccessToken(),
                    "order_id":sTrackOrderId!
  
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

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {

                            self.track_orderData = (self.trackOrderResponseModel?.viewTrackOrderData?.track_orderData!)!
                            
                            self.products = (self.track_orderData?.products)!

                            print("TRack  ID",self.track_orderData?.track_id)
                            print("TRack order expt_to",self.track_orderData?.expt_to ?? "")
                            print("TRack order expt_from",self.track_orderData?.expt_from ?? "")
                            print("TRack order track_id",self.track_orderData?.track_id ?? "")
                            print("TRack order track_link",self.track_orderData?.track_link ?? "")
                            print("TRack order order_id",self.track_orderData?.order_id ?? "")
                            self.lblDeliveryStatus.text = self.track_orderData?.d_status ?? ""

                            if self.track_orderData?.d_status == "delivered"
                            {
                                self.lblDeliveryStatus.text = "Delivered"
                                self.lblDeliveryStatus.textColor = UIColor.systemGreen

                            }
                            else if self.track_orderData?.d_status == "pending"
                            {
                                self.lblDeliveryStatus.text = "Pending"
                                self.lblDeliveryStatus.textColor = UIColor.systemBlue
                            }
                            else if self.track_orderData?.d_status == "on_delivery"
                            {
                                self.lblDeliveryStatus.text = "On delivery"
                                self.lblDeliveryStatus.textColor = UIColor.systemRed


                            }
                            
                            self.lblOrderId.text = self.track_orderData?.order_id ?? ""
                            self.lblOrderdate.text = self.track_orderData?.order_date ?? ""
                            self.lblShippingoperator.text = self.track_orderData?.ship_operator ?? ""
                            
                            print("TRack order order_date",self.track_orderData?.order_date ?? "")
                            print("TRack order d_status",self.track_orderData?.d_status ?? "")
                            print("TRack order ship_operator",self.track_orderData?.ship_operator ?? "")
                            self.products = (self.track_orderData?.products)!
                            
                            if self.products.count > 0
                            {
                                self.tbleProducts.reloadData()
                            }
                            self.view.activityStopAnimating()
                           
                        }
                    }
                    if statusCode == 400{
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
}
