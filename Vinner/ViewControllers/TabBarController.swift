//
//  TabBarController.swift
//  Vinner
//
//  Created by softnotions on 21/07/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TabBarController: UITabBarController {
    let gradientlayer = CAGradientLayer()
    var dropTextField = UITextField()
    let sharedData = SharedDefault()
    var homeResponseModel: HomeResponseModel?

    override func viewWillAppear(_ animated: Bool) {
        print("UITabBarController")
        self.setGradientBackground(colorOne:UIColor(red: 40.0/255.0, green: 49.0/255.0, blue: 110.0/255.0, alpha: 1.0) , colorTwo: UIColor(red: 21.0/255.0, green: 105.0/255.0, blue: 177.0/255.0, alpha: 1.0))
          //UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
          //UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
         if #available(iOS 13, *) {
             let appearance = UITabBarAppearance()
             appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
             tabBar.standardAppearance = appearance
         } else {
             //UITabBarItem.appearance().setTitleTextAttributes(UIColor.white, for: UIControl.State.selected)
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
         }
          self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "NavBG"), for: UIBarMetrics.default)
          self.navigationItem .setHidesBackButton(true, animated: false)
          /*
          dropTextField =  UITextField(frame: CGRect(x: self.view.frame.size.width-275, y: 5, width: 180, height: 30))
          
          dropTextField.placeholder = "Select Region"
          dropTextField.font = UIFont.systemFont(ofSize: 15)
          dropTextField.borderStyle = UITextField.BorderStyle.roundedRect
          dropTextField.autocorrectionType = UITextAutocorrectionType.no
          dropTextField.keyboardType = UIKeyboardType.default
          dropTextField.returnKeyType = UIReturnKeyType.done
          dropTextField.clearButtonMode = UITextField.ViewMode.whileEditing
          dropTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
          self.navigationController?.navigationBar .addSubview(dropTextField)
          dropTextField.layer.cornerRadius = 15
          let viewImg = UIView(frame: CGRect(x: 0, y: dropTextField.frame.size.height/2, width: 10, height: 10))
          dropTextField.rightViewMode = UITextField.ViewMode.always
          let imageView = UIImageView(frame: CGRect(x: -5, y: 0, width: 10, height: 10))
          let image = UIImage(named: "DownArrow")
          imageView.image = image
          viewImg.addSubview(imageView)
          dropTextField.rightView = viewImg
        */
          //self.addTextfield()
        
        self.getHomeContent()
        
        let logoImage = UIImage.init(named: "Logon")
         let logoImageView = UIImageView.init(image: logoImage)
         logoImageView.frame = CGRect(x: 0, y: 0, width: 80, height: 45)
        // logoImageView.frame = CGRectMake(-40, 0, 150, 25)
         logoImageView.contentMode = .scaleToFill
         let imageItem = UIBarButtonItem.init(customView: logoImageView)
         //let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        // negativeSpacer.width = -25
          navigationItem.leftBarButtonItems = [ imageItem]


//        navigationItem.leftBarButtonItems = [negativeSpacer, imageItem]
        //self.addLeftNavigationImage()

    }
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1)
                                {
        
        self.setGradientBackground(colorOne:UIColor(red: 40.0/255.0, green: 49.0/255.0, blue: 110.0/255.0, alpha: 1.0) , colorTwo: UIColor(red: 21.0/255.0, green: 105.0/255.0, blue: 177.0/255.0, alpha: 1.0))

                                }
         
        
        
        
    }
   
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor)  {
        gradientlayer.frame = tabBar.bounds
        gradientlayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientlayer.locations = [0, 1]
        gradientlayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientlayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        self.tabBar.layer.insertSublayer(gradientlayer, at: 0)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func getHomeContent(){
        var postDict = Dictionary<String,String>()
        
        let saccessToken = UserDefaults.standard.value(forKey: "access_token") as! String
        
        if saccessToken.count>0
        {
            postDict = [
              "access_token":sharedData.getAccessToken(),
              "country_code":sharedData.getCountyName()

            ]
        }
        else
        {
            postDict = [
              "country_code":sharedData.getCountyName()

            ]

        }
       
    
        print(postDict)
        let loginURL = Constants.baseURL+Constants.homeURL
        print("loginURL",loginURL)
        
        AF.request(loginURL, method: .post, parameters: postDict, encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
            print("Response:***:",data.description)
            
            switch (data.result) {
            case .failure(let error) :
                
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
                    self.homeResponseModel = HomeResponseModel(response)
                    let statusCode = Int((self.homeResponseModel?.httpcode)!)
                    if statusCode == 200
                    {

//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
//                        {

                           
                        let sNotificationCount = String((self.homeResponseModel?.homeData?.notify_count)!)
                        let spush_count = String((self.homeResponseModel?.homeData?.push_count)!)

                        UserDefaults.standard.setValue(sNotificationCount, forKey: "notify_count")

                        self.addCustControls()

                            
                        

                    }
                  
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
  
}
