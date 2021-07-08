//
//  RequestDemoVC.swift
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
import iOSDropDown

class RequestDemoVC: UIViewController,UITextFieldDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var dropDemoPdtList: DropDown!
    let datePickerView:UIDatePicker = UIDatePicker()
    let datePickerViewForDemo:UIDatePicker = UIDatePicker()
    var selectedPdtID:String?
    var bSelectedDate :Bool = false
    var bSelectedTime :Bool = false
    var sSelectedCountryCode = String()
    var sSelectedDate = String()

    var demoResponseModel: DemoResponseModel?
    var pdtDemoList: PdtDemoList?
    
    let sharedData = SharedDefault()
    var pdtListResponseModel: PdtListResponseModel?
    
    var countryListModel: CountryListModel?

    var ReqDemoNameArray = [String]()
    var ReqDemoIdArray = [String]()

    
    var pdtList = [PdtListData]()
    var countryList = [CountryData]()

    var itemsNames = ["AE","BH","SA"]
    var itemsImages = ["uae","baharin","saudi"]
    
     var itemsCode = ["+971","+973","+966"]
    
    
    @IBOutlet weak var scrollDemo: UIScrollView!
    let datePicker = DatePicker()
    
    let minDate = DatePickerHelper.shared.dateFrom(day: 18, month: 08, year: 1990)
    let maxDate = DatePickerHelper.shared.dateFrom(day: 18, month: 08, year: 2020)
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtDemo: UITextView!
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var viewContry: UIView!
    @IBOutlet weak var tbldropdown: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        
        self.selectedPdtID = ""
        

        self.dropDemoPdtList.optionIds = [1,23,54,22]

//
        self.navigationController?.navigationBar.topItem?.title = ""
        dropDemoPdtList.didSelect{(selectedText , index ,id) in
            //self.valueLabel.text = "Selected String: \(selectedText) \n index: \(index)"
            print("selectedText ----- ",selectedText)
            if self.pdtList.count>0
            {
                print("id ----- ",self.pdtList[index].productId)
                
                print("ProductTitle ----- ",self.ReqDemoNameArray[index])
                for item in self.pdtList
                {
                    if item.productTitle == self.ReqDemoNameArray[index]
                    {
                        self.selectedPdtID = item.productId
                        print("ProductId ----- ",self.selectedPdtID!)

                    }
                }

                
//                self.selectedPdtID = self.pdtList[index].productId
            }
        }
        
        
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelNumberPad)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWithNumberPad))]
        numberToolbar.sizeToFit()
        txtPhone.inputAccessoryView = numberToolbar
        txtDemo.inputAccessoryView = numberToolbar
        
        
        
        
        tbldropdown.isHidden = true
        tbldropdown.layer.cornerRadius = 10
        tbldropdown.layer.borderWidth = 1.0
        tbldropdown.layer.borderColor = Constants.borderColor.cgColor
        
        
//        self.txtCountry.text = sharedData.getCountyName()
//        self.sSelectedCountryCode = sharedData.getCountyCode()
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap1(_:)))
        self.viewContry.addGestureRecognizer(tap1)
        
    }
    @objc func handleTap1(_ sender: UITapGestureRecognizer? = nil)
    {
        if sharedData.getLoginStatus()
        {
        // handling code
        print("handleTapffggfgfgf")
        tbldropdown.reloadData()
        tbldropdown.isHidden = false
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
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("tableNotification ",indexPath.row)
        print("tableNotification section ",indexPath.section)
        txtCountry.text = self.countryList[indexPath.row].countryName!
        tbldropdown.isHidden = true
        print(itemsNames[indexPath.row])
        print(itemsCode[indexPath.row].dropFirst(1))
        self.sSelectedCountryCode = self.countryList[indexPath.row].countryId!

        print(itemsImages[indexPath.row])
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
       
        return  1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countryList.count
    }
    @objc func cancelNumberPad()
    {
           //Cancel with number pad
        view.endEditing(true)
       }
       @objc func doneWithNumberPad()
       {
           //Done with number pad
        view.endEditing(true)
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //self.navigationController?.navigationBar.topItem?.title = "Request For Demo"
        self.addBackButton(title: "Request For Demo")
        
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker))]
        numberToolbar.sizeToFit()
        txtTime.inputAccessoryView = numberToolbar
        datePickerView.datePickerMode = UIDatePicker.Mode.time
        txtTime.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.datePickerFromValueChanged), for: UIControl.Event.valueChanged)
        
        txtDate.inputAccessoryView = numberToolbar
        datePickerViewForDemo.datePickerMode = UIDatePicker.Mode.date
        txtDate.inputView = datePickerViewForDemo
        datePickerViewForDemo.addTarget(self, action: #selector(self.datePickerDemoFromValueChanged), for: UIControl.Event.valueChanged)
        
        datePickerViewForDemo.minimumDate = NSDate() as Date

        
        
        
        
        ////datePicker.display(in: self)
        btnCancel.layer.cornerRadius = 5
        btnSubmit.layer.cornerRadius = 5
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
        txtDemo.autocorrectionType = .no
        
        txtDemo.text = "Request Demo"
        txtDemo.textColor = UIColor.lightGray
        txtDemo.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        
        if !sharedData.getLoginStatus()
        {
            dropDemoPdtList.isEnabled = false
            
            let alert = UIAlertController(title: Constants.appName, message: Constants.ReqDemoMessage, preferredStyle: UIAlertController.Style.alert)
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
            self.getCountryList()
            self.getDemoList()
            dropDemoPdtList.isEnabled = true

        }
        
    }
    // MARK: keyboard notification
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollDemo.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollDemo.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollDemo.contentInset = contentInset
    }
    @objc func cancelPicker() {
        
        view.endEditing(true)
        
        
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
    
    func  getCurrentShortDate() -> String
    {
        let todaysDate = NSDate()
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd" //"dd-MM-yyyy""HH:mm:ss"
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
    @objc func datePickerFromValueChanged(sender:UIDatePicker)
    {
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd" //"dd-MM-yyyy""HH:mm:ss"
        
        dateFormatter.dateFormat = "hh:mm a" //"dd-MM-yyyy""HH:mm:ss"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        //specialDateTextField.text = dateFormatter.string(from: sender.date)
        print("Selected Time ::: ",dateFormatter.string(from: sender.date))
        txtTime.text = dateFormatter.string(from: sender.date)
        view.endEditing(true)

        
    }
    
    @objc func datePickerDemoFromValueChanged(sender:UIDatePicker)
    {
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd" //"dd-MM-yyyy""HH:mm:ss"
        
        dateFormatter.dateFormat = "yyyy-MM-dd" //"dd-MM-yyyy""HH:mm:ss"
        
        self.sSelectedDate = dateFormatter.string(from: sender.date)

        
        dateFormatter.dateFormat = "dd/MM/yyyy" //"dd-MM-yyyy""HH:mm:ss"

        
        //specialDateTextField.text = dateFormatter.string(from: sender.date)
        print("Selected date ::: ",dateFormatter.string(from: sender.date))
        txtDate.text = dateFormatter.string(from: sender.date)
        view.endEditing(true)
    }
    
    
    
    
    // UITextField Delegates
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
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
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        print("textFieldDidEndEditing")

    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        print("textFieldShouldBeginEditing")
        tbldropdown.isHidden = true
        
        return true;
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        print("textFieldShouldClear")

        return true;
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        return true;
    }
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
//    {
//        print("shouldChangeCharactersIn")
//
//        return true;
//    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
                print("shouldChangeCharactersIn")

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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        
        print("textFieldShouldReturn")
        
        textField.resignFirstResponder();
        return true;
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        print("textViewDidBeginEditing")
        tbldropdown.isHidden = true
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        print("textViewDidEndEditing")

        if textView.text.isEmpty {
            textView.text = "Request Demo"
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    // MARK:Action
    @IBAction func btnSubmitAction(_ sender: UIButton)
    {
        
//        if self.selectedPdtID!.count>0
//        {
//            self.showToast(message: Constants.demoEmptyPdtMsg)
//        }
        
        if self.selectedPdtID!.count <= 0
        {
            self.showToast(message: Constants.demoEmptyPdtMsg)
        }
            
        else if txtName.text!.count<=0
        {
            self.showToast(message: Constants.demoEmptyNameMsg)
        }
            
        else if txtAddress.text!.count<=0
        {
            self.showToast(message: Constants.demoEmptyAddrMsg)
        }
        
        else if txtCountry.text!.count<=0
        {
            self.showToast(message: Constants.demoEmptyCountryMsg)
        }
        else if txtCity.text!.count<=0
        {
            self.showToast(message: Constants.demoEmptyCityMsg)
        }
        else if txtEmail.text!.count<=0
        {
            self.showToast(message: Constants.demoEmptyEmailMsg)
        }
//        else if txtPhone.text!.count<=0
//        {
//            self.showToast(message: Constants.demoEmptyPhMsg)
//        }
//
        else if txtPhone.text!.count<=0
        {
            self.showToast(message:Constants.emptyPhoneMsg)

        }
        
        else if txtPhone.text!.count < 7
        {
            self.showToast(message:Constants.phoneLengthMsg)

        }
        else if txtPhone.text!.count >= 15
        {
            self.showToast(message:Constants.phoneLengthMsg2)
        }
        
        else if txtDate.text!.count<=0
        {
            self.showToast(message: Constants.demoEmptyDateMsg)
        }
        else if txtTime.text!.count<=0
        {
            self.showToast(message: Constants.demoEmptyTimeMsg)
        }
        else if txtDemo.text!.count<=0
        {
            self.showToast(message: Constants.demoEmptyDemoMsg)
        }
        else
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

                    let alert = UIAlertController(title: Constants.appName, message: Constants.ReqDemoMessage, preferredStyle: UIAlertController.Style.alert)
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
                    print("hfdgfkdsfkdsf")
                    self.requestForDemo()
                }
                
            }
            
        }
    }
    
    
    
    
    func getDemoList(){
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = [
            "access_token":sharedData.getAccessToken()
        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.pdtDemoURL
        print("loginURL",loginURL)
        
        AF.request(loginURL, method: .post, parameters: postDict, encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
            print("Response demo_product:***:",data.description)
            
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
                    self.pdtListResponseModel = PdtListResponseModel(response)
                    let statusCode = Int((self.pdtListResponseModel?.httpcode)!)
                    if statusCode == 200{
                        
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//
                            self.pdtList = self.pdtListResponseModel!.pdtListData!
                            print("self.self.pdtList ----- ",self.pdtList)
                            for item in self.pdtList
                            {
                                
                                self.ReqDemoNameArray.append(item.productTitle!)
//                                self.dropDemoPdtList.optionArray.append(item.productTitle!)
                                self.dropDemoPdtList.optionIds?.append(Int(item.productId!)!)
                            }
                            self.ReqDemoNameArray =  self.ReqDemoNameArray.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }

                            self.dropDemoPdtList.optionArray = self.ReqDemoNameArray
                            
                            //self.dropDemoPdtList.optionArray = ["Option 1", "Option 2", "Option 3"]
                            //Its Id Values and its optional
                            //self.dropDemoPdtList.optionIds = [1,23,54,22]
//                        }
                    }
                    if statusCode == 400{
                        self.showToast(message: (self.pdtListResponseModel?.message)!)
                    }
                    self.view.activityStopAnimating()
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    
    func getCountryList(){
        
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
                            print("self.self.pdtList ----- ",self.pdtList)
                          
//                        }
                    }
                    if statusCode == 400{
                        self.showToast(message: (self.countryListModel?.message)!)
                    }
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    
    
    
    @IBAction func btnCancelAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //PdtDemoList
    
    func requestForDemo()
    {
        self.view.activityStartAnimating()
        if txtDemo.text == "Request Demo"
        {
            txtDemo.text = ""
        }
        var postDict = Dictionary<String,String>()
        postDict = ["name":txtName.text!,
                    "address":txtAddress.text!,
                    "city":txtCity.text!,
                    //            "country":txtCountry.text!,
                                "country":sSelectedCountryCode,
                                "mobile":txtPhone.text!,
                    "email":txtEmail.text!,
//                    "date":txtDate.text!,
                    "date":sSelectedDate,
                    "time":txtTime.text!,
                    "product_id":self.selectedPdtID!,
                    "remarks":txtDemo.text!,
                    "access_token":sharedData.getAccessToken()
        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.demoRequestURL
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
                    if statusCode == 200{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
                        {
                            self.view.activityStopAnimating()
                            self.showToast(message: (self.demoResponseModel?.message)!)

                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
                            {
                                self.navigationController?.popViewController(animated: true)

                            }
                            

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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
