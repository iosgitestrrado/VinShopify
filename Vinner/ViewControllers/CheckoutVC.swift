//
//  CheckoutVC.swift
//  Vinner
//
//  Created by softnotions on 23/07/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire
import SwiftyJSON
//import CryptoSwift
import BraintreeDropIn
import Braintree

class CheckoutVC: UIViewController,BTViewControllerPresentingDelegate,BTAppSwitchDelegate {
    var cartID:String?
    var payFortClickStatus:Bool = false
    var payPalClickStatus:Bool = false
    var codClickStatus:Bool = false
    
    let braintreeToken = "sandbox_gpf95mc9_3zj8334nxfxh8nrs"
    var braintreeClient: BTAPIClient?
    var paycontroller = PayFortController.init(enviroment: KPayFortEnviromentProduction)
//    var paycontroller = PayFortController()
    
    // Live Details
//
//    let requestPhrase = "94QSRWC0rNrBtlZokOc6xe?)"
//    let accessCode = "6lUbMI3TtImE92epfeJ1"
//    let merchantIdentifier = "WaGobKuL"
//
    
    
    // Test Details
    
    let requestPhrase = "27aVEaXzC8qDf5aHJhze6o?}"
    let accessCode = "WGG6Avj6KSL4SX4zfWGQ"
    let merchantIdentifier = "879b45fb"
    
    @IBOutlet weak var btnCOD: UIButton!
    @IBOutlet weak var btnPaypal: UIButton!
    @IBOutlet weak var btnPayfort: UIButton!
    var addAddressModel:AddAddressModel?
    
    
    var sdkResponseModel:PayfortSdkResponseModel?
    var sdk_token:Sdk_token?
    var sdkTokenData:Sdk_tokenData?

    
    
    
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var viewDebit: UIView!
    @IBOutlet weak var viewVisa: UIView!
    @IBOutlet weak var viewPaypal: UIView!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var btnMakePayment: UIButton!
    @IBOutlet weak var lblItemTotal: UILabel!
    
    @IBOutlet weak var lblGTotal: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblDelFee: UILabel!
    var itemTotal:String?
    var delFee:String?
    var subTotal:String?
    var grantTotal:String?
    var delAddress:String?
    var sAmount:String?
    var sAmountPayPal:String?
    // Change
    var address_type:String?
    var housename:String?
    var roadname:String?
    var landmark:String?
    var sZip:String?
    var sCountry:String?

    var sCity:String?
    var sName:String?
    var sCurrency:String?

    
    
    let sharedData = SharedDefault()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.addCustControls()
        //self.addBackButton(title: "Checkout")
        // Do any additional setup after loading the view.

        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        print("viewWillAppear ----- ",self.cartID)
//        braintreeClient = BTAPIClient(authorization: braintreeToken)!
//        BTAppSwitch.setReturnURLScheme("com.softnotions.vinner.payments")
//        if self.sAmount!.count > 0
//        {
//            let subtotalfg = Int(self.sAmount!)
//            let iAmount =  subtotalfg! * 1000
//            self.sAmount = String(iAmount)
//        }
        
//        BTAppSwitch.setReturnURLScheme("com.vinshopify.vinner.payments")
//        self.sAmount = String(Int(self.sAmount) * 1000)
        
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear -----viewDidAppear ")
        braintreeClient = BTAPIClient(authorization: braintreeToken)!
//        BTAppSwitch.setReturnURLScheme("com.softnotions.vinner.payments")
        BTAppSwitch.setReturnURLScheme("com.vinshopify.vinner.payments")

        
        self.addBackButton(title: "Checkout")
//        self.addCustControls()
//        self.addCustomNavigationBackButton()
        
        
        
        //self.navigationController?.navigationBar.topItem?.title = "Checkout"
        btnMakePayment.layer.cornerRadius = 5
        viewDebit.layer.cornerRadius = 5
        viewDebit.layer.borderWidth = 1.0
        viewDebit.layer.borderColor = Constants.borderColor.cgColor
//
        viewVisa.layer.cornerRadius = 5
        viewVisa.layer.borderWidth = 1.0
        viewVisa.layer.borderColor = Constants.borderColor.cgColor
//
        viewPaypal.layer.cornerRadius = 5
        viewPaypal.layer.borderWidth = 1.0
        viewPaypal.layer.borderColor = Constants.borderColor.cgColor
//
        viewAddress.layer.cornerRadius = 5
        viewAddress.layer.borderWidth = 1.0
        viewAddress.layer.borderColor = Constants.borderColor.cgColor
        
        self.lblItemTotal.text = itemTotal
        self.lblDelFee.text = delFee
        self.lblSubTotal.text = subTotal
        self.lblGTotal.text = grantTotal
        self.lblAddress.text = delAddress
        self.sAmountPayPal = sAmount
//        self.paycontroller = PayFortController.init(enviroment: KPayFortEnviromentSandBox)
        self.paycontroller?.isShowResponsePage = true
        self.paycontroller!.setPayFortCustomViewNib("PayFortView2")
    }
    
    
    @IBAction func btnCODAction(_ sender: UIButton)
    {
        self.btnCOD.backgroundColor = UIColor.lightText
        self.codClickStatus = true
        self.btnPaypal.backgroundColor = UIColor.clear
        self.btnPayfort.backgroundColor = UIColor.clear
        self.payPalClickStatus = false
        self.payFortClickStatus = false

        
    }
    @IBAction func btnPaypalAction(_ sender: UIButton) {
        print("btnPaypalAction")
        self.btnPaypal.backgroundColor = UIColor.lightText
        self.payPalClickStatus = true
        self.btnCOD.backgroundColor = UIColor.clear
        self.codClickStatus = false
        self.btnPayfort.backgroundColor = UIColor.clear
        self.payFortClickStatus = false

//        self.btnPaymentAction(btnPaypal)
    }
    
    @IBAction func btnPayfortAction(_ sender: UIButton)
    {
        print("btnPayfortAction")
        self.payFortClickStatus = true
        self.btnPayfort.backgroundColor = UIColor.lightText
        self.btnPaypal.backgroundColor = UIColor.clear
        self.payPalClickStatus = false
        self.btnCOD.backgroundColor = UIColor.clear
        self.codClickStatus = false
//         self.btnPaymentAction(btnPayfort)
    }
    
    @IBAction func btnPaymentAction(_ sender: UIButton)
    {
        if self.payFortClickStatus == true
        {
          
//            self.createApiRequestForInitPayment ()
            
            
            self.SDKTokenGenerationAPI()
            
            
        }
        else if self.payPalClickStatus == true
        {
            self.startPaypalCheckout()
        }
        else if self.codClickStatus == true
        {
//            self.makePayment(paymentStatus: "due", paymentMethod: "cod")
            self.makePayment(paymentStatus: "due", paymentMethod: "cod", paymentDetails: "")
        }
            
        else
        {
            self.showToast(message: "Select a payment method")
        }
        
        
        
        
        //self.makePayment()
        
    }
    
    func makePayment(paymentStatus:String,paymentMethod:String,paymentDetails:String) {
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = ["access_token":sharedData.getAccessToken(),
                    "address_type":self.address_type! as String,
                    "housename":self.housename! as String,
                    "roadname":self.roadname! as String,
                    "landmark":self.landmark! as String,
                    "pincode":self.sZip! as String,
                    "payment_status":paymentStatus,
                    "payment_method":paymentMethod,
                    "payment_details":paymentDetails,
                    "country_name":sCountry! as String,
                    "city":sCity! as String,
                    "name":sName! as String,
                    "operator_id":sharedData.getOperatorID()
        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.paymentURL
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
                    self.addAddressModel = AddAddressModel(response)
                    
                    let statusCode = Int((self.addAddressModel?.httpcode)!)
                    if statusCode == 200
                    {
                        print("registerResponseModel ----- ",self.addAddressModel)
//                        self.showToast(message: (self.addAddressModel?.message)!)
                        
                        self.showToast(message:"Order placed successfully")

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            
                            
                            
                            self.btnCOD.backgroundColor = UIColor.clear
                            self.codClickStatus = false
                            
                            self.sharedData.clearOperatorID()
                            self.sharedData.clearOperatorName()
                            
                            
//                            self.tabBarController?.tabBar.items![2].badgeValue = "2"
//                            self.tabBarController?.selectedIndex = 2
//                            let next = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! TabBarController
//                            self.navigationController?.pushViewController(next, animated: true)
                            
                            // Change by Praveen
                            self.sCurrency = ""
                            self.sName = ""
                            self.itemTotal = ""
                            self.delFee = ""
                            self.subTotal = ""
                            self.grantTotal = ""
                            self.delAddress = ""
                            self.sAmount = ""
                            self.address_type = ""
                            self.housename = ""
                            self.roadname = ""
                            self.landmark = ""
                            self.sZip = ""
                            self.sCity = ""
                            self.payFortClickStatus = false
                            self.payPalClickStatus = false
                            self.codClickStatus = false
                            self.btnCOD.backgroundColor = UIColor.clear
                            self.btnPayfort.backgroundColor = UIColor.clear
                            self.btnPaypal.backgroundColor = UIColor.clear

                            let next = self.storyboard?.instantiateViewController(withIdentifier: "MyOrderVC") as? MyOrderVC
                            next!.bFromCheckoutPage = true
//                            let backItem = UIBarButtonItem()
//                            backItem.title = "Your Orders"
//                            self.navigationItem.backBarButtonItem = backItem
                            self.navigationController?.pushViewController(next!, animated: true)
                            

                            
                        }
                        
                    }
                    if statusCode == 400{
                        self.view.activityStopAnimating()
                        self.showToast(message: (self.addAddressModel?.message)!)
                    }
                    
                    
                    self.view.activityStopAnimating()
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    ////////
func makePaymentPayfortStatus(paymentStatus:String,paymentMethod:String,paymentDetails:String,merchant_reference:String) {
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = ["access_token":sharedData.getAccessToken(),
                    "address_type":self.address_type! as String,
                    "housename":self.housename! as String,
                    "roadname":self.roadname! as String,
                    "landmark":self.landmark! as String,
                    "pincode":self.sZip! as String,
                    "payment_status":paymentStatus,
                    "payment_method":paymentMethod,
                    "payment_details":paymentDetails,
                    "country_name":sCountry! as String,
                    "city":sCity! as String,
                    "name":sName! as String,
                    "operator_id":sharedData.getOperatorID(),
                    "merchant_reference":merchant_reference
        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.paymentPayfortStatusURL
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
                    self.addAddressModel = AddAddressModel(response)
                    
                    let statusCode = Int((self.addAddressModel?.httpcode)!)
                    if statusCode == 200
                    {
                        print("registerResponseModel ----- ",self.addAddressModel)
//                        self.showToast(message: (self.addAddressModel?.message)!)
                        
                        self.showToast(message:"Order placed successfully")

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            
                            
                            
                            self.btnCOD.backgroundColor = UIColor.clear
                            self.codClickStatus = false
                            
                            self.sharedData.clearOperatorID()
                            self.sharedData.clearOperatorName()
                            

                            
                            // Change by Praveen
                            self.sCurrency = ""
                            self.sName = ""
                            self.itemTotal = ""
                            self.delFee = ""
                            self.subTotal = ""
                            self.grantTotal = ""
                            self.delAddress = ""
                            self.sAmount = ""
                            self.address_type = ""
                            self.housename = ""
                            self.roadname = ""
                            self.landmark = ""
                            self.sZip = ""
                            self.sCity = ""
                            self.payFortClickStatus = false
                            self.payPalClickStatus = false
                            self.codClickStatus = false
                            self.btnCOD.backgroundColor = UIColor.clear
                            self.btnPayfort.backgroundColor = UIColor.clear
                            self.btnPaypal.backgroundColor = UIColor.clear

                            let next = self.storyboard?.instantiateViewController(withIdentifier: "MyOrderVC") as? MyOrderVC
                            next!.bFromCheckoutPage = true

                            self.navigationController?.pushViewController(next!, animated: true)
                            

                            
                        }
                        
                    }
                    if statusCode == 400{
                        self.view.activityStopAnimating()
                        self.showToast(message: (self.addAddressModel?.message)!)
                    }
                    
                    
                    self.view.activityStopAnimating()
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                    self.view.activityStopAnimating()

                }
            }
        }
    }
    
    
    
    
    
    
    
    
    func SDKTokenGenerationAPI() {
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = ["access_token":sharedData.getAccessToken(),
                    "device_id":UIDevice.current.identifierForVendor!.uuidString,
                    "address_type":self.address_type! as String,
                    "housename":self.housename! as String,
                    "roadname":self.roadname! as String,
                    "landmark":self.landmark! as String,
                    "pincode":self.sZip! as String,
                    "payment_status":"due",
                    "payment_method":"Payfort",
//                    "payment_details":paymentDetails,
                    "country_name":sCountry! as String,
                    "city":sCity! as String,
                    "name":sName! as String,
                    "operator_id":sharedData.getOperatorID()
                    
        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.sdkTokeURL
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
                    self.sdkResponseModel = PayfortSdkResponseModel(response)
                    
                    let statusCode = Int((self.sdkResponseModel?.httpcode)!)
                    if statusCode == 200
                    {
                        print("registerResponseModel ----- ",self.sdkResponseModel)
                        self.showToast(message: (self.sdkResponseModel?.message)!)
                        
                        self.sdk_token = self.sdkResponseModel?.sdk_token
                        
                        self.sdkTokenData = self.sdk_token?.sdk_tokenData
                        
                        
                        self.paycontroller!.isShowResponsePage = true
                        self.paycontroller!.setPayFortCustomViewNib("PayFortView2")
                        
                        self.connectPaymentGateway(token:(self.sdkTokenData?.sdk_token)!)

//                        self.createApiRequestForInitPayment()
                        
                        
                        
                        
                    }
                    if statusCode == 400{
                        self.view.activityStopAnimating()
                        self.showToast(message: (self.sdkResponseModel?.message)!)
                    }
                    
                    
                    self.view.activityStopAnimating()
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    
    func showDropIn(clientTokenOrTokenizationKey: String) {
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
        { (controller, result, error) in
            if (error != nil) {
                print("ERROR")
            } else if (result?.isCancelled == true) {
                print("CANCELLED")
            } else if let result = result {
                // Use the BTDropInResult properties to update your UI
                // result.paymentOptionType
                // result.paymentMethod
                // result.paymentIcon
                // result.paymentDescription
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
    }
    
    func startPaypalCheckout() {
        // Example: Initialize BTAPIClient, if you haven't already
        //braintreeClient = BTAPIClient(authorization: braintreeToken)!
        
        let payPalDriver = BTPayPalDriver(apiClient: braintreeClient!)
        payPalDriver.viewControllerPresentingDelegate = self
        payPalDriver.appSwitchDelegate = self // Optional
        
        // Specify the transaction amount here. "2.32" is used in this example.
//        let request = BTPayPalRequest(amount:"2.32")
        
        let request = BTPayPalRequest(amount:self.sAmountPayPal ?? "0.00")
        request.displayName = sName
        request.currencyCode = sCurrency//USD//AED // Optional; see BTPayPalRequest.h for more options
        
        payPalDriver.requestOneTimePayment(request) { (tokenizedPayPalAccount, error) in
            if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
                print("tokenizedPayPalAccount: \(tokenizedPayPalAccount)")
                // Access additional information
                let email = tokenizedPayPalAccount.email
                let firstName = tokenizedPayPalAccount.firstName
                let lastName = tokenizedPayPalAccount.lastName
                let phone = tokenizedPayPalAccount.phone
                
                // See BTPostalAddress.h for details
                let billingAddress = tokenizedPayPalAccount.billingAddress
                let shippingAddress = tokenizedPayPalAccount.shippingAddress
                self.btnPaypal.backgroundColor = UIColor.clear
                self.payPalClickStatus = false
                
//                self.makePayment(paymentStatus: "paid", paymentMethod: "Paypal")
                self.makePayment(paymentStatus: "paid", paymentMethod: "Paypal", paymentDetails: "")
            } else if let error = error {
                // Handle error here...
                self.btnPaypal.backgroundColor = UIColor.clear
                self.payPalClickStatus = false
                self.showToast(message: "Payment is not approved by Paypal")
            } else {
                // Buyer canceled payment approval
                self.showToast(message: "Buyer canceled payment approval")
                self.btnPaypal.backgroundColor = UIColor.clear
                self.payPalClickStatus = false
                
            }
        }
    }
    
    // MARK: Payfort
    
    func createApiRequestForInitPayment() {
        
        do {
            let bodyDict:[String:Any] = getRequestBody()
            let jsonData = try JSONSerialization.data(withJSONObject: bodyDict, options: .prettyPrinted)
            let request: URLRequest = HttpRequest.prepareHttpRequestWith(headers:nil,
                                                                         body:jsonData,
                                                                         apiUrlStr:"paymentApi",
                                                                         method:HttpMethod.POST)
            
            
            AF.request(request).responseJSON(completionHandler: { (response: AFDataResponse<Any>) -> () in
                print(response)
                //ProgressHUD.hideProgressHud(view: self.view)
                
                print("response.result ---",response.result)
                do{//mmdrs.itd@@2020//mmdrs.itd@@2020ssssdfsdfdsfdsfdsdsdfsdfsdfsdfdxcvcxvxcvxcvc
                    let dictionary = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                   
                   
                    if dictionary.value(forKey: "response_message")! as! String == "Success"
                    {
                        print(dictionary.value(forKey: "response_message")!)
                        self.paycontroller!.isShowResponsePage = true
                        self.paycontroller!.setPayFortCustomViewNib("PayFortView2")
                        
//                        let myView = Bundle.main.loadNibNamed("PayFortView2", owner: nil, options: nil)![0] as! UIView
//                        myView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
//                        self.view.addSubview(myView)
                  
                    }
                    
                    
                    
                    self.connectPaymentGateway(token:(self.sdkTokenData?.sdk_token)!)
                    
                }catch{ print("something wrong")
                    
                }
                
                
//                
//                 self.createPaymentApiRequest(response: response.result.value)
            })
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
    
    
    func getRequestBody() -> [String:Any] {
        let payloadDict = NSMutableDictionary()

        // Live Details
        payloadDict.setValue("en", forKey:"language" )
        payloadDict.setValue("WaGobKuL", forKey: "merchant_identifier")
        payloadDict.setValue("6lUbMI3TtImE92epfeJ1", forKey:"access_code" )
        payloadDict.setValue("SDK_TOKEN", forKey:"service_command" ) //SDK_TOKEN


//
//        // Test Details
//        payloadDict.setValue("en", forKey:"language" )
//        payloadDict.setValue(String(self.sdkTokenData?.merchant_reference ?? ""), forKey: "merchant_identifier")
//        payloadDict.setValue((self.sdkTokenData?.access_code ?? ""), forKey:"access_code" )
//        payloadDict.setValue("SDK_TOKEN", forKey:"service_command" ) //SDK_TOKEN
//



        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        payloadDict.setValue(deviceID, forKey:"device_id")

        //let paymentString = "TESTSHAINaccess_code=WGG6Avj6KSL4SX4zfWGQdevice_id=\(deviceID)language=enmerchant_identifier=879b45fbservice_command=SDK_TOKENTESTSHAIN"
        //let paymentString = "TESTSHAINaccess_code=WGG6Avj6KSL4SX4zfWGQdevice_id=\(deviceID)language=enmerchant_identifier=879b45fbservice_command=SDK_TOKENTESTSHAIN"

//        let paymentString = requestPhrase + "access_code=" + accessCode + "device_id=" + deviceID + "language=en" + "merchant_identifier=" + merchantIdentifier + "service_command=SDK_TOKEN" + requestPhrase

//        let base64Str = paymentString.sha256()
//        payloadDict.setValue(base64Str, forKey:"signature")
        
        
        
        
        
        
        payloadDict.setValue((self.sdkTokenData?.signature ?? ""), forKey:"signature")

        return payloadDict as! [String : Any]

    }
    
    
    func createPaymentApiRequest(response:Dictionary<String,Any>?) {
        if (response != nil) {
            print("response",response)
            let responseDict = response
            let tokenStr = responseDict!["sdk_token"] as! String
            //let marchantRefStr = responseDict!["merchant_identifier"] as! String
            let marchantRefStr = self.cartID
            let payloadDict = NSMutableDictionary.init()
            payloadDict.setValue((self.sdkTokenData?.sdk_token)! , forKey: "sdk_token")
            
            
            
            let subtotalfg = Double(self.sAmount!)
            var iAmount =  subtotalfg! * 1000

    //        if self.sAmount!.count < 2
    //        {
            
            if sCurrency == "AED"
            {
                iAmount = subtotalfg! * 100

            }
            else if sCurrency == "BHD"
            {
    //            if self.sAmount?.count == 1 || self.sAmount!.count > 3
    //            {
                    iAmount = subtotalfg! * 1000

    //            }

            }
            else
            {
                iAmount = subtotalfg! * 100

            }
            
            
            
            payloadDict.setValue(String(iAmount), forKey: "amount")
            
//            payloadDict.setValue("AUTHORIZATION", forKey: "command")//PURCHASE   AUTHORIZATION
            
            payloadDict.setValue("PURCHASE", forKey: "command")//PURCHASE   AUTHORIZATION

            payloadDict.setValue(self.sCurrency, forKey: "currency")
            
            let deviceID = UIDevice.current.identifierForVendor!.uuidString
            payloadDict.setValue(deviceID, forKey:"device_id")
            
            
            if self.sharedData.getUserEmail().count > 0
            {

                payloadDict.setValue(self.sharedData.getUserEmail(), forKey: "customer_email")

            }

            payloadDict.setValue("en", forKey: "language")
            payloadDict.setValue((self.sdkTokenData?.merchant_reference), forKey: "merchant_reference")
            //payloadDict.setValue(marchantRefStr, forKey: "merchant_reference")
            payloadDict.setValue("VISA" , forKey: "payment_option")
            
            print("payloadDict",payloadDict)
            
            
            paycontroller!.callPayFort(withRequest: payloadDict, currentViewController: self,
                                       success: { (requestDic, responeDic) in

                                        //print("Success:\(String(describing: responeDic))")

                                        print("Success:\n",responeDic! as Dictionary)
                                        self.btnPayfort.backgroundColor = UIColor.clear
                                        self.payFortClickStatus = false

                                        self.makePayment(paymentStatus: "paid", paymentMethod: "Payfort", paymentDetails: "")


            },
                                       canceled: { (requestDic, responeDic) in
                                        self.btnPayfort.backgroundColor = UIColor.clear
                                        self.payFortClickStatus = false
                                        //print("Canceled:\(String(describing: responeDic))")
                                        print("Canceled:\n",responeDic! as Dictionary)

            },
                                       faild: { (requestDic, responeDic, message) in
                                        self.btnPayfort.backgroundColor = UIColor.clear
                                        self.payFortClickStatus = false
                                       // print("Failure:\(String(describing: responeDic))")

                                        print("Failure:\n",responeDic! as Dictionary)

                                        print("Failure:\n",responeDic!["sdk_token"] as! String)

                                        print("Failure message:\(String(describing: message))")

            })
        }
    }
    
    
    // MARK: - BTViewControllerPresentingDelegate
    
    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
        //present(viewController, animated: true, completion: nil)
    }
    
    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        //viewController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - BTAppSwitchDelegate
    
    
    // Optional - display and hide loading indicator UI
    func appSwitcherWillPerformAppSwitch(_ appSwitcher: Any) {
        
    }
    
    func appSwitcherWillProcessPaymentInfo(_ appSwitcher: Any) {
        
    }
    
    func appSwitcher(_ appSwitcher: Any, didPerformSwitchTo target: BTAppSwitchTarget) {
        
    }
    
    // MARK: - Private methods
    
    func showLoadingUI() {
        // ...
    }
    
    @objc func hideLoadingUI() {
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func connectPaymentGateway(token:String){
        
        let marchantRefStr = (self.sdkTokenData?.merchant_reference)!
        
//        let marchantRefStr = self.cartID

        let subtotalfg = Double(self.sAmount!)
        var iAmount =  subtotalfg! * 1000

//        if self.sAmount!.count < 2
//        {
        
        if sCurrency == "AED"
        {
            iAmount = subtotalfg! * 100

        }
        else if sCurrency == "BHD"
        {
//            if self.sAmount?.count == 1 || self.sAmount!.count > 3
//            {
                iAmount = subtotalfg! * 1000

//            }

        }
        else
        {
            iAmount = subtotalfg! * 100

        }
        let request = NSMutableDictionary.init()
        request.setValue(iAmount , forKey: "amount")
        
//        request.setValue("AUTHORIZATION", forKey: "command")
        
        request.setValue("PURCHASE", forKey: "command")//PURCHASE   AUTHORIZATION

        request.setValue(sCurrency, forKey: "currency")
        
        if self.sharedData.getUserEmail().count > 0
        {

            request.setValue(self.sharedData.getUserEmail(), forKey: "customer_email")

        }
        request.setValue(UIDevice.current.identifierForVendor!.uuidString, forKey: "device_id")

        request.setValue("en", forKey: "language")
        request.setValue(marchantRefStr, forKey: "merchant_reference")
        request.setValue(token , forKey: "sdk_token")
        request.setValue("VISA" , forKey: "payment_option")

        OperationQueue.main.addOperation {

            
            
            
            self.paycontroller!.callPayFort(withRequest: request, currentViewController: self,
                                      success: { (requestDic, responeDic) in

                                        print("success")
                                        print("responeDic=\(String(describing: responeDic))")

                                        print("Success:\n",responeDic! as Dictionary)
                                        self.btnPayfort.backgroundColor = UIColor.clear
                                        self.payFortClickStatus = false
                                        
                                        
                                        let arrayResponse = Array(responeDic!.values)
                                        
                                        for value in Array(responeDic!.values)
                                        {
                                            print("\(value)")
                                        }
                                        print(responeDic?["fort_id"] as? String ?? "")
                                        
                                         let sPayfortId = responeDic?["fort_id"] as? String ?? ""
                                        let sPaymentOption = responeDic?["payment_option"] as? String ?? ""

                                        let sPaymentDetails = "Payfort ID:" + "" + sPayfortId + " " + "Payment Option:" + "" + sPaymentOption
                                        
//                                        self.makePayment(paymentStatus: "paid", paymentMethod: "Payfort", paymentDetails: sPaymentDetails)
//
                                        
                                        print("Payment Details: ", sPaymentDetails)
                                        
                                        
                                        self.btnCOD.backgroundColor = UIColor.clear
                                        self.codClickStatus = false
                                        
                                        self.sharedData.clearOperatorID()
                                        self.sharedData.clearOperatorName()
                                        

                                        
                                        // Change by Praveen
                                        self.sCurrency = ""
                                        self.sName = ""
                                        self.itemTotal = ""
                                        self.delFee = ""
                                        self.subTotal = ""
                                        self.grantTotal = ""
                                        self.delAddress = ""
                                        self.sAmount = ""
                                        self.address_type = ""
                                        self.housename = ""
                                        self.roadname = ""
                                        self.landmark = ""
                                        self.sZip = ""
                                        self.sCity = ""
                                        self.payFortClickStatus = false
                                        self.payPalClickStatus = false
                                        self.codClickStatus = false
                                        self.btnCOD.backgroundColor = UIColor.clear
                                        self.btnPayfort.backgroundColor = UIColor.clear
                                        self.btnPaypal.backgroundColor = UIColor.clear

                                        let next = self.storyboard?.instantiateViewController(withIdentifier: "MyOrderVC") as? MyOrderVC
                                        next!.bFromCheckoutPage = true

                                        self.navigationController?.pushViewController(next!, animated: true)
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
//                                        self.makePaymentPayfortStatus(paymentStatus: "paid", paymentMethod: "Payfort", paymentDetails: sPaymentDetails, merchant_reference: marchantRefStr)
                                        

            },canceled: { (requestDic, responeDic) in
                print("canceled")
                print("responeDic=\(String(describing: responeDic))")
                self.btnPayfort.backgroundColor = UIColor.clear
                self.payFortClickStatus = false
                
            },faild: { (requestDic, responeDic, message) in
                print("faild")
                self.btnPayfort.backgroundColor = UIColor.clear
                self.payFortClickStatus = false
                print("responeDic=\(String(describing: responeDic))")
                print("message=\(String(describing: message))")
                var msgStr = "Please try again later"
                if let msgString = message {
                    msgStr = "\(msgString)\n\(msgStr)"
                }
                let alert = UIAlertController(title: "Payment Failed", message: msgStr, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in

//                    self.navigationController?.popToRootViewController(animated: true)

                }))
                self.present(alert, animated: true, completion: nil)

            })
        }
    }
}
