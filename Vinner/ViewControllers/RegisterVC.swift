//
//  RegisterVC.swift
//  Vinner
//
//  Created by softnotions on 19/07/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire
import SwiftyJSON

class RegisterVC: UIViewController,UITextFieldDelegate {
    var phoneNumber: String?

    var registerResponseModel: RegistrationResponseModel?
    @IBOutlet weak var txtCPwd: UITextField!
    @IBOutlet weak var viewCPwd: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmailID: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var viewRefferal: UIView!
    @IBOutlet weak var viewEmailID: UIView!
    @IBOutlet weak var viewUsername: UIView!
    
    // Change By Praveen
    @IBOutlet weak var viewPhoneNumber: UIView!
    
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var viewReferal: UIView!
    
    @IBOutlet weak var txtReferal: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var scrollRegister: UIScrollView!
    @IBOutlet weak var imgViewBG: UIImageView!
    @IBOutlet weak var imgAppTitle: UIImageView!
    var sCountryCode:String!
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.navigationBar.isHidden = false
        //self.title = "Registration"
       
            txtPhoneNumber.text = phoneNumber

        // Do any additional setup after loading the view.
        txtUsername.delegate = self
        txtEmailID.delegate = self
        txtPassword.delegate = self
        txtCPwd.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        btnRegister.layer.cornerRadius = 10
        self.navigationController?.navigationBar.topItem?.title = " "
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
    }
    // MARK: keyboard notification
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollRegister.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollRegister.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollRegister.contentInset = contentInset
    }
    // MARK: UITextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // MARK: - notification list method
       func registerNewUser()
       {
        
           self.view.activityStartAnimating()
           
           var postDict = Dictionary<String,String>()
        postDict = ["name":txtUsername.text!,
                    "email":txtEmailID.text!,
                    "password":txtPassword.text!,
                    "confirm_password":txtCPwd.text!,
                    "mobile":txtPhoneNumber.text!,
                    "c_code":sCountryCode! as String

           ]
           
           print("PostData: ",postDict)
           let loginURL = Constants.baseURL+Constants.registerURL
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
                       self.registerResponseModel = RegistrationResponseModel(response)
                       
                       let statusCode = Int((self.registerResponseModel?.httpcode)!)
                       if statusCode == 200{
                           print("registerResponseModel ----- ",self.registerResponseModel)
                        self.showToast(message: (self.registerResponseModel?.message)!)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            if self.registerResponseModel?.registrationData?.redirect == "Dashboard"
                            {
                                let sharedData = SharedDefault()
                                sharedData.setAccessToken(token: (self.registerResponseModel?.registrationData?.accessToken!)!)
                                sharedData.setLoginStatus(loginStatus: true)
                                let next = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! TabBarController
                                self.navigationController?.pushViewController(next, animated: true)
                            }
                        }
                        
                       }
                       if statusCode == 400{
                           
                        self.showToast(message: (self.registerResponseModel?.message)!)
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
    @IBAction func btnRegisterAction(_ sender: Any) {
        //let next = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! TabBarController
        //  self.navigationController?.pushViewController(next, animated: true)
        print("valid ======--------> ",txtEmailID.text!.isValidEmail())
        if Reachability.isConnectedToNetwork() {
            if txtUsername.text!.count<=0 {
                self.showToast(message:Constants.usernameEmptyMsg)
            }
            else  if txtEmailID.text!.count<=0 {
                self.showToast(message:Constants.emailEmptyMsg)
            }
            else  if txtPassword.text!.count<=0 {
                self.showToast(message:Constants.emptyPWD)
            }
            else  if txtCPwd.text!.count<=0 {
                self.showToast(message:Constants.emptyCPWD)
            }
          
            
            
            if txtPhoneNumber.text!.count<=0 {
                self.showToast(message:Constants.emptyPhoneMsg)
            }
            else if txtPhoneNumber.text!.count <= 8
            {
                self.showToast(message:Constants.phoneLengthMsg)
            }
            
            else {
                if !(txtEmailID.text!.isValidEmail()) {
                    self.showToast(message:Constants.invalidEmailMSG)
                    return
                }
                if txtCPwd.text! != txtPassword.text! {
                    self.showToast(message:Constants.confirmPwdMSG)
                    return
                }
                else {
                    self.registerNewUser()
                    //let next = self.storyboard?.instantiateViewController(withIdentifier: "VerifyOTPVC") as! VerifyOTPVC
                    //self.navigationController?.pushViewController(next, animated: true)
                }
                
            }
            
        }
        else {
            self.showToast(message:Constants.connectivityErrorMsg)
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
