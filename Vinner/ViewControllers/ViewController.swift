//
//  ViewController.swift
//  Vinner
//
//  Created by softnotions on 17/07/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire
import SwiftyJSON
import CoreLocation
//import CryptoSwift

class ViewController: UIViewController,UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    let paycontroller = PayFortController.init(enviroment: KPayFortEnviromentSandBox)
    let sharedDefault = SharedDefault()
    
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var backGroundView: UIView!
    var locationManager = CLLocationManager()
    var itemsNames = ["AE","BH","SA"]
    var itemsImages = ["uae","baharin","saudi"]
    
     var itemsCode = ["+971","+973","+966"]
    var sScreenINdex = Int()

    @IBOutlet weak var imgCountry: UIImageView!
    
    @IBOutlet weak var tableCountry: UITableView!
    @IBOutlet weak var viewTable: UIView!
    @IBOutlet weak var btnDrop: UIButton!
    var otpRespModel: OTPResponseModel?
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var scrollLogin: UIScrollView!
    @IBOutlet weak var txtCountry: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        //        self.navigationController?.navigationBar.isHidden = true
                
                self.navigationController?.title = ""
                
                // Changes by Praveen
                UserDefaults.standard.setValue("", forKey: "Address")

                self.addBackButton1(title: "Back")
                
                btnSubmit.layer.cornerRadius = 5
                txtPhoneNumber.delegate = self
                txtCountry.delegate = self
                viewTable.layer.cornerRadius = 10
                viewTable.layer.borderWidth = 1.0
                viewTable.layer.borderColor = Constants.borderColor.cgColor
                
                //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
               // NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
               
                let viewS = UIView(frame: CGRect(x: 0, y: self.txtCountry.frame.size.height/2, width: 25, height: 25))
                self.txtCountry.rightViewMode = UITextField.ViewMode.always
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                let image = UIImage(named: "DownArrow")
                imageView.image = image
                viewS.addSubview(imageView)
                self.txtCountry.rightView = viewS
                
        
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.view2.addGestureRecognizer(gesture)
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))

        self.view1.addGestureRecognizer(gesture2)

                let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
                numberToolbar.barStyle = .default
                numberToolbar.items = [
                    UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelNumberPad)),
                    UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                    UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWithNumberPad))]
                numberToolbar.sizeToFit()
                txtPhoneNumber.inputAccessoryView = numberToolbar
                txtCountry.inputAccessoryView = numberToolbar
                /*
                locationManager = CLLocationManager()
                locationManager?.delegate = self
                locationManager?.requestAlwaysAuthorization()
                
                */
                
                if !(UIDevice.isSimulator)
                {
                    let countryLocale = NSLocale.current
                    let countryCode = countryLocale.regionCode
                    let country = (countryLocale as NSLocale).displayName(forKey: NSLocale.Key.countryCode, value: countryCode)!
                    print("country", country as String)
                    
                    
                    locationManager.requestWhenInUseAuthorization()
                    
                    print("LOC",CLLocationManager.authorizationStatus())
                    var currentLoc: CLLocation!
                    if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                        CLLocationManager.authorizationStatus() == .authorizedAlways) {
                        currentLoc = locationManager.location
                        
                        let user_lat = String(format: "%f", currentLoc.coordinate.latitude)
                        let user_long = String(format: "%f", currentLoc.coordinate.longitude)
                        
                        self.getAddressFromLatLon(pdblLatitude: user_lat, withLongitude: user_long)
                        print("user_lat ---",user_lat)
                        print("user_long --",user_long)
                        
                    } else {
                        locationManager.requestWhenInUseAuthorization()
                    }
                }
                    
                    
                self.tableCountry.delegate = self
                self.tableCountry.dataSource = self
                self.tableCountry.reloadData()
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                //self.view.addGestureRecognizer(tap)
                
                txtCountry.text = itemsCode[0]
                imgCountry.image = UIImage(named: itemsImages[0])
               
                sharedDefault.setCountyImg(token: itemsImages[0])
                sharedDefault.setCountyCode(token: itemsCode[0])
                sharedDefault.setCountyName(token:itemsNames[0])
               
                
                txtPhoneNumber.text = ""
                
                txtCountry.isEnabled = false

                //createApiRequestForInitPayment ()
            }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        // Do what you want
        viewTable.isHidden = true

    }
    
            
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        btnSubmit.layer.cornerRadius = 5
//        txtPhoneNumber.delegate = self
//        txtCountry.delegate = self
//        viewTable.layer.cornerRadius = 10
//        viewTable.layer.borderWidth = 1.0
//        viewTable.layer.borderColor = Constants.borderColor.cgColor
//
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
       // NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
       
//        let viewS = UIView(frame: CGRect(x: 0, y: self.txtCountry.frame.size.height/2, width: 25, height: 25))
//        self.txtCountry.rightViewMode = UITextField.ViewMode.always
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
//        let image = UIImage(named: "DownArrow")
//        imageView.image = image
//        viewS.addSubview(imageView)
//        self.txtCountry.rightView = viewS
//
//
//        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
//        numberToolbar.barStyle = .default
//        numberToolbar.items = [
//            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelNumberPad)),
//            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
//            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWithNumberPad))]
//        numberToolbar.sizeToFit()
//        txtPhoneNumber.inputAccessoryView = numberToolbar
//        txtCountry.inputAccessoryView = numberToolbar
        /*
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        */
        
//        if !(UIDevice.isSimulator)
//        {
//            let countryLocale = NSLocale.current
//            let countryCode = countryLocale.regionCode
//            let country = (countryLocale as NSLocale).displayName(forKey: NSLocale.Key.countryCode, value: countryCode)!
//            print("country", country as String)
//
//
//            locationManager.requestWhenInUseAuthorization()
//
//            print("LOC",CLLocationManager.authorizationStatus())
//            var currentLoc: CLLocation!
//            if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
//                CLLocationManager.authorizationStatus() == .authorizedAlways) {
//                currentLoc = locationManager.location
//
//                let user_lat = String(format: "%f", currentLoc.coordinate.latitude)
//                let user_long = String(format: "%f", currentLoc.coordinate.longitude)
//
//                self.getAddressFromLatLon(pdblLatitude: user_lat, withLongitude: user_long)
//                print("user_lat ---",user_lat)
//                print("user_long --",user_long)
//
//            } else {
//                locationManager.requestWhenInUseAuthorization()
//            }
//        }
            
            
//        self.tableCountry.delegate = self
//        self.tableCountry.dataSource = self
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
//        //self.view.addGestureRecognizer(tap)
//
//        txtCountry.text = itemsCode[0]
//        imgCountry.image = UIImage(named: itemsImages[0])
//
//        sharedDefault.setCountyImg(token: itemsImages[0])
//        sharedDefault.setCountyCode(token: itemsCode[0])
//        sharedDefault.setCountyName(token:itemsNames[0])
            
        
        
        
        self.navigationController?.navigationBar.topItem?.titleView = nil

        
        }
    
    
        @objc func handleTap(_ sender: UITapGestureRecognizer? = nil)
        {
            // handling code
            print("handleTap")
            viewTable.isHidden = true
        }
        
    
    
    
    // MARK: - tableview delegate
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if tableView == tableCountry {
            let countryCell = self.tableCountry.dequeueReusableCell(withIdentifier: "CountryTCell", for: indexPath) as! CountryTCell
            countryCell.lblCountry.text = itemsNames[indexPath.row]
            countryCell.imgCountry.image = UIImage(named: itemsImages[indexPath.row])
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
        txtCountry.text = itemsCode[indexPath.row]
        viewTable.isHidden = true
        imgCountry.image = UIImage(named: itemsImages[indexPath.row])
        print(itemsNames[indexPath.row])
        print(itemsCode[indexPath.row].dropFirst(1))
        print(itemsImages[indexPath.row])
        
        sharedDefault.setCountyImg(token: itemsImages[indexPath.row])
        sharedDefault.setCountyCode(token: String(itemsCode[indexPath.row].dropFirst(1)))
        sharedDefault.setCountyName(token:itemsNames[indexPath.row])
        
        if itemsCode[indexPath.row] == "0"
        {
            txtCountry.isEnabled = true
        }
        else
        {
            txtCountry.isEnabled = false

        }
        
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
       
        return  1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsImages.count
    }
    // Make the background color show through
    
    
    
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon

        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]

                if pm.count > 0 {
                    let pm = placemarks![0]
                    print(pm.country)
                    print(pm.locality)
                    print(pm.subLocality)
                    print(pm.thoroughfare)
                    print(pm.postalCode)
                    print(pm.subThoroughfare)
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }


                    print(addressString)
              }
        })

    }
    
    @objc func cancelNumberPad() {
        //Cancel with number pad
        txtPhoneNumber.resignFirstResponder()
        txtCountry.resignFirstResponder()
    }
    @objc func doneWithNumberPad() {
        //Done with number pad
        txtPhoneNumber.resignFirstResponder()
        txtCountry.resignFirstResponder()

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollLogin.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollLogin.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollLogin.contentInset = contentInset
    }
    
    func sendOTP(){
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        var strCountryCode:String = self.txtCountry.text!
        
       
//        postDict = [
//            "mobile":  strCountryCode.dropFirst(1)   + txtPhoneNumber.text!,
//            "c_code":String(sharedDefault.getCountryCode().dropFirst(1))
//
//        ]
        
        
        postDict = [
            "mobile":txtPhoneNumber.text!,
            "c_code":String(strCountryCode.dropFirst(1))

        ]
        
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.sendOTPURL
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
                    self.otpRespModel = OTPResponseModel(response)
                    let statusCode = Int((self.otpRespModel?.httpcode)!)
                    if statusCode == 200{
                        
                        self.txtPhoneNumber.resignFirstResponder()
                        print("otpRespModel ----- ",self.otpRespModel!)
                        self.showToast(message: (self.otpRespModel?.message)!)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            let next = self.storyboard?.instantiateViewController(withIdentifier: "VerifyOTPVC") as! VerifyOTPVC
                            
//                            next.phoneNumber = strCountryCode.dropFirst(1)   + self.txtPhoneNumber.text!
                            next.phoneNumber =  self.txtPhoneNumber.text!
                            next.countryCode = String(self.txtCountry.text!.dropFirst(1))
                            self.navigationController?.pushViewController(next, animated: true)
                        }
                    }
                    if statusCode == 400{
                        self.showToast(message: (self.otpRespModel?.message)!)
                        self.txtPhoneNumber.resignFirstResponder()

                    }
                    self.view.activityStopAnimating()
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    
    
     // MARK: Action
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        
        
        
        if Reachability.isConnectedToNetwork()
        {
            if txtPhoneNumber.text!.count<=0
            {
                self.showToast(message:Constants.emptyPhoneMsg)
                self.txtPhoneNumber.resignFirstResponder()

            }
            else if txtPhoneNumber.text!.count > 7
            {
                if txtPhoneNumber.text!.count <= 15
                {
                    self.sendOTP()

                }
                else
                {
                    self.showToast(message:Constants.phoneLengthMsg2)
                    self.txtPhoneNumber.resignFirstResponder()

                }
            }
            else
            {
                self.txtPhoneNumber.resignFirstResponder()
                self.showToast(message:Constants.phoneLengthMsg)
            }
            
        }
        else
        {
            self.txtPhoneNumber.resignFirstResponder()
            self.showToast(message:Constants.connectivityErrorMsg)
        }
        
        
        //let next = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        //next.phoneNumber = txtPhoneNumber.text! as String
        //self.navigationController?.pushViewController(next, animated: true)
        
        
        
        //let next = self.storyboard?.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
        //self.navigationController?.pushViewController(next, animated: true)
        
        
        //let next = self.storyboard?.instantiateViewController(withIdentifier: "ChangePwdVC") as! ChangePwdVC
        //self.navigationController?.pushViewController(next, animated: true)
        
        //let next = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPwdVC") as! ForgotPwdVC
        //self.navigationController?.pushViewController(next, animated: true)
        
        
        //let next = self.storyboard?.instantiateViewController(withIdentifier: "AddNewAddressVC") as! AddNewAddressVC
        //self.navigationController?.pushViewController(next, animated: true)
        
        // let next = self.storyboard?.instantiateViewController(withIdentifier: "ReviewProductVC") as! ReviewProductVC
        // self.navigationController?.pushViewController(next, animated: true)
        
        // let next = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailsVC") as! OrderDetailsVC
        // self.navigationController?.pushViewController(next, animated: true)
        
        /*
         let next = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailsVC") as! OrderDetailsVC
         self.navigationController?.pushViewController(next, animated: true)
         
         
         let next = self.storyboard?.instantiateViewController(withIdentifier: "VerifyOTPVC") as! VerifyOTPVC
         self.navigationController?.pushViewController(next, animated: true)
         
         */
        
        
        //let next = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! TabBarController
        // self.navigationController?.pushViewController(next, animated: true)
        /*
         if txtPhoneNumber.text!.count>0 {
         if Reachability.isConnectedToNetwork() {
         
         }
         else {
         
         }
         } else {
         self.showToast(message:Constants.TxtPhoneEmpty)
         }
         */
    }
    @IBAction func btnRegisterAction(_ sender: UIButton) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.navigationController?.pushViewController(next, animated: true)
        
        //let next = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        //self.navigationController?.pushViewController(next, animated: true)
        
        //let next = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as? TabBarController
        //navigationController?.pushViewController(next!, animated: true)
       
       // self.tabBarController?.navigationItem.hidesBackButton = true
       //UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
           
       //UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "NavBG"), for: UIBarMetrics.default)
       let img = UIImage(named: "NavBG")
      // self.navigationController?.navigationBar.setBackgroundImage(img, for: .default)
        
       
       

       
 
        
    }
    
    @IBAction func btnDropAction(_ sender: Any) {
        print("btnDropAction")
        if self.viewTable.isHidden {
            self.viewTable.isHidden = false
            
        } else {
            self.viewTable.isHidden = true
            
            
        }
    }
    
     // MARK: Payfort
    
//    func createApiRequestForInitPayment() {
//
//        do {
//            let bodyDict:[String:Any] = getRequestBody()
//            let jsonData = try JSONSerialization.data(withJSONObject: bodyDict, options: .prettyPrinted)
//            let request: URLRequest = HttpRequest.prepareHttpRequestWith(headers:nil,
//                                                                         body:jsonData,
//                                                                         apiUrlStr:"paymentApi",
//                                                                         method:HttpMethod.POST)
//
//           // ProgressHUD.showProgressHud(message: "Wait...", view: self.view)
//
//            AF.request(request).responseJSON(completionHandler: { (response: AFDataResponse<Any>) -> () in
//                print(response)
//                //ProgressHUD.hideProgressHud(view: self.view)
//
//                print("response.result ---",response.result)
//                do{
//                    let dictionary = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
//                    print(dictionary)
//                    print(dictionary.value(forKey: "access_code"))
//
//                    self.createPaymentApiRequest(response: dictionary as! Dictionary<String, Any>)
//
//                }catch{ print("something wrong")
//
//                }
//
//
//
//                // self.createPaymentApiRequest(response: response.result.value)
//            })
//
////            AF.request(request).responseJSON(completionHandler: { (response: DataResponse<Any>) -> () in
////                print(response)
////                ProgressHUD.hideProgressHud(view: self.view)
////                self.createPaymentApiRequest(response: response.result.value)
////            })
//
//            //            Alamofire.request(request).responseObject { (response: DataResponse<InitPaymentMapper>) in
//            //                ProgressHUD.hideProgressHud(view: self.view)
//            //
//            //                guard let aPIModel: InitPaymentMapper = response.result.value else {
//            //                    Utility.showOkAlertView(title: Message.kMessage, message: "Something went wrong!", viewCtrl: self)
//            //
//            //                    return
//            //                }
//            //
//            //                if (aPIModel.data != nil && aPIModel.code == "200") {
//            //                    let number:Float = (aPIModel.data?.estimatedCost)!
//            //                    self.estimatedCost = String(number)
//            //                }
//            //                else {
//            //                    print("Failure response")
//            //                }
//            //
//            //
//            //            }
//
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
//
//    }
        
//
//        func getRequestBody() -> [String:Any] {
//            let payloadDict = NSMutableDictionary()
//            payloadDict.setValue("en", forKey:"language" )
//            payloadDict.setValue("WaGobKuL", forKey: "merchant_identifier")
//            payloadDict.setValue("6lUbMI3TtImE92epfeJ1", forKey:"access_code" )
//            payloadDict.setValue("SDK_TOKEN", forKey:"service_command" )
//
//            let deviceID = UIDevice.current.identifierForVendor!.uuidString
//            payloadDict.setValue(deviceID, forKey:"device_id")
//
//            let paymentString = "TESTSHAINaccess_code=WGG6Avj6KSL4SX4zfWGQdevice_id=\(deviceID)language=enmerchant_identifier=879b45fbservice_command=SDK_TOKENTESTSHAIN"
//
//
//            let base64Str = paymentString.sha256()
//            payloadDict.setValue(base64Str, forKey:"signature")
//
//            return payloadDict as! [String : Any]
//
//        }
        
        
        func createPaymentApiRequest(response:Dictionary<String,Any>?) {
            if (response != nil) {
                print("response",response)
                let responseDict = response
                let tokenStr = responseDict!["sdk_token"] as! String
                let marchantRefStr = responseDict!["merchant_identifier"] as! String
            
                let payloadDict = NSMutableDictionary.init()
                payloadDict.setValue(tokenStr , forKey: "sdk_token")
                payloadDict.setValue("1000", forKey: "amount")
                payloadDict.setValue("AUTHORIZATION", forKey: "command")
                payloadDict.setValue("AED", forKey: "currency")
                payloadDict.setValue("abcxxxx@damacgroup.com", forKey: "customer_email")
                payloadDict.setValue("en", forKey: "language")
                payloadDict.setValue(marchantRefStr, forKey: "merchant_reference")
                payloadDict.setValue("VISA" , forKey: "payment_option")
                
                
                paycontroller?.callPayFort(withRequest: payloadDict, currentViewController: self,
                                           success: { (requestDic, responeDic) in
                                            
                                            print("Success:\(String(describing: responeDic))")
                                            
                },
                                           canceled: { (requestDic, responeDic) in
                                            
                                            print("Canceled:\(String(describing: responeDic))")
                                            
                },
                                           faild: { (requestDic, responeDic, message) in
                                            
                                            print("Failure:\(String(describing: responeDic))")
                                            print("Failure message:\(String(describing: message))")
                                            
                })
            }
        }
        
    
}

