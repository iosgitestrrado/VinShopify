//
//  OrderDetailsVC.swift
//  Vinner
//
//  Created by softnotions on 29/07/20.
//  Copyright © 2020 softnotions. All rights reserved.
//


import UIKit
import MobileCoreServices
import Alamofire
import SwiftyJSON

class OrderDetailsVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
var sections: Array<String> = ["Section 1", "Section 2", "Section 3"]
    var orderID:String?
   
    @IBOutlet weak var lblDelivered: UILabel!
    @IBOutlet weak var lblPaymentMethod: UILabel!
    @IBOutlet weak var lblBillingAddr: UILabel!
    @IBOutlet weak var lblShipAddre: UILabel!
    @IBOutlet weak var tablePdtList: UITableView!
    @IBOutlet weak var viewOrderSummary: UIView!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var viewPaymentMethod: UIView!
    @IBOutlet weak var viewDeliver: UIView!
    @IBOutlet weak var viewOrder: UIView!
    @IBOutlet weak var lblOrderTotData: UILabel!
    @IBOutlet weak var lblOrderNumData: UILabel!
    @IBOutlet weak var lblOrderDateData: UILabel!
    @IBOutlet weak var viewSummary: UIView!
    let sharedData = SharedDefault()
    var orderDetailModel:OrderDetailModel?
    var pdtList = [ProductDetail]()
    var shipAddr = [ShippingAddress]()
    var billAddr = [BillingAddress]()
    
    var paymentStat = [PaymentStatus]()
    
    @IBOutlet weak var lblBeforeTax: UILabel!
    
    @IBOutlet weak var viewLine2: UIView!
    @IBOutlet weak var viewOnDelivery: UIView!
    @IBOutlet weak var lblOrderTot: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblTaxAmt: UILabel!
    @IBOutlet weak var lblPackageFee: UILabel!
    @IBOutlet weak var lblItemTotal: UILabel!
    @IBOutlet weak var lblBDeliveryDate: UILabel!
    @IBOutlet weak var lblBOrderDate: UILabel!
    @IBOutlet weak var viewtableHeight: NSLayoutConstraint!
    /*
    override func viewWillLayoutSubviews() {
        viewtableHeight.constant = tablePdtList.contentSize.height
        super.updateViewConstraints()
    }
    override func updateViewConstraints() {
        viewtableHeight.constant = tablePdtList.contentSize.height
        super.updateViewConstraints()
    }
    */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if tableView == tablePdtList {
            let cellNotify = tablePdtList.dequeueReusableCell(withIdentifier: "OrderDetPdtTCell", for: indexPath) as! OrderDetPdtTCell
            cellNotify.imgPdt.sd_setImage(with: URL(string: pdtList[indexPath.section].image!), placeholderImage: UIImage(named: "Transparent"))
            cellNotify.lblPdtName.text = (self.pdtList[indexPath.section].name!)
            cellNotify.lblQuantity.text = "Quantity :" + "" + self.pdtList[indexPath.section].qty!
            
            
            if self.pdtList[indexPath.section].price == "0" ||  self.pdtList[indexPath.section].price == "" || self.pdtList[indexPath.section].price == nil
            {
                cellNotify.lblPdtPrice.text = ""
            
            }
            else
            {
                let iPricerate2 = self.ConvertCurrencyFormat(sNumber: Double(self.pdtList[indexPath.section].price!)! as NSNumber)
                let result2 = String(iPricerate2.dropFirst())
                cellNotify.lblPdtPrice.text = (self.orderDetailModel?.orderDetailModelData?.currency!)! + " " + result2
            }
            
            
            
            
//            cellNotify.lblPdtPrice.text = (self.pdtList[indexPath.section].price!) + " " + (self.orderDetailModel?.orderDetailModelData?.currency!)!
            
            
            cellNotify.ratingView.isHidden = true
            cellNotify.btnReview.isHidden = true
            
            cellNotify.layer.borderWidth = 1
            cellNotify.layer.borderColor = Constants.borderColor.cgColor
            cellNotify.layer.cornerRadius = 5
            cellNotify.clipsToBounds = true
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
        return self.pdtList.count
      }

      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return 1
      }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
             return self.sections[section]
    }
    
      func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
       /*
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "Notification Times"
        headerView.addSubview(label)
       */
        return headerView
    }
      func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
          return 15
      }
    
    override func viewWillAppear(_ animated: Bool) {
         self.addBackButton(title: "Order Details")
        self.navigationController?.navigationBar.topItem?.titleView = nil
        self.navigationController?.navigationBar.topItem?.title = ""

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //self.navigationController?.navigationBar.topItem?.title = "Order Details"
        
        viewOrderSummary.layer.cornerRadius = 5
        viewOrderSummary.layer.borderWidth = 1
        viewOrderSummary.layer.borderColor = Constants.borderColor.cgColor
        
        
        viewPaymentMethod.layer.cornerRadius = 5
        viewPaymentMethod.layer.borderWidth = 1
        viewPaymentMethod.layer.borderColor = Constants.borderColor.cgColor
        //viewLine.backgroundColor = Constants.borderColor
        
        viewSummary.layer.cornerRadius = 5
        viewSummary.layer.borderWidth = 1
        viewSummary.layer.borderColor = Constants.borderColor.cgColor
        viewOrder.layer.cornerRadius = viewOrder.frame.size.height/2
        viewDeliver.layer.cornerRadius = viewDeliver.frame.size.height/2
        viewOnDelivery.layer.cornerRadius = viewOnDelivery.frame.size.height/2

       tablePdtList.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
        self.getOrderDetail()
       
        
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tablePdtList.layer.removeAllAnimations()
        viewtableHeight.constant = tablePdtList.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }

    }
    // MARK: - get order detail
    func getOrderDetail(){
        self.view.activityStartAnimating()
        
        let loginURL = Constants.baseURL+Constants.orderDetailURL
        print("loginURL",loginURL)
        
        var postDict = Dictionary<String,String>()
        postDict = ["access_token":sharedData.getAccessToken(),
                    "order_id":orderID!
  
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
                    self.orderDetailModel = OrderDetailModel(response)
                    let statusCode = Int((self.orderDetailModel?.httpcode)!)
                    if statusCode == 200{
                        
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//
                            self.paymentStat.removeAll()
                          self.paymentStat = (self.orderDetailModel?.orderDetailModelData?.paymentStatus!)!
                            print("123123123====== ",(self.orderDetailModel?.orderDetailModelData?.paymentStatus!)!)
                            //self.paymentStat.append((self.orderDetailModel?.orderDetailModelData?.paymentMethod!)!)
                            
                            
                            if self.orderDetailModel?.orderDetailModelData?.paymentMethod == "cod" || self.orderDetailModel?.orderDetailModelData?.paymentMethod == "Cod" || self.orderDetailModel?.orderDetailModelData?.paymentMethod == "COD"
                            {
                                self.lblPaymentMethod.text = "COD"

                            }
                            else
                            {
                                self.lblPaymentMethod.text = self.orderDetailModel?.orderDetailModelData?.paymentMethod

                            }
                            
                            if self.orderDetailModel?.orderDetailModelData?.deliveryStatus! == "pending"
                                                        {
                                                            print("true value")
                                                            self.viewLine.backgroundColor = .clear
                                                          self.viewLine2.backgroundColor = .clear

                                                         self.lblDelivered.text = "Delivered on"

                                                        }
                                                        else  if self.orderDetailModel?.orderDetailModelData?.deliveryStatus! == "on-delivery"
                                                        {
                                                            print("false value")
                                                            self.viewLine.backgroundColor = UIColor(red: 49.0/255.0, green: 100.0/255.0, blue: 169.0/255.0, alpha: 1.0)
                                                            self.viewLine2.backgroundColor = .clear

                                                        }
                                                        else
                                                        {
                                                            print("false value")
                                                            self.viewLine.backgroundColor = UIColor(red: 49.0/255.0, green: 100.0/255.0, blue: 169.0/255.0, alpha: 1.0)
                                                            self.viewLine2.backgroundColor = UIColor(red: 49.0/255.0, green: 100.0/255.0, blue: 169.0/255.0, alpha: 1.0)
                                                        }
//                            self.lblOrderDateData.text = self.orderDetailModel?.orderDetailModelData?.orderDate!
                            
                            self.lblOrderDateData.text = self.orderDetailModel?.orderDetailModelData?.ordered!

                            
                            self.lblOrderNumData.text = self.orderDetailModel?.orderDetailModelData?.orderId!
                            
                            
                            self.lblOrderTotData.text = (self.orderDetailModel?.orderDetailModelData?.orderTotal!)! + " " + (self.orderDetailModel?.orderDetailModelData?.currency!)!
                            
                            var editedText = String()
                            
                            if self.orderDetailModel?.orderDetailModelData?.orderTotal == "0" ||  self.orderDetailModel?.orderDetailModelData?.orderTotal == "" || self.orderDetailModel?.orderDetailModelData?.orderTotal == nil
                            {
                                self.lblOrderTotData.text = ""
                            }
                            else
                            {
                                editedText = (self.orderDetailModel?.orderDetailModelData?.orderTotal!.replacingOccurrences(of: ",", with: ""))!
                            
                            
                                let iPricerate2 = self.ConvertCurrencyFormat(sNumber: Double(editedText)! as NSNumber)
                            let result2 = String(iPricerate2.dropFirst())
                            
                            self.lblOrderTotData.text = (self.orderDetailModel?.orderDetailModelData?.currency!)! + " " + result2

                            
                            }
                            
//                            self.lblBOrderDate.text = self.orderDetailModel?.orderDetailModelData?.orderDate!
                            
                            self.lblBOrderDate.text = self.orderDetailModel?.orderDetailModelData?.ordered!

                            self.lblBDeliveryDate.text = self.orderDetailModel?.orderDetailModelData?.delivered!
//                            if self.pdtList.count>0{
//                                self.lblItemTotal.text = self.pdtList[0].price!
//                            } else {
//                                self.lblItemTotal.text = "0"
//                            }
                            
                            
                           
                            
                            self.billAddr =  (self.orderDetailModel?.orderDetailModelData?.billingAddress!)!
                             self.shipAddr = (self.orderDetailModel?.orderDetailModelData?.shippingAddress!)!
                            
                            
                            //self.lblShipAddre.text = self.shipAddr[0].houseFlat! + "," +  self.shipAddr[0].roadName! + "," + self.shipAddr[0].zip!
                            if self.shipAddr.count>0
                            {
                                
                                if self.shipAddr[0].sHouseFlat == "" && self.shipAddr[0].sRoadName == "" && self.shipAddr[0].sZip == ""
                                {
                                    self.lblShipAddre.text = ""
                                    self.lblBillingAddr.text = ""

                                }
                                
                                else
                                {
                                
                                    self.lblShipAddre.text =  self.shipAddr[0].name! + "," + self.shipAddr[0].sHouseFlat! + "," + self.shipAddr[0].sRoadName! + "," + self.shipAddr[0].s_country! + "," + self.shipAddr[0].sZip!
                                    self.lblBillingAddr.text = self.shipAddr[0].name! + "," + self.shipAddr[0].sHouseFlat! + "," + self.shipAddr[0].sRoadName! + "," + self.shipAddr[0].s_country! + "," + self.shipAddr[0].sZip!
                                }
                            }
                            else
                            {
                                self.lblShipAddre.text = ""
                                self.lblBillingAddr.text = ""

                            }
                            
//                            if self.billAddr.count>0
//                            {
//                                if self.billAddr[0].houseFlat == "" && self.billAddr[0].roadName == "" && self.billAddr[0].zip == ""
//                                {
//                                    self.lblBillingAddr.text = ""
//
//                                }
//                                else
//                                {
//
//                                self.lblBillingAddr.text = self.billAddr[0].name!  + "," + self.billAddr[0].houseFlat! + "," +  self.billAddr[0].roadName! + "," + self.billAddr[0].country! + "," + self.billAddr[0].zip!
//                                }
//                            }
//                            else
//                            {
//                                self.lblBillingAddr.text = ""
//                            }
//                            
//
                            
                            
//                            self.lblPackageFee.text = (self.orderDetailModel?.orderDetailModelData?.shippingCost!)! + " " + (self.orderDetailModel?.orderDetailModelData?.currency!)!
                            self.lblBeforeTax.text = ""
//                            self.lblTaxAmt.text = (self.orderDetailModel?.orderDetailModelData?.tax!)! + " " + (self.orderDetailModel?.orderDetailModelData?.currency!)!
//                            self.lblTotal.text = (self.orderDetailModel?.orderDetailModelData?.totalAmount!)! + " " + (self.orderDetailModel?.orderDetailModelData?.currency!)!
                            
//                            self.lblOrderTot.text = (self.orderDetailModel?.orderDetailModelData?.grandTotal!)! + " " + (self.orderDetailModel?.orderDetailModelData?.currency!)!
//
//
//                            self.lblTotal.text = (self.orderDetailModel?.orderDetailModelData?.grandTotal!)! + " " + (self.orderDetailModel?.orderDetailModelData?.currency!)!

                            
                            // Changes on Currency Format
                            editedText = (self.orderDetailModel?.orderDetailModelData?.shippingCost!.replacingOccurrences(of: ",", with: ""))!

                            
                            if editedText == "0" ||  editedText == ""
                            {
                                self.lblPackageFee.text = ""
                            }
                            else
                            {
                                let iPricerate = self.ConvertCurrencyFormat(sNumber: Double(editedText)! as NSNumber)
                                let result = String(iPricerate.dropFirst())
                                self.lblPackageFee.text = (self.orderDetailModel?.orderDetailModelData?.currency!)! + " " + result
                            }
                            
                            
                       

                            
                            
                            if editedText == "0" ||  editedText == ""
                            {
                                self.lblOrderTot.text = ""
                                self.lblTotal.text = ""
                            }
                            else
                            {
                            
                            editedText = (self.orderDetailModel?.orderDetailModelData?.grandTotal!.replacingOccurrences(of: ",", with: ""))!

                            
                            let iPricerate3 = self.ConvertCurrencyFormat(sNumber: Double(editedText)! as NSNumber)
                            let result3 = String(iPricerate3.dropFirst())
                            self.lblOrderTot.text = (self.orderDetailModel?.orderDetailModelData?.currency!)! + " " + result3
                            
                            self.lblTotal.text = (self.orderDetailModel?.orderDetailModelData?.currency!)! + " " + result3
                            }
                            self.pdtList = (self.orderDetailModel?.orderDetailModelData?.productDetails!)!
                            
                            print(self.pdtList)
                            var tDouble:Double? = 0
                            
                            for item in self.pdtList{
                                print("subtotal ------ ",item.subtotal)
                                tDouble = tDouble! + Double(item.subtotal!)!
                            }
                            
                            if tDouble! > 0
                            {
                            
                            let iPricerate4 = self.ConvertCurrencyFormat(sNumber: tDouble! as NSNumber)
                            let result4 = String(iPricerate4.dropFirst())
                            self.lblItemTotal.text = (self.orderDetailModel?.orderDetailModelData?.currency!)! + " " + result4
                            }
                            
                            else
                            {
                                self.lblItemTotal.text = ""

                            }
//                            print("tDouble ------ ",String(tDouble!))
//                            self.lblItemTotal.text = String(tDouble!) + " " + (self.orderDetailModel?.orderDetailModelData?.currency!)!
                            self.tablePdtList.reloadData()
                            self.view.activityStopAnimating()
                           
//                        }
                    }
                    if statusCode == 400{
                        self.view.activityStopAnimating()
                        self.showToast(message: (self.orderDetailModel?.message)!)
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
