//
//  VerifyOTPVC.swift
//  Vinner
//
//  Created by softnotions on 19/07/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire
import SwiftyJSON

class VerifyOTPVC: UIViewController,UITextFieldDelegate {
    var verifyOTPResp:VerifyOTPResponseModel?
    var phoneNumber:String?
    var countryCode:String?

    let sharedData = SharedDefault()
    let sharedDefault = SharedDefault()

    @IBOutlet weak var txtOTP: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var imgOTP: UIImageView!
    @IBOutlet weak var scrollOTP: UIScrollView!
    
    override func viewWillAppear(_ animated: Bool) {
        //self.title = "Verify OTP"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = " "
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "NavBG"), for: UIBarMetrics.default)
        UserDefaults.standard.setValue("No", forKey: "CartCleared")
        self.addBackButton(title: "Back")

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
        btnSubmit.layer.cornerRadius = 10
        txtOTP.delegate = self
        txtOTP.addLine(position: .LINE_POSITION_BOTTOM, color: UIColor(red: 136.0/255.0, green: 136.0/255.0, blue: 136.0/255.0, alpha: 1.0), width: 0.5)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelNumberPad)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWithNumberPad))]
        numberToolbar.sizeToFit()
        txtOTP.inputAccessoryView = numberToolbar
        
    }
    
    
    @objc func cancelNumberPad() {
           //Cancel with number pad
           txtOTP.resignFirstResponder()
       }
       @objc func doneWithNumberPad() {
           //Done with number pad
           txtOTP.resignFirstResponder()
       }
    
    
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollOTP.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollOTP.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollOTP.contentInset = contentInset
    }
    // MARK: UITextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func verifyOTP()
    {
        
        let sharedData = SharedDefault()
        var tokenStr = String()
        let userdefaults = UserDefaults.standard
        if let savedValue = userdefaults.string(forKey: "fcm_token"){
            print("savedValue fcm_token ----- ",savedValue)
           
            tokenStr = sharedDefault.getFcmToken()
        } else {
             sharedDefault.setFcmToken(token: sharedDefault.getNewFcmToken())
            tokenStr = sharedDefault.getNewFcmToken()
        }
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = [
            "mobile":phoneNumber!,
            "otp":txtOTP.text!,
            "c_code":countryCode! as String,
            "device_token":tokenStr,
            "os":"ios"

        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.verifyOTPURL
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
                    self.verifyOTPResp = VerifyOTPResponseModel(response)
                    let statusCode = Int((self.verifyOTPResp?.httpcode)!)
                    if statusCode == 200
                    {
                        print("otpRespModel ----- ",self.verifyOTPResp!)
                        self.showToast(message: (self.verifyOTPResp?.message)!)
//                        self.showToast(message:"OTP verified successfully, login successfully")

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                             //print("self.phoneNumber ----- ",self.phoneNumber!)
                            
                            if self.verifyOTPResp?.verifyOTPData?.redirect == "Registeration"
                            {
                                let next = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
                                next.phoneNumber = self.phoneNumber! as String

                                next.sCountryCode = self.countryCode! as String

                                self.navigationController?.pushViewController(next, animated: true)
                            }
                            else if self.verifyOTPResp?.verifyOTPData?.redirect == "Dashboard"
                            {
                                topBool = true
                                
                                self.sharedData.setUserEmail(token: (self.verifyOTPResp?.verifyOTPData?.email)!)
                                self.sharedData.setAccessToken(token:(self.verifyOTPResp?.verifyOTPData?.accessToken)!)
                                self.sharedData.setLoginStatus(loginStatus: true)
                                self.sharedData.setProfileName(token: self.verifyOTPResp?.verifyOTPData?.username ?? "")

                                guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabbar") as? TabBarController else {
                                                                    return
                                                                }
                                                                let navigationController = UINavigationController(rootViewController: rootVC)

                                                                UIApplication.shared.windows.first?.rootViewController = navigationController
                                                                UIApplication.shared.windows.first?.makeKeyAndVisible()


                            }
//
                            
//                            let next = self.storyboard?.instantiateViewController(withIdentifier: "MoreVC") as! MoreVC
//
//                            self.navigationController?.pushViewController(next, animated: true)
                            
                            
                            
                            
//
                        }
                    }
                    if statusCode == 400
                    {
                        
                        self.showToast(message: (self.verifyOTPResp?.message)!)
                        
//                         // changes
//                        let next = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
//                        next.phoneNumber = self.phoneNumber! as String
//                        self.navigationController?.pushViewController(next, animated: true)

                    }
                    self.view.activityStopAnimating()
                }
                catch let err
                {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        
        self.txtOTP.resignFirstResponder()

        if Reachability.isConnectedToNetwork() {
            if self.txtOTP.text!.count <= 0 {
                 self.showToast(message: Constants.otpEmptyMsg)
            } else {

                self.verifyOTP()
            }
        }
        else {
            self.showToast(message: Constants.connectivityErrorMsg)//
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
