//
//  MyOrderVC.swift
//  Vinner
//
//  Created by softnotions on 27/07/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire
import SwiftyJSON
import DatePicker


class MyOrderVC: UIViewController ,UITableViewDataSource,UITableViewDelegate ,UISearchBarDelegate,UITextFieldDelegate {
    var sections: Array<String> = ["Section 1", "Section 2", "Section 3"]
    var arrayProduct = NSMutableArray()

    let datePickerViewForDemo:UIDatePicker = UIDatePicker()

    let datePicker = DatePicker()

    @IBOutlet weak var datePickerTxt: UITextField!
    var sSelectedDate = String()

    
    
    @IBOutlet weak var tableOrderDetails: UITableView!
    @IBOutlet weak var searchOrder: UISearchBar!
    var dropTextField = UITextField()
    var orderListModel: OrderListModel?
    var  pdtDetailsList =  [ProductDetails]()
     var  pdtDetailsListBSearch =  [OrderListModelData]()
    var bFromCheckoutPage : Bool? = false
    var searchOrderDate : String? = ""
    var searchOrderId : String? = ""
    var dateFormatter = DateFormatter()
    let datePickerView:UIDatePicker = UIDatePicker()

    @IBOutlet weak var btnDate: UIButton!
    let sharedData = SharedDefault()
    var pdtList = [OrderListModelData]()
    override func viewWillAppear(_ animated: Bool)
    {
    
        
       
        
        
        
        
        
        
        
    }
    
    @objc func cancelPicker() {
        
        view.endEditing(true)
        
        
    }
    @objc func donePicker()
    {
        view.endEditing(true)
        
        
        
        if searchOrder.text?.count == 0
        {
            searchOrder.alwaysShowCancelButton()

            print("No date selected ")
            searchOrder.text = self.getCurrentShortDate()
            self.searchOrderDate = self.getCurrentShortDate()
            self.getSearchOrderLIst(searchText: "", searchDate: self.getCurrentShortDate())
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        
        print("textFieldShouldReturn")
        
        textField.resignFirstResponder();
        return true;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        print("textFieldDidEndEditing")
        
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd-MM-yyyy"
        let someDate = searchOrder.text

        if dateFormatterGet.date(from: someDate!) != nil
        {
           
            if searchOrder.text!.count > 0
            {
                searchOrder.alwaysShowCancelButton()
                self.pdtList.removeAll()

                print("No date selected ")
                searchOrder.text = self.getCurrentShortDate()
                self.searchOrderDate = self.getCurrentShortDate()
                self.getSearchOrderLIst(searchText: "", searchDate: self.getCurrentShortDate())
            }
            
            
        }
        else
        {
            if searchOrder.text!.count > 0
            {
                searchOrder.alwaysShowCancelButton()
                self.pdtList.removeAll()

                print("No date selected ")
                searchOrder.text = self.getCurrentShortDate()
                self.searchOrderDate = self.getCurrentShortDate()
                self.getSearchOrderLIst(searchText: "", searchDate: self.getCurrentShortDate())
            }
            
        }
        
        
       

    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        print("textFieldShouldBeginEditing")
        return true;
    }
    
    @objc func datePickerDemoFromValueChanged(sender:UIDatePicker)
    {
        
        self.searchOrderId = ""
        
        searchOrder.alwaysShowCancelButton()

        let dateFormatter = DateFormatter()
    
        dateFormatter.dateFormat = "dd-MM-yyyy" //"dd-MM-yyyy""HH:mm:ss"
        
        print("Selected date in My order ::: ",dateFormatter.string(from: sender.date))
        
        searchOrder.text = dateFormatter.string(from: sender.date)
        self.searchOrderDate = dateFormatter.string(from: sender.date)
        self.getSearchOrderLIst(searchText: "", searchDate: dateFormatter.string(from: sender.date))
        view.endEditing(true)

        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        if bFromCheckoutPage!
        {
            self.addCustomNavigationBackButton()
        }
        else
        {
            self.addBackButton(title: "Your Orders")

        }
        self.searchOrder.text = ""
        self.searchOrderDate = ""

        self.arrayProduct.removeAllObjects()
        self.searchOrder.delegate = self
         self.searchOrder.showsCancelButton = true
        
        self.searchOrder.alwaysShowCancelButton()

        
        //self.navigationController?.navigationBar.topItem?.title = "Your Orders"
        self.searchOrder.layer.cornerRadius = self.searchOrder.frame.size.height/2
        // self.searchOrder.clipsToBounds = true
        
        //self.searchOrder.layer.maskedCorners = [ .layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        self.searchOrder.barTintColor = UIColor.lightGray
        //self.searchOrder.backgroundColor = UIColor.clear
        //self.searchOrder.isTranslucent = true
        self.searchOrder.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        // SearchBar placeholder
        
        tableOrderDetails.delegate = self
        tableOrderDetails.dataSource = self
        
        self.searchOrder.backgroundColor  = .white
        if let textfield = self.searchOrder.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
            textfield.layer.cornerRadius  = textfield.frame.size.height/2
            textfield.clearButtonMode = .never
            textfield.font =  UIFont.boldSystemFont(ofSize: 13)
        }
        
        self.getOrderLIst()
        
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker))]
        numberToolbar.sizeToFit()
        
        
        datePickerTxt.inputAccessoryView = numberToolbar
        datePickerViewForDemo.datePickerMode = UIDatePicker.Mode.date
        datePickerTxt.inputView = datePickerViewForDemo
        datePickerViewForDemo.addTarget(self, action: #selector(self.datePickerDemoFromValueChanged), for: UIControl.Event.valueChanged)
        
//        datePickerViewForDemo.minimumDate = Date().startOfMonth
        
        
        
        

        
    }
    
    
    func  getCurrentShortDate() -> String
    {
        let todaysDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy" //"dd-MM-yyyy""HH:mm:ss"
        
        self.sSelectedDate = dateFormatter.string(from: todaysDate as Date)
        
        
        dateFormatter.dateFormat = "dd-MM-yyyy" //"dd-MM-yyyy""HH:mm:ss"

        let DateInFormat = dateFormatter.string(from: todaysDate as Date)

        return DateInFormat
    }
        
    
    private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if tableView == tableOrderDetails
    {
        return 205
    }
    else
    {
        return 205
    }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if tableView == tableOrderDetails {
            let cellNotify = tableOrderDetails.dequeueReusableCell(withIdentifier: "OrderListTCell", for: indexPath) as! OrderListTCell
//            cellNotify.lblDelivery.text = self.pdtList[indexPath.section].delivaryDatetime!
//            cellNotify.lblOrderID.text = self.pdtList[indexPath.row].order_id

            let sArrayDictObject = self.arrayProduct[indexPath.section] as! NSMutableArray
            
            cellNotify.lblDelivery.text = sArrayDictObject[0] as? String
            cellNotify.lblOrderID.text = sArrayDictObject[2] as? String

            if sArrayDictObject[7] as? String != "0"
            {
                cellNotify.btnReview.setTitle("View Review", for: .normal)
            }
            else
            {
                cellNotify.btnReview.setTitle("Write a Review", for: .normal)

            }
            let imgUrl = sArrayDictObject[5] as! String
            cellNotify.lblPdtName.text =  sArrayDictObject[6] as? String

            cellNotify.imgPdt.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "Transparent"))
            cellNotify.btnReview.tag = Int(sArrayDictObject[3] as! String)!
            
            cellNotify.btnReview.tag = Int(sArrayDictObject[4] as! String)!

            cellNotify.btnReview.addTarget(self, action: #selector(btnReviewAction), for: .touchUpInside)
//            cellNotify.lblOrderDate.text = sArrayDictObject[9] as? String
            let sOrderDate = sArrayDictObject[9] as? String
            
            
            
            dateFormatter.dateFormat = "dd MMM yyyy"//this your string date format
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
            let date = dateFormatter.date(from: sOrderDate!)

            
            dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy" ///this is what you want to convert format
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
            let timeStamp = dateFormatter.string(from: date!)
            
            cellNotify.lblOrderDate.text = timeStamp

            
            let sRating = sArrayDictObject[8] as? String
//            sRating = Double(sRating ?? 0.0)
            if sRating == "" || sRating == nil
            {
                cellNotify.pdtRating.rating = 0.0

            }
            else
            {
                cellNotify.pdtRating.rating = Double(sRating!)!

            }
            cellNotify.layer.borderWidth = 1
            cellNotify.layer.borderColor = Constants.borderColor.cgColor
            cellNotify.layer.cornerRadius = 5
            cellNotify.clipsToBounds = true
            cellNotify.selectionStyle = .none
            cell = cellNotify
            
//            var pdtName:String? = ""
//            var tempPdt = [ProductDetails]()
//            tempPdt = (self.pdtList[indexPath.section].productDetails)!
//
//
//            if tempPdt.count > 0
//            {
//                for item in tempPdt
//                {
//
//
//                    pdtName = item.name!
//                    if item.review_id != "0"
//                    {
//                        cellNotify.btnReview.setTitle("ViewReview", for: .normal)
//                    }
//                    cellNotify.lblPdtName.text =  pdtName
//                    cellNotify.imgPdt.sd_setImage(with: URL(string: item.image!), placeholderImage: UIImage(named: "Transparent"))
//                    cellNotify.btnReview.tag = Int((self.pdtList[indexPath.section].saleId)!)!
//
//                }
//
//            }
//            else
//            {
//                if tempPdt.count > 0
//                {
//                    cellNotify.lblPdtName.text = tempPdt[0].name
//                    if tempPdt[0].review_id != "0"
//                    {
//                        cellNotify.btnReview.setTitle("ViewReview", for: .normal)
//
//                    }
//
//                }
//                else
//                {
//                    cellNotify.lblPdtName.text = ""
//
//                }
//            }
            
//            if tempPdt.count == 0
//            {
//                cellNotify.imgPdt.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "Transparent"))
//
//            }
//            else
//            {
//                cellNotify.imgPdt.sd_setImage(with: URL(string: tempPdt[0].image!), placeholderImage: UIImage(named: "Transparent"))
//
//            }
//
            let status = sArrayDictObject[1] as! String

            
            if status == "pending" || status == "on-delivery"
            {
                cellNotify.btnReview.isHidden = true

            }
            else if status == "delivered"
            {
                cellNotify.btnReview.isHidden = false

            }
            
           
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("tableNotification ",indexPath.row)
        print("tableNotification section ",indexPath.section)
        let next = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailsVC") as! OrderDetailsVC
        
        let sArrayDictObject = self.arrayProduct[indexPath.section] as! NSMutableArray

        next.orderID = sArrayDictObject[3] as? String
//        next.orderID = self.pdtList[indexPath.section].saleId!
        self.navigationController?.pushViewController(next, animated: true)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
//        return self.pdtList .count
        return self.arrayProduct.count

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return ""
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 5))
        /*
         let label = UILabel()
         label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
         label.text = "Notification Times"
         headerView.addSubview(label)
         */
        headerView.backgroundColor = UIColor.white
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 5
    }
    @objc func btnReviewAction(sender: UIButton!)
    {
        
        print("sender",sender.tag)
        print("sender",sender.titleLabel?.text!)

         let next = self.storyboard?.instantiateViewController(withIdentifier: "ReviewProductVC") as! ReviewProductVC
        next.orderID = String(sender.tag)
        for item in self.arrayProduct
        {
            let sArrayDictObject = item as! NSMutableArray

            if sArrayDictObject[4] as! String == String(sender.tag)
            {
                print("Same Product id")
                next.orderID = (sArrayDictObject[3] as! String)
                next.sProductIdToReview = (sArrayDictObject[4] as! String)
                next.sTitle = sender.titleLabel?.text

            }
        }
        
        
         self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func testaction(_ sender: Any) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailsVC") as! OrderDetailsVC
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        print("Search bar",searchBar.text!)
        searchBar.resignFirstResponder()

        if self.searchOrder.text!.count>0 {
            self.arrayProduct.removeAllObjects()
//            let array = self.searchOrder.text!.components(separatedBy: ",")
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "dd-MM-yyyy"

            if dateFormatterGet.date(from: self.searchOrder.text ?? "") != nil
            {
             print("String Valid")
                self.searchOrderDate = self.searchOrder.text
                self.searchOrderId = ""
            }
            else
            {
                print("String Not Valid")
                self.searchOrderDate = ""
                self.searchOrderId = self.searchOrder.text
            }
            self.getSearchOrderLIst(searchText: self.searchOrder.text!, searchDate: "")

        }
        else {
            self.showToast(message: "Enter the content to search")
        }
        

    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        
        searchBar.resignFirstResponder()
        searchBar.alwaysShowCancelButton()
        if searchBar.text?.count == 0
        {
            
            
            if bFromCheckoutPage!
            {
                guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabbar") as? TabBarController else {
                                                    return
                                                }
                                                let navigationController = UINavigationController(rootViewController: rootVC)

                                                UIApplication.shared.windows.first?.rootViewController = navigationController
                                                UIApplication.shared.windows.first?.makeKeyAndVisible()
                
            }
            else
            {
                self.navigationController?.popViewController(animated: true)

            }
            
            
        }
        else
        {
            self.arrayProduct.removeAllObjects()
            self.pdtList.removeAll()
            searchBar.text = ""
            self.getOrderLIst()
            self.tableOrderDetails.reloadData()
            searchBar.alwaysShowCancelButton()

        }
        
    }
    
    func addTextfield()  {
        
        
        dropTextField =  UITextField(frame: CGRect(x: self.view.frame.size.width-275, y: 5, width: 180, height: 30))
        dropTextField.textAlignment = .center
        dropTextField.placeholder = "Select Region"
        dropTextField.font = UIFont.systemFont(ofSize: 15)
        dropTextField.borderStyle = UITextField.BorderStyle.roundedRect
        dropTextField.autocorrectionType = UITextAutocorrectionType.no
        dropTextField.keyboardType = UIKeyboardType.default
        dropTextField.returnKeyType = UIReturnKeyType.done
        dropTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        dropTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        self.navigationController?.navigationBar.topItem?.titleView = dropTextField
        
        //self.navigationController?.navigationBar .addSubview(dropTextField)
        dropTextField.layer.cornerRadius = 15
        let viewImg = UIView(frame: CGRect(x: 0, y: dropTextField.frame.size.height/2, width: 10, height: 10))
        dropTextField.rightViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: -5, y: 0, width: 10, height: 10))
        let image = UIImage(named: "DownArrow")
        imageView.image = image
        viewImg.addSubview(imageView)
        dropTextField.rightView = viewImg
    }
    
    // MARK: - get order list
    func getOrderLIst(){
        self.view.activityStartAnimating()
        
        let loginURL = Constants.baseURL+Constants.orderListURL
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
                    self.orderListModel = OrderListModel(response)
                    let statusCode = Int((self.orderListModel?.httpcode)!)
                    if statusCode == 200{
                        
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            
                            self.pdtDetailsListBSearch.removeAll()
                            self.pdtList.removeAll()
                            self.pdtList = (self.orderListModel?.orderListModelData!)!
                            self.pdtDetailsListBSearch = (self.orderListModel?.orderListModelData!)!
                            print("self.pdtList -------- ",self.pdtList)
                            print("self.pdtDetailsListBSearch -------- ",self.pdtDetailsListBSearch.count)
                            self.view.activityStopAnimating()
                            self.tableOrderDetails.tableFooterView = UIView()

                            for item in self.pdtList
                            {

                                


                                self.pdtDetailsList = item.productDetails!
                                
                                for item2 in self.pdtDetailsList
                                {
                                    let arrayProduct1 = NSMutableArray()
                                    arrayProduct1.add(item.delivaryDatetime!)
                                    arrayProduct1.add(item.delivery_status!)
                                    arrayProduct1.add(item.order_id!)
                                    arrayProduct1.add(item.saleId!)
                                    arrayProduct1.add(item2.id!)
                                    arrayProduct1.add(item2.image!)
                                    arrayProduct1.add(item2.name!)
                                    arrayProduct1.add(item2.review_id!)
                                    arrayProduct1.add(item2.rating!)
                                    arrayProduct1.add(item.order_date!)
                                    self.arrayProduct.add(arrayProduct1)
                                   
                                }
                            }
                            self.tableOrderDetails.reloadData()

//                        }
                    }
                    if statusCode == 400{
                        self.view.activityStopAnimating()
                        self.showToast(message: (self.orderListModel?.message)!)
                    }
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
     // MARK: - get order search list
    func getSearchOrderLIst(searchText:String, searchDate:String){
        self.view.activityStartAnimating()
        
        let loginURL = Constants.baseURL+Constants.orderListURL
        print("loginURL",loginURL)
        
        var postDict = Dictionary<String,String>()
        postDict = [
            "access_token":sharedData.getAccessToken(),
            "search_orderId":self.searchOrderId!,
            "search_date":self.searchOrderDate!
            
            
        ]
        print("postDict",postDict)
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
                    self.orderListModel = OrderListModel(response)
                    let statusCode = Int((self.orderListModel?.httpcode)!)
                    
                    self.searchOrderId = ""
                    self.searchOrderDate = ""
                    
                    
                    if statusCode == 200{
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            
                        self.searchOrderId = ""
                        self.searchOrderDate = ""
                            self.pdtList.removeAll()
                            self.arrayProduct.removeAllObjects()

                            self.pdtList = (self.orderListModel?.orderListModelData!)!
                            
                            print("self.pdtList -------- ",self.pdtList.count)
                            print("self.pdtDetailsListBSearch -------- ",self.pdtDetailsListBSearch)
                            self.view.activityStopAnimating()
                            self.tableOrderDetails.tableFooterView = UIView()
                            
                            for item in self.pdtList
                            {

                                


                                self.pdtDetailsList = item.productDetails!
                                
                                for item2 in self.pdtDetailsList
                                {
                                    let arrayProduct1 = NSMutableArray()
                                    arrayProduct1.add(item.delivaryDatetime!)
                                    arrayProduct1.add(item.delivery_status!)
                                    arrayProduct1.add(item.order_id!)
                                    arrayProduct1.add(item.saleId!)
                                    arrayProduct1.add(item2.id!)
                                    arrayProduct1.add(item2.image!)
                                    arrayProduct1.add(item2.name!)
                                    arrayProduct1.add(item2.review_id!)
                                    arrayProduct1.add(item2.rating!)
                                    arrayProduct1.add(item.order_date!)

                                    self.arrayProduct.add(arrayProduct1)
                                   
                                }
                            }
                            
                           self.searchOrder.alwaysShowCancelButton()

                            self.tableOrderDetails.reloadData()

//                        }

                    }
                    if statusCode == 400
                    {
                        self.pdtList.removeAll()
                        self.arrayProduct.removeAllObjects()
                        self.tableOrderDetails.reloadData()
                        self.view.activityStopAnimating()
                        self.showToast(message: (self.orderListModel?.message)!)
                        self.searchOrder.alwaysShowCancelButton()

                    }
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                    self.searchOrderId = ""
                    self.searchOrderDate = ""
                    self.view.activityStopAnimating()

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
    func convertDateFormatter(date: String) -> String
    {

       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "MMM dd yyyy"//this your string date format
       dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
       let date = dateFormatter.date(from: date)


       dateFormatter.dateFormat = "yyyy-MM-dd" ///this is what you want to convert format
       dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
       let timeStamp = dateFormatter.string(from: date!)


       return timeStamp
   }
}
extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var startOfMonth: Date {

        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)

        return  calendar.date(from: components)!
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }

    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }

    func isMonday() -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: self)
        return components.weekday == 2
    }
}
