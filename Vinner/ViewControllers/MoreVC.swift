//
//  MoreVC.swift
//  Vinner
//
//  Created by softnotions on 21/07/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import SDWebImage
import MobileCoreServices
import Alamofire
import SwiftyJSON
import ImageSlideshow
import FBSDKShareKit
import BraintreeDropIn
import Braintree

class MoreVC: UIViewController,UITableViewDataSource,UITableViewDelegate,SharingDelegate {
    var addAddressModel: AddAddressModel?
    
    @IBOutlet weak var lblProfileName: UILabel!
    @IBOutlet weak var imgProfile: SDAnimatedImageView!
     @IBOutlet weak var tableSetting: UITableView!
    let settingsName = ["Update Profile","My Orders","My Delivery Address","Track Order","Terms and Conditions","Share Vinner App","Logout"]
//    let settingsName = ["Update Profile","My Orders","My Delivery Address","Terms and Conditions","Share Vinner App","Logout"]
    //,"FAQ"
    var settingsImg = [UIImage]()
    let sharedData = SharedDefault()
    
    
    
    override func viewDidAppear(_ animated: Bool)
    {


        if !sharedData.getLoginStatus()
        {

            let alert = UIAlertController(title: Constants.appName, message: Constants.MoreMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            
            let next = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController

            self.navigationController?.pushViewController(next, animated: true)
           
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            print("Cancel")
            
            guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabbar") as? TabBarController else {
                                                return
                                            }
                                            let navigationController = UINavigationController(rootViewController: rootVC)

                                            UIApplication.shared.windows.first?.rootViewController = navigationController
                                            UIApplication.shared.windows.first?.makeKeyAndVisible()
            
       

        }))
        self.present(alert, animated: true, completion: nil)
        
    }
        else
        {
//        if (self.loadImageFromDiskWith(fileName: "ProfileImage") != nil)
//        {
//            self.imgProfile.image = self.loadImageFromDiskWith(fileName: "ProfileImage")
//        }
            
            if (self.loadImageFromDiskWith(fileName: "ProfileImage_\(sharedData.getProfileName())") != nil)
            {
                self.imgProfile.image = self.loadImageFromDiskWith(fileName: "ProfileImage_\(sharedData.getProfileName())")
            }
        else
        {
        if sharedData.getProfileImageURL().count == 0 || sharedData.getProfileImageURL() == nil || sharedData.getProfileImageURL() == ""
        {
            self.imgProfile.sd_setImage(with: URL(string:"https://vinshopify.com/uat/uploads/user_image/default.png"), placeholderImage: UIImage(named: "Transparent"))

        }
        else
        {
            self.imgProfile.sd_setImage(with: URL(string: sharedData.getProfileImageURL()), placeholderImage: UIImage(named: "Transparent"))

        }
        }

        }
        self.lblProfileName.text = sharedData.getProfileName()

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
//        self.addCustControls()
        self.navigationController?.navigationBar.topItem?.title = ""
        topBool = false
        // Do any additional setup after loading the view.
        imgProfile.layer.cornerRadius = imgProfile.frame.size.height/2
        
        settingsImg.append(UIImage(named: "Profile")!)
        settingsImg.append(UIImage(named: "MyOrder")!)
        settingsImg.append(UIImage(named: "Delivery")!)
        settingsImg.append(UIImage(named: "Track")!)
        settingsImg.append(UIImage(named: "Terms")!)
        //settingsImg.append(UIImage(named: "faq")!)
        settingsImg.append(UIImage(named: "ShareW")!)
        settingsImg.append(UIImage(named: "logout")!)
        
        self.tableSetting.rowHeight = 50.0
        tableSetting.tableFooterView = UIView()
        
      
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
    }
    // MARK: - tableview delegate
    
    var tableViewHeight: CGFloat {
        tableSetting.layoutIfNeeded()
        
        return tableSetting.contentSize.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if tableView == tableSetting {
            let settingsTCell = tableSetting.dequeueReusableCell(withIdentifier: "SettingsTCell", for: indexPath) as! SettingsTCell
            settingsTCell.lblTitle.text = settingsName[indexPath.row]
            settingsTCell.imgContent.image = settingsImg[indexPath.row]
            settingsTCell.selectionStyle = .none
            cell = settingsTCell
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if !sharedData.getLoginStatus()
        {

            let alert = UIAlertController(title: Constants.appName, message: Constants.MoreMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            
            let next = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController

            self.navigationController?.pushViewController(next, animated: true)
           
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            print("Cancel")
            guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabbar") as? TabBarController else {
                                                return
                                            }
                                            let navigationController = UINavigationController(rootViewController: rootVC)

                                            UIApplication.shared.windows.first?.rootViewController = navigationController
                                            UIApplication.shared.windows.first?.makeKeyAndVisible()
            
       

        }))
        self.present(alert, animated: true, completion: nil)
        
    }
        else
        {
        
        if indexPath.row == 0 {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as? EditProfileVC
            let backItem = UIBarButtonItem()
               backItem.title = "Edit Profile"
               navigationItem.backBarButtonItem = backItem
            self.navigationController?.pushViewController(next!, animated: true)
        }
        else if indexPath.row == 1
        {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "MyOrderVC") as? MyOrderVC
            next!.bFromCheckoutPage = false

//            let backItem = UIBarButtonItem()
//            backItem.title = "Your Orders"
//            navigationItem.backBarButtonItem = backItem
            self.navigationController?.pushViewController(next!, animated: true)
        }
        else if indexPath.row == 2 {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "AddressListVC") as! AddressListVC
            next.sAddresData = "My Delivery Address"
            next.sProductCurrency = ""
            next.sEditAdreessFromBag = false
            self.navigationController?.pushViewController(next, animated: true)
            
        }
            
        else if indexPath.row == 3 {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "TrackOrderVC") as? TrackOrderVC
            self.navigationController?.pushViewController(next!, animated: true)
        }
            
        else if indexPath.row == 4 {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "TermsConditionsVC") as? TermsConditionsVC
            self.navigationController?.pushViewController(next!, animated: true)
        }
            /*
        else if indexPath.row == 5 {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "FAQVC") as? FAQVC
            self.navigationController?.pushViewController(next!, animated: true)
        }
        */
        else if indexPath.row == 5
        {
            
            
            print("DasSasaSass")
            let alert = UIAlertController(title: "Share", message: "", preferredStyle: .actionSheet)
            
//            alert.addAction(UIAlertAction(title: "Facebook", style: .default, handler: { action in
//
//                self.shareTextOnFaceBook(sText: "https://apps.apple.com/in/app/whatsapp-messenger/id310633997")
//            }))
            
//            alert.addAction(UIAlertAction(title: "WhatsApp", style: .default, handler: { action in
//
//                self.shareOnWhatsApp()
//            }))
            alert.addAction(UIAlertAction(title: "Share Vinner App", style: .default, handler: { action in
                
                self.ShareTextOnOtherApps(sText: "")
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            
            
          
            
            
            self.present(alert, animated: true)
        
        }
        else if indexPath.row == 6 {
            
            let alert = UIAlertController(title: Constants.appName, message: Constants.logoutMSG, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { _ in
                //Yes Action
                
                self.LogoutApp()
               
            }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
                print("NO")
            }))
            self.present(alert, animated: true, completion: nil)
            
            
            
        }
            
        }
        
    }
    
    
    func shareOnWhatsApp() {
        
        let urlString = "whatsapp://send?text=" + "https://apps.apple.com/in/app/vinshopify/id1534567568"
        print("urlString ",urlString)
        
        print("urlString ",urlString)
        
        if let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            if let whatsappURL = NSURL(string: urlString)
            {
                if UIApplication.shared.canOpenURL(whatsappURL as URL)
                {
                    if #available(iOS 10.0, *)
                    {
                        UIApplication.shared.open(whatsappURL as URL, options: [:], completionHandler: nil)
                    }
                    else
                    {
                        UIApplication.shared.openURL(whatsappURL as URL)
                    }
                    
                }
                else
                {
                  print("Cannot open whatsapp")
                  self.showToast(message: "Whatsapp not installed")
                    
                }
            }
        }
        
    }
    func ShareTextOnOtherApps(sText:String)
    {
        let text = "https://apps.apple.com/in/app/vinshopify/id1534567568"
        let textShare = [ text ]
            let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
//        [activityViewController.view setTintColor:[UIColor blueColor]];
        activityViewController.navigationController?.navigationBar.tintColor = UIColor.black
        activityViewController.navigationController?.navigationItem.rightBarButtonItem?.tintColor = UIColor.black

        UIButton.appearance().tintColor = .blue
//            self.present(activityViewController, animated: true, completion: nil)
        self.present(activityViewController, animated: true, completion: {
                    DispatchQueue.main.async {
                        UIButton.appearance().tintColor = .black
                    }
                })
    }
    
    func shareTextOnFaceBook(sText: String)
    {
        
        let shareContent = ShareLinkContent()
        shareContent.quote = sText
        ShareDialog(fromViewController: self, content: shareContent, delegate: self).show()
    }
    
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
        if sharer.shareContent.pageID != nil {
            print("Share: Success")
        }
    }
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        print("Share: Fail")
        self.showToast(message: "Facebook not installed")

    }
    func sharerDidCancel(_ sharer: Sharing) {
        print("Share: Cancel")
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsName.count
    }
    
    func LogoutApp(){
        self.view.activityStartAnimating()
        var postDict = Dictionary<String,String>()
        postDict = [
            "access_token":sharedData.getAccessToken()
        ]
  
        let loginURL = Constants.baseURL+Constants.signOutURL
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
                  if statusCode == 200{
                      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
                      {
//                            self.showToast(message: (self.addAddressModel?.message)!)
                          self.sharedData.clearAccessToken()
                          
                          
                          
                          self.sharedData.clearOperatorName()
                          self.sharedData.clearOperatorID()
                          self.sharedData.clearFcmToken()
//                            let domain = Bundle.main.bundleIdentifier!
//                            UserDefaults.standard.removePersistentDomain(forName: domain)
//                            UserDefaults.standard.synchronize()
//                            print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
                          self.sharedData.setLoginStatus(loginStatus: false)
                          
//                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                            appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
//                            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                            let yourVC = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//                            let navigationController = UINavigationController(rootViewController: yourVC)
//                            appDelegate.window?.rootViewController = navigationController
//                            appDelegate.window?.makeKeyAndVisible()
//                            self.navigationController?.popToRootViewController(animated: true)
                          
                          UserDefaults.standard.setValue("", forKey: "access_token")
                          UserDefaults.standard.setValue("", forKey: "Address")
                          UserDefaults.standard.setValue("", forKey: "CartCleared")
                          UserDefaults.standard.setValue("", forKey: "profile_name")
                          UserDefaults.standard.setValue("", forKey: "profile_name")
                          UserDefaults.standard.setValue("", forKey: "LandMark")
                          UserDefaults.standard.setValue("", forKey: "profile_image")
                          UserDefaults.standard.setValue("", forKey: "ZipCode")
                          UserDefaults.standard.setValue("", forKey: "City")
                          UserDefaults.standard.setValue("", forKey: "FlatName")
                          UserDefaults.standard.setValue("", forKey: "RoadName")
                          UserDefaults.standard.setValue("", forKey: "cartCount")
                          
                          self.sharedData.setCountyName(token: "AE")
                          self.sharedData.setCountyImg(token: "uae")
                          self.sharedData.setCountyCode(token: "+971")
                          
                    
//
                          
                          
//                            guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as? ViewController else {
//                                                                return
//                                                            }
//                                                            let navigationController = UINavigationController(rootViewController: rootVC)
//
//                                                            UIApplication.shared.windows.first?.rootViewController = navigationController
//                                                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                          
                          
                          
                          
                          
                          guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabbar") as? TabBarController else {
                                                              return
                                                          }
                                                          let navigationController = UINavigationController(rootViewController: rootVC)

                                                          UIApplication.shared.windows.first?.rootViewController = navigationController
                                                          UIApplication.shared.windows.first?.makeKeyAndVisible()

                          
                          self.view.activityStopAnimating()
                      }
                  }
                    if statusCode == 400
                    {
                      
                      // changes by Praveen
                      self.sharedData.clearAccessToken()
                      self.sharedData.clearOperatorName()
                      self.sharedData.clearOperatorID()
                      
//                        let domain = Bundle.main.bundleIdentifier!
//                        UserDefaults.standard.removePersistentDomain(forName: domain)
//                        UserDefaults.standard.synchronize()
//                        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
                      self.sharedData.setLoginStatus(loginStatus: false)
                      
//                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
//                        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                        let yourVC = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//                        let navigationController = UINavigationController(rootViewController: yourVC)
//
//                        appDelegate.window?.rootViewController = navigationController
//                        appDelegate.window?.makeKeyAndVisible()
//
//                        self.navigationController?.popToRootViewController(animated: true)
                      
                      UserDefaults.standard.setValue("", forKey: "access_token")
                      UserDefaults.standard.setValue("", forKey: "Address")
                      UserDefaults.standard.setValue("", forKey: "CartCleared")
                      UserDefaults.standard.setValue("", forKey: "profile_name")
                      UserDefaults.standard.setValue("", forKey: "profile_name")
                      UserDefaults.standard.setValue("", forKey: "LandMark")
                      UserDefaults.standard.setValue("", forKey: "profile_image")
                      UserDefaults.standard.setValue("", forKey: "ZipCode")
                      UserDefaults.standard.setValue("", forKey: "City")
                      UserDefaults.standard.setValue("", forKey: "FlatName")
                      UserDefaults.standard.setValue("", forKey: "RoadName")
                      UserDefaults.standard.setValue("", forKey: "cartCount")
                      
                      self.sharedData.setCountyName(token: "AE")
                      self.sharedData.setCountyImg(token: "uae")
                      self.sharedData.setCountyCode(token: "+971")
                      
                      guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabbar") as? TabBarController else {
                                                          return
                                                      }
                                                      let navigationController = UINavigationController(rootViewController: rootVC)

                                                      UIApplication.shared.windows.first?.rootViewController = navigationController
                                                      UIApplication.shared.windows.first?.makeKeyAndVisible()

                      
                      
                      
                      // changes by praveen
                      
                      self.view.activityStopAnimating()
//                          self.showToast(message: (self.addAddressModel?.message)!)
                    }
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
   /* // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func loadImageFromDiskWith(fileName: String) -> UIImage? {
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image

        }

        return nil
    }

}
extension UIActivityViewController {

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UINavigationBar.appearance().barTintColor = .black
    }
        
    open override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.isOpaque = false
        navigationController?.navigationBar.barTintColor = UIColor(red: (247/255), green: (247/255), blue: (247/255), alpha: 1)
        //navigationBar.tintColor = UIColor.white
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        UINavigationBar.appearance().barTintColor = .black
    }

}
