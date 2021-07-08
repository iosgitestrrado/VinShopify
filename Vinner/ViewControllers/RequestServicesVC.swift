//
//  RequestServicesVC.swift
//  Vinner
//
//  Created by softnotions on 21/07/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import DatePicker
import MobileCoreServices
import Alamofire
import SwiftyJSON
import CoreLocation
import iOSDropDown

class RequestServicesVC: UIViewController,UITextFieldDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource {
    var categoryID:String?
    var serviceTypeID:String?
    let datePickerView:UIDatePicker = UIDatePicker()
    let datePickerViewForDemo:UIDatePicker = UIDatePicker()

    @IBOutlet weak var tbldropdown: UITableView!
    @IBOutlet weak var tbleReqService: UITableView!
    
    @IBOutlet weak var tbleReqCategory: UITableView!
    let sharedData = SharedDefault()
    var sSelectedCountryCode = String()
    var sSelectedDate = String()
    var countryListModel: CountryListModel?
    var countryList = [CountryData]()

    var demoResponseModel: DemoResponseModel?
    var serviceTypList: ServiceTypListModel?
    var serviceCatList: ServiceCatListModel?
    var bSelectedDate :Bool = false
    var bSelectedTime :Bool = false
    @IBOutlet weak var vehicleTypeTop: NSLayoutConstraint!
    @IBOutlet weak var viewVehicleTypeHeight: NSLayoutConstraint!
    @IBOutlet weak var viewVehicleType: UIView!
    var serCatList = [ServiceCatListData]()
    var serTypList = [ServiceTypListData]()
    var ReqServNameArray = [String]()
    var ReqServIdArray = [String]()

    var ReqServCatArray = [String]()
    var ReqServCatIDArray = [String]()

    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var txtVehicleType: UITextField!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var txtServiceType: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    let datePicker = DatePicker()
    
    
    let minDate = DatePickerHelper.shared.dateFrom(day: 18, month: 08, year: 2020)
    let maxDate = DatePickerHelper.shared.dateFrom(day: 18, month: 08, year: 2220)
    var itemsNames = ["AE","BH","SA"]
    var itemsImages = ["uae","baharin","saudi"]
    
     var itemsCode = ["+971","+973","+966"]
    
    @IBOutlet weak var txtRemarks: UITextView!
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var scrollPage: UIScrollView!
    
    @IBOutlet weak var viewContry: UIView!
    
    @IBOutlet weak var viewService: UIView!
    @IBOutlet weak var viewCategory: UIView!
    
    override func viewWillAppear(_ animated: Bool)
    {
                        print("RequestServicesVC_viewWillAppear")

        self.categoryID = ""
        self.txtCategory.delegate = self
        self.txtServiceType.delegate = self
        self.serviceTypeID = ""
        self.tbleReqCategory.isHidden = true
        self.tbleReqService.isHidden = true
//        datePicker.setup { (selected, date) in
//            if selected, let selectedDate = date {
//                print("selectedDate --- ",selectedDate.getFormattedDate(format: "yyyy-MM-dd"))
//                self.txtDate.text = selectedDate.getFormattedDate(format: "yyyy-MM-dd")
//            } else {
//                print("cancelled")
//            }
//        }
        
        self.viewVehicleTypeHeight.constant = 0
        self.vehicleTypeTop.constant = 0
        datePickerViewForDemo.minimumDate = NSDate() as Date


//        txtCategory.didSelect{(selectedText , index ,id) in
//            //self.valueLabel.text = "Selected String: \(selectedText) \n index: \(index)"
//            print("selectedText ----- ",selectedText)
//            if self.serCatList.count>0{
//                print("id ----- ",self.serCatList[index].serviceCategoryId)
//                //self.selectedPdtID = self.pdtList[index].productId
//                self.categoryID = self.serCatList[index].serviceCategoryId!
//
//
//            }
//        }
//        txtServiceType.didSelect{ [self](selectedText , index ,id) in
//            print("selectedText ----- ",selectedText)
//            if self.serTypList.count>0{
//                print("id ----- ",self.serTypList[index].serviceTypeId)
//                let typeID = self.serTypList[index].serviceTypeId
//                let typeIDInt = Int(typeID!)
//
//                self.serviceTypeID = self.serTypList[index].serviceTypeId!
//                if typeIDInt == 3 {
//                    self.viewVehicleTypeHeight.constant = 45
//                    self.vehicleTypeTop.constant = 10
//                }
//                else
//                {
//                    self.viewVehicleTypeHeight.constant = 0
//                    self.vehicleTypeTop.constant = 0
//                }
//
//            }
//
//            self.txtCategory.listWillAppear
//            {
//                self.txtServiceType.hideList()
//            }
//            self.txtServiceType.listWillAppear
//            {
//                self.txtCategory.hideList()
//            }
////            self.txtCategory.listDidAppear
////            {
////                self.txtServiceType.hideList()
////            }
////            self.txtServiceType.listDidAppear
////            {
////                self.txtCategory.hideList()
////            }
//
////            self.txtCategory.listWillDisappear
////            {
////                self.txtServiceType.hideList()
////            }
////            self.txtServiceType.listWillDisappear
////            {
////                self.txtCategory.hideList()
////            }
////            self.txtCategory.listDidDisappear
////            {
////                self.txtServiceType.hideList()
////            }
////            self.txtServiceType.listDidDisappear
////            {
////                self.txtCategory.hideList()
////            }
//        }
        
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelNumberPad)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWithNumberPad))]
        numberToolbar.sizeToFit()
        txtPhone.inputAccessoryView = numberToolbar
        
        
        
        tbldropdown.isHidden = true
        tbldropdown.layer.cornerRadius = 10
        tbldropdown.layer.borderWidth = 1.0
        tbldropdown.layer.borderColor = Constants.borderColor.cgColor
        
        tbleReqCategory.isHidden = true
        tbleReqCategory.layer.cornerRadius = 10
        tbleReqCategory.layer.borderWidth = 1.0
        tbleReqCategory.layer.borderColor = Constants.borderColor.cgColor
        
        tbleReqService.isHidden = true
        tbleReqService.layer.cornerRadius = 10
        tbleReqService.layer.borderWidth = 1.0
        tbleReqService.layer.borderColor = Constants.borderColor.cgColor
        
//        self.txtCountry.text = sharedData.getCountyName()
//        self.sSelectedCountryCode = sharedData.getCountyCode()
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap1(_:)))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap3(_:)))
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap2(_:)))

        self.viewContry.addGestureRecognizer(tap1)
        self.viewService.addGestureRecognizer(tap2)
        self.viewCategory.addGestureRecognizer(tap3)


        
        
        
    }
    
  
    
    @objc func handleTap1(_ sender: UITapGestureRecognizer? = nil)
    {
        if sharedData.getLoginStatus()
        {
        // handling code
        print("handleTapCountryDropDown")
        tbldropdown.reloadData()
        tbldropdown.isHidden = false
        tbleReqCategory.isHidden = true
        tbleReqService.isHidden = true
        }
    }
    
    @objc func handleTap2(_ sender: UITapGestureRecognizer? = nil)
    {
        if sharedData.getLoginStatus()
        {
        // handling code
        print("handleTapCategoryDropDown")
        tbleReqCategory.reloadData()
        tbleReqCategory.isHidden = false
        tbleReqService.isHidden = true
        tbldropdown.isHidden = true
        }
    }
    @objc func handleTap3(_ sender: UITapGestureRecognizer? = nil)
    {
        if sharedData.getLoginStatus()
        {
        // handling code
        print("handleTapServiceDropDown")
        tbleReqService.reloadData()
        tbleReqService.isHidden = false
        tbleReqCategory.isHidden = true
        tbldropdown.isHidden = true
        }

    }
    // MARK: - tableview delegate
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if tableView == tbldropdown {
            let countryCell = self.tbldropdown.dequeueReusableCell(withIdentifier: "CountryTCell2", for: indexPath) as! CountryTCell
//            countryCell.lblCountry2.text = itemsNames[indexPath.row]
            
            countryCell.lblCountry2.text = self.countryList[indexPath.row].countryName
          
            if self.countryList[indexPath.row].countryCode == "BH"
            {
                countryCell.imgCountry2.image = UIImage(named:"baharin")

            }
            else if self.countryList[indexPath.row].countryCode == "SA"
            {
                countryCell.imgCountry2.image = UIImage(named:"saudi")

            }
            else if self.countryList[indexPath.row].countryCode == "AE"
            {
                countryCell.imgCountry2.image = UIImage(named:"uae")

            }
//            countryCell.imgCountry2.image = UIImage(named: itemsImages[indexPath.row])
            cell = countryCell
            
            //var itemsImages = ["AE","QA","BH", "SA" ,"IN"]
           // var itemsNames
        }
        else if tableView == tbleReqService
        {
            let countryCell = self.tbleReqService.dequeueReusableCell(withIdentifier: "ReqServiceTableViewCell", for: indexPath) as! ReqServiceTableViewCell
//            countryCell.lblReqService.text = self.serTypList[indexPath.row].serviceType
            countryCell.lblReqService.text = self.ReqServNameArray[indexPath.row]

            cell = countryCell

        }
        else if tableView == tbleReqCategory
        {
            let countryCell = self.tbleReqCategory.dequeueReusableCell(withIdentifier: "ReqCategoryTableViewCell", for: indexPath) as! ReqCategoryTableViewCell
//            countryCell.lblCategory.text = self.serCatList[indexPath.row].serviceCategoryName
            countryCell.lblCategory.text = self.ReqServCatArray[indexPath.row]

            cell = countryCell

        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("tableNotification ",indexPath.row)
        print("tableNotification section ",indexPath.section)
        if tableView == tbldropdown
        {
        txtCountry.text = self.countryList[indexPath.row].countryName!
        tbldropdown.isHidden = true
        print(itemsNames[indexPath.row])
        print(itemsCode[indexPath.row].dropFirst(1))
        self.sSelectedCountryCode = self.countryList[indexPath.row].countryId!

        print(itemsImages[indexPath.row])
        }
        else  if tableView == tbleReqCategory
        {
            if self.serCatList.count>0
            {
                print("id ----- ",self.serCatList[indexPath.row].serviceCategoryId)
//                self.categoryID = self.serCatList[indexPath.row].serviceCategoryId!
//                self.txtCategory.text = self.serCatList[indexPath.row].serviceCategoryName!
                self.txtCategory.text = self.ReqServCatArray[indexPath.row]
                
                for item in self.serCatList
                {
                    if item.serviceCategoryName == self.ReqServCatArray[indexPath.row]
                    {
                        self.categoryID = item.serviceCategoryId
                    }
                }

            }
            self.tbleReqCategory.isHidden = true
        }
        else  if tableView == tbleReqService
        {
            if self.serTypList.count>0{
                print("id ----- ",self.serTypList[indexPath.row].serviceTypeId)
                var typeID = self.serTypList[indexPath.row].serviceTypeId
                var typeIDInt = Int(typeID!)
                
                self.serviceTypeID = self.serTypList[indexPath.row].serviceTypeId!
//                self.txtServiceType.text = self.serTypList[indexPath.row].serviceType!
                self.txtServiceType.text = self.ReqServNameArray[indexPath.row]
                for item in self.serTypList
                {
                    if item.serviceType == self.ReqServNameArray[indexPath.row]
                    {
                        self.serviceTypeID = item.serviceTypeId
                        typeIDInt = Int(self.serviceTypeID!)
                    }
                }
                if typeIDInt == 3 {
                    self.viewVehicleTypeHeight.constant = 45
                    self.vehicleTypeTop.constant = 10
                }
                else
                {
                    self.viewVehicleTypeHeight.constant = 0
                    self.vehicleTypeTop.constant = 0
                }

            }
            self.tbleReqService.isHidden = true

        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
       
        return  1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
    if tableView == tbldropdown
    {
        return self.countryList.count

    }
    else if  tableView == tbleReqService
    {
        return self.self.serTypList.count

    }
    else
    {
        return self.serCatList.count

    }
    }
    @objc func cancelNumberPad() {
           //Cancel with number pad
        txtPhone.resignFirstResponder()
       }
       @objc func doneWithNumberPad() {
           //Done with number pad
        txtPhone.resignFirstResponder()
       }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = ""
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker))]
        numberToolbar.sizeToFit()
        txtTime.inputAccessoryView = numberToolbar
        
        txtPhone.inputAccessoryView = numberToolbar
        
        txtRemarks.inputAccessoryView = numberToolbar
        
        datePickerView.datePickerMode = UIDatePicker.Mode.time
        txtTime.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.datePickerFromValueChanged), for: UIControl.Event.valueChanged)
        
        // Do any additional setup after loading the view.
        txtDate.inputAccessoryView = numberToolbar
        datePickerViewForDemo.datePickerMode = UIDatePicker.Mode.date
        txtDate.inputView = datePickerViewForDemo
        datePickerViewForDemo.addTarget(self, action: #selector(self.datePickerServiceFromValueChanged), for: UIControl.Event.valueChanged)
        
        
        
        
        
        self.addBackButton(title: "Request For Services")
        //self.navigationController?.navigationBar.topItem?.title = "Request For Services"
        //datePicker.display(in: self)
        self.btnSubmit.layer.cornerRadius = 5
        self.btnCancel.layer.cornerRadius = 5
        
        
        txtName.delegate = self
        txtAddress.delegate = self
        txtCity.delegate = self
        txtCountry.delegate = self
        txtEmail.delegate = self
        txtPhone.delegate = self
        txtDate.delegate = self
        //txtTime.delegate = self
        
        txtName.autocorrectionType = .no
        txtAddress.autocorrectionType = .no
        txtCity.autocorrectionType = .no
        txtCountry.autocorrectionType = .no
        txtEmail.autocorrectionType = .no
        txtPhone.autocorrectionType = .no
        txtDate.autocorrectionType = .no
        txtRemarks.autocorrectionType = .no
        
        txtRemarks.text = "Remarks"
        txtRemarks.textColor = UIColor.lightGray
        txtRemarks.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        
        if !sharedData.getLoginStatus()
        {

            let alert = UIAlertController(title: Constants.appName, message: Constants.ReqServiceMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            
            let next = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                next.sScreenINdex = 1

            self.navigationController?.pushViewController(next, animated: true)
           
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            print("Cancel")
            

        }))
        self.present(alert, animated: true, completion: nil)
        
    }
        
        else
        
        {
            self.getServiceCatList()
            self.getServiceTypeList()
            self.getCountryList()

        }
        
      
    }
    
    // MARK: keyboard notification
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollPage.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollPage.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollPage.contentInset = contentInset
    }
    // Swift 4
    @objc func cancelPicker()
    {
        
        view.endEditing(true)
        
    }
    
    func  getCurrentShortDate() -> String
    {
        let todaysDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" //"dd-MM-yyyy""HH:mm:ss"
        
        self.sSelectedDate = dateFormatter.string(from: todaysDate as Date)

        dateFormatter.dateFormat = "dd/MM/yyyy" //"dd-MM-yyyy""HH:mm:ss"

        let DateInFormat = dateFormatter.string(from: todaysDate as Date)
        return DateInFormat
    }
    
    func  getCurrentTime() -> String
    {
        let todaysDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.dateFormat = "hh:mm a" //"dd-MM-yyyy""HH:mm:ss"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        let DateInFormat = dateFormatter.string(from: todaysDate as Date)

        return DateInFormat
    }
    @objc func donePicker()
    {
        if bSelectedDate
        {
            if txtDate.text?.count == 0
            {
            print("No date selected ")
                txtDate.text = self.getCurrentShortDate()
            }
        }
        
        else if bSelectedTime
        {
            if txtTime.text?.count == 0
            {
            print("No Time selected ")
                txtTime.text = self.getCurrentTime()
            }
            
        }
        view.endEditing(true)
        
    }
    @objc func datePickerFromValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a" //"dd-MM-yyyy""HH:mm:ss"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        //specialDateTextField.text = dateFormatter.string(from: sender.date)
        print("Selected Time ::: ",dateFormatter.string(from: sender.date))
        txtTime.text = dateFormatter.string(from: sender.date)
        view.endEditing(true)

    }
    
    
    @objc func datePickerServiceFromValueChanged(sender:UIDatePicker)
    {
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd" //"dd-MM-yyyy""HH:mm:ss"
        dateFormatter.dateFormat = "yyyy-MM-dd" //"dd-MM-yyyy""HH:mm:ss"
        
        self.sSelectedDate = dateFormatter.string(from: sender.date)

        dateFormatter.dateFormat = "dd/MM/yyyy" //"dd-MM-yyyy""HH:mm:ss"

        print("Selected date ::: ",dateFormatter.string(from: sender.date))
        txtDate.text = dateFormatter.string(from: sender.date)
        view.endEditing(true)

    }
    
    
    
    
    // UITextField Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtDate
        {
//            textField.resignFirstResponder();
//            datePicker.show(in: self)
            bSelectedDate = true
            bSelectedTime = false
        }
        else if textField == txtTime
        {
            bSelectedTime = true
            bSelectedDate = false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        tbldropdown.isHidden = true
        tbleReqCategory.isHidden = true
        tbleReqService.isHidden = true
        return true;
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true;
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true;
    }
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        return true;
//    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        tbldropdown.isHidden = true
        tbleReqCategory.isHidden = true
        tbleReqService.isHidden = true
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtName || textField == txtCity
        {
            let allowedCharacter = CharacterSet.letters
            let allowedCharacter1 = CharacterSet.whitespaces
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacter.isSuperset(of: characterSet) || allowedCharacter1.isSuperset(of: characterSet)
        }
       else
        {
            return true
        }

    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Remarks"
            textView.textColor = UIColor.lightGray
        }
    }
    
    //var serviceTypList: ServiceTypListModel?
    // var serviceCatList: ServiceCatListModel?
    func getServiceTypeList(){
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = [
            "access_token": sharedData.getAccessToken()
        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.serviceTypeURL
        print("loginURL",loginURL)
        
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
                    self.serviceTypList = ServiceTypListModel(response)
                    let statusCode = Int((self.serviceTypList?.httpcode)!)
                    if statusCode == 200{
                        
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//
                            self.serTypList = (self.serviceTypList?.serviceTypListData!)!
                            print("self.serTypList --",self.serTypList)
                            

                            for item in self.serTypList{
//                                self.txtServiceType.optionArray.append(item.serviceType!)
                                self.ReqServNameArray.append(item.serviceType!)
                                

                            }
                            
                            self.ReqServNameArray =  self.ReqServNameArray.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }

//                        }
                    }
                    if statusCode == 400{
                        self.showToast(message: (self.serviceTypList?.message)!)
                    }
                    self.view.activityStopAnimating()
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    func getServiceCatList(){
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = [
            "access_token": sharedData.getAccessToken()
        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.serviceCatURL
        print("loginURL",loginURL)
        
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
                    self.serviceCatList = ServiceCatListModel(response)
                    let statusCode = Int((self.serviceCatList?.httpcode)!)
                    if statusCode == 200{
                        
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            
                            self.view.activityStopAnimating()
                            self.serCatList = (self.serviceCatList?.serviceCatListData!)!
                            
                            print(" self.serCatList ", self.serCatList)
                            for item in self.serCatList{
//                                self.txtCategory.optionArray.append(item.serviceCategoryName!)
                                self.ReqServCatArray.append(item.serviceCategoryName!)

                            }
                            self.ReqServCatArray =  self.ReqServCatArray.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }

//                        }
                    }
                    if statusCode == 400{
                        self.view.activityStopAnimating()
                        self.showToast(message: (self.serviceCatList?.message)!)
                    }
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    func requestForService()
    {
        
        self.view.activityStartAnimating()
        if txtRemarks.text == "Remarks"
        {
            txtRemarks.text = ""
        }
        var postDict = Dictionary<String,String>()
        postDict = [
            "service_category":self.categoryID!,
            "service_type":self.serviceTypeID!,
            "vehicle_type":self.txtVehicleType.text!,
            "name":txtName.text!,
            "address":txtAddress.text!,
            "city":txtCity.text!,
//            "country":txtCountry.text!,
            "country":sSelectedCountryCode,

            "mobile":txtPhone.text!,
            "email":txtEmail.text!,
//            "date":txtDate.text!,
            "date":sSelectedDate,
            "time":txtTime.text!,
            "remark":txtRemarks.text!,
            "access_token":sharedData.getAccessToken()
        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.requestServiceURL
        print("loginURL",loginURL)
        
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
                    self.demoResponseModel = DemoResponseModel(response)
                    let statusCode = Int((self.demoResponseModel?.httpcode)!)
                    if statusCode == 200
                    {
                        self.view.activityStopAnimating()
                        self.showToast(message: (self.demoResponseModel?.message)!)

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
                        {
                            self.navigationController?.popViewController(animated: true)

                        }
                        
                    }
                    if statusCode == 400{
                        self.view.activityStopAnimating()
                        self.showToast(message: (self.demoResponseModel?.message)!)
                    }
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func btnCancelAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSubmitAction(_ sender: UIButton)
    {
        if txtCategory.text!.count<=0
        {
            self.showToast(message: "Select category")
        }
        else if txtServiceType.text!.count<=0 {
            self.showToast(message: "Select service type")
        }
        else if txtName.text!.count<=0 {
            self.showToast(message: Constants.demoEmptyNameMsg)
        }
            
            
        else if txtAddress.text!.count<=0 {
            self.showToast(message: Constants.demoEmptyAddrMsg)
        }
        
        else if txtCountry.text!.count<=0 {
            self.showToast(message: Constants.demoEmptyCountryMsg)
        }
        else if txtCity.text!.count<=0 {
            self.showToast(message: Constants.demoEmptyCityMsg)
        }
        else if txtEmail.text!.count<=0 {
            self.showToast(message: Constants.demoEmptyEmailMsg)
        }
        else if txtPhone.text!.count<=0
        {
            
            self.showToast(message: Constants.demoEmptyPhMsg)
        }
        else if txtPhone.text!.count < 7
        {
            self.showToast(message:Constants.phoneLengthMsg)

        }
        else if txtPhone.text!.count >= 15
        {
            self.showToast(message:Constants.phoneLengthMsg2)
        }
        
        
        
        else if txtDate.text!.count<=0 {
            self.showToast(message: Constants.demoEmptyDateMsg)
        }
        else if txtTime.text!.count<=0 {
            self.showToast(message: Constants.demoEmptyTimeMsg)
        }
        else if txtRemarks.text!.count<=0 {
            self.showToast(message: Constants.demoEmptyDemoMsg)
        } else
        {
            if !(self.txtEmail.text!.isValidEmail())
            {
                self.showToast(message:Constants.invalidEmailMSG)
                return
            }
          
            else
            
            {
                
                if !sharedData.getLoginStatus()
                {

                    let alert = UIAlertController(title: Constants.appName, message: Constants.ReqServiceMessage, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                    
                    let next = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController

                    self.navigationController?.pushViewController(next, animated: true)
                   
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
                    print("Cancel")
                    

                }))
                self.present(alert, animated: true, completion: nil)
                
            }
                else
                
                {
              self.requestForService()
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
    
    func getCountryList(){
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = [
            "access_token":sharedData.getAccessToken()
        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.countryURL
        print("loginURL",loginURL)
        
        AF.request(loginURL, method: .get, parameters: postDict, encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
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
                    self.countryListModel = CountryListModel(response)
                    let statusCode = Int((self.countryListModel?.httpcode)!)
                    if statusCode == 200{
                        
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
//                        {
                            self.countryList = self.countryListModel!.countryData!
                            print("self.self.pdtList ----- ",self.countryList)
                          
//                        }
                    }
                    if statusCode == 400{
                        self.showToast(message: (self.countryListModel?.message)!)
                    }
                    self.view.activityStopAnimating()
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
}
