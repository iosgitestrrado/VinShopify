//
//  AppDelegate.swift
//  Vinner
//
//  Created by softnotions on 17/07/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import GoogleMaps
import  Firebase
import FirebaseCore
import FirebaseMessaging
import GooglePlaces

@UIApplicationMain

class AppDelegate:UIViewController, UIApplicationDelegate{
let sharedData = SharedDefault()
let sharedDefault = SharedDefault()

var versionModel: VersionModel?
let gcmMessageIDKey = "gcm.Message_ID"
var window: UIWindow?
var locationManager = CLLocationManager()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       GMSServices.provideAPIKey("AIzaSyBSrAhr4cYrpHT4G6nP8D3d1h8AvCnklsg")
      GMSPlacesClient.provideAPIKey("AIzaSyBSrAhr4cYrpHT4G6nP8D3d1h8AvCnklsg")

       // BTAppSwitch.setReturnURLScheme("com.softnotions.vinner.payments")
        locationManager.requestWhenInUseAuthorization()
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).tintColor = UIColor.black
        // Changes by Praveen
        
//        sharedData.setProfileName(token: "")
//        sharedData.setProfileImageURL(token: "")
//        sharedData.setZipCode(loginStatus: "")
//        sharedData.setCity(loginStatus: "")
//        sharedData.setFlatName(loginStatus: "")
//        sharedData.setRoadName(loginStatus: "")
//        sharedData.setLandMArk(loginStatus: "")
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
        UserDefaults.standard.setValue("No", forKey: "DropdownSelected")
        if (UserDefaults.standard.value(forKey: "access_token") != nil)
        {
            
        }
        else
        {
            UserDefaults.standard.setValue("", forKey: "access_token")

        }
//        UserDefaults.standard.setValue("", forKey: "new_fcm_token")
//        UserDefaults.standard.setValue("", forKey: "fcm_token")


        // Fire Base Oprns
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()

        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        
        var navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.tintColor = UIColor.white
        //navigationBarAppearace.barTintColor = uicolorFromHex(0x034517)
        
        // change navigation item title color
        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        var initialPage = UIViewController()
//        if sharedData.getLoginStatus() == false
//        {
//            var initialPage = UIViewController()
//            initialPage = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//            let navigationController = UINavigationController(rootViewController: initialPage)
//            self.window?.rootViewController = navigationController
//            self.window?.makeKeyAndVisible()
//
//
//
//        }
//        else
//        {
        
        
        UserDefaults.standard.setValue("", forKey: "country_name_Map")

        sharedData.setSelectedCountryNameFromMap(loginStatus: "")

        
        UserDefaults.standard.setValue("0", forKey: "notify_count")

        if (UserDefaults.standard.value(forKey: "country_img") != nil)
        {
            
        }
        else
        {
            sharedData.setCountyImg(token: "uae")

        }
        
        if (UserDefaults.standard.value(forKey: "country_name") != nil)
        {
            
        }
        else
        {
            sharedData.setCountyName(token: "AE")

        }
        
        if (UserDefaults.standard.value(forKey: "country_code") != nil)
        {
            
        }
        else
        {
            sharedData.setCountyCode(token: "+971")

        }
//        self.getVersion()

        
      
        
        var initialPage = UIViewController()

            initialPage = mainStoryboard.instantiateViewController(withIdentifier: "tabbar") as! TabBarController
            let navigationController = UINavigationController(rootViewController: initialPage)
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()

//        }
        
        self.window?.makeKeyAndVisible()
        
        
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        var bgTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
    bgTask = application.beginBackgroundTask(expirationHandler: { application.endBackgroundTask(bgTask)
        bgTask = UIBackgroundTaskIdentifier.invalid })
    }
    
    func getVersion() {
        self.view.activityStartAnimating()
        var postDict = Dictionary<String,String>()
        
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.versionURL//"https://drssystem.co.uk/api/customer/version"
        print("loginURL: ",loginURL)
        AF.request(loginURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
            print("Response:***:",data.description)
            
            switch (data.result) {
            case .failure(let error) :
                self.view.activityStopAnimating()
                let sharedDefault = SharedDefault()
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
                    self.versionModel = VersionModel(response)
                    print("self.versionModel ",self.versionModel!)
                    print("self.versionModel ",self.versionModel?.httpcode!)
                    //print("self.loginResponse ",self.forgotPwdResponse?.forgotPwdData.)
                    print("response ",response)
                    let statusCode = Int((self.versionModel?.httpcode)!)
                    if statusCode == 200{
                        
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            let currentAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                            let serviceAppVersion = self.versionModel?.versionModelData?.version!
                            let iosInitial:String = (self.versionModel?.versionModelData?.iosInitialUpdate!)!
                            print("currentAppVersion === = ",NumberFormatter().number(from: currentAppVersion!)!.doubleValue)
                            print("serviceAppVersion === = ",NumberFormatter().number(from: serviceAppVersion!)!.doubleValue)
                            print("iosInitial === = ",iosInitial)
                            if Int(iosInitial) == 1
                            {
                                if NumberFormatter().number(from: serviceAppVersion!)!.doubleValue <
                                    NumberFormatter().number(from: currentAppVersion!)!.doubleValue {
                                    let sharedDefault = SharedDefault()
                                    var appName = String()
                                    var appMsg = String()
                                    var updateBt = String()
                                                                        
                                    
                                    let alertController = UIAlertController (title: Constants.appName, message: "A new vesion of Vinner is available in App Store. Please update", preferredStyle: .alert)
                                   
                                    
                                    
                                    alertController.addAction(UIAlertAction(title: updateBt, style: .default, handler: { action in
                                        if let url = URL(string: "https://apps.apple.com/us/app/id1534567568") {
                                            UIApplication.shared.open(url)
                                        }
                                    }))
                                    
                                    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                                    alertWindow.rootViewController = UIViewController()
                                    alertWindow.windowLevel = UIWindow.Level.alert + 1;
                                    alertWindow.makeKeyAndVisible()
                                    alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
                                    
                                    
                                    
                                }
                                else
                                {
                                    print("alertWindow")
                                }
                            
                            }
                    
                        }
                        
                    }
                    if statusCode == 400{
                       self.view.activityStopAnimating()
                       //self.showAlert(title: Constants.appName, message: (self.versionModel?.message)!)

                        
                    }
                    
                    self.view.activityStopAnimating()
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)

        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
          print("Message ID: \(messageID)")
        }

        // Print full message.
        print(userInfo)

        completionHandler(UIBackgroundFetchResult.newData)
      }
}

extension AppDelegate : MessagingDelegate
{
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken)")
        sharedDefault.setNewFcmToken(token: fcmToken!)
          let userdefaults = UserDefaults.standard
          if let savedValue = userdefaults.string(forKey: "fcm_token")
          {
             print("savedValue fcm_token ----- ",savedValue)
          } else {
            sharedDefault.setFcmToken(token: fcmToken!)
          }
          
        UserDefaults.standard.setValue(fcmToken, forKey: "FCMToken")
        
        let dataDict:[String: String] = ["token": String(fcmToken ?? "")]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
      }
}
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
      withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      let userInfo = notification.request.content.userInfo

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)

      // Change this to your preferred presentation option
      completionHandler([[.alert, .sound]])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
      let userInfo = response.notification.request.content.userInfo
      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey]
      {
        print("Message ID: \(messageID)")
      }

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print full message.
      print(userInfo)

      completionHandler()
    }
  }
extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}
