//
//  SharedDefault.swift
//  iDesigner
//
//  Created by Softnotions Technologies Pvt Ltd on 2/19/20.
//  Copyright © 2020 Softnotions Technologies Pvt Ltd. All rights reserved.
//

import UIKit

class SharedDefault: UIViewController {
   
    func setAddressID(loginStatus:String)
    {
        UserDefaults.standard.set(loginStatus, forKey: "AddressID")
        UserDefaults.standard.synchronize()
    }
   
    func getAddressID() -> String {
        return UserDefaults.standard.string(forKey: "AddressID")!
    }
    func setAddress(loginStatus:String)
     {
         UserDefaults.standard.set(loginStatus, forKey: "Address")
         UserDefaults.standard.synchronize()
     }
    
    
     func getAddress() -> String {
         return UserDefaults.standard.string(forKey: "Address")!
     }
    
    func setAppName(loginStatus:String)
    {
        UserDefaults.standard.set(loginStatus, forKey: "AppName")
        UserDefaults.standard.synchronize()
    }
    func getAppName() -> String {
        return UserDefaults.standard.string(forKey: "AppName")!
    }
    func setLanguage(language:Int)
    {
        UserDefaults.standard.set(language, forKey: "Language")
        UserDefaults.standard.synchronize()
    }
    
    func getLanguage()-> Int
    {
        return UserDefaults.standard.integer(forKey: "Language")
        
    }
    
    func setLoginStatus(loginStatus:Bool)
    {
        UserDefaults.standard.set(loginStatus, forKey: "LoginStatus")
        UserDefaults.standard.synchronize()
    }
    
    func getLoginStatus() -> Bool {
        return UserDefaults.standard.bool(forKey: "LoginStatus")
    }
    
    func setPhoneNumber(loginStatus:String)
    {
        UserDefaults.standard.set(loginStatus, forKey: "PhoneNumber")
        UserDefaults.standard.synchronize()
    }
    func getPhoneNumber()-> Any
    {
        return UserDefaults.standard.value(forKey: "PhoneNumber")!
        
    }
    
    func setAccessToken(token:String)
    {
        UserDefaults.standard.set(token, forKey: "access_token")
        UserDefaults.standard.synchronize()
    }
    func getAccessToken()-> String
    {
        return UserDefaults.standard.value(forKey: "access_token")! as! String
        
    }
    func setUserEmail(token:String)
    {
        UserDefaults.standard.set(token, forKey: "email")
        UserDefaults.standard.synchronize()
    }
    func getUserEmail()-> String
    {
        return UserDefaults.standard.value(forKey: "email")! as! String
        
    }
    func clearAccessToken()
    {
        UserDefaults.standard.removeObject(forKey: "access_token")
        UserDefaults.standard.synchronize()
    }
    
    
    func setProfileImageURL(token:String)
    {
        UserDefaults.standard.set(token, forKey: "profile_image")
        UserDefaults.standard.synchronize()
    }
    func getProfileImageURL()-> String
    {
        return UserDefaults.standard.value(forKey: "profile_image")! as! String
        
    }
    
    func setProfileName(token:String)
    {
        UserDefaults.standard.set(token, forKey: "profile_name")
        UserDefaults.standard.synchronize()
    }
    func getProfileName()-> String
    {
        return UserDefaults.standard.value(forKey: "profile_name")! as! String
        
    }
    
    func setCountyCode(token:String)
    {
        UserDefaults.standard.set(token, forKey: "country_code")
        UserDefaults.standard.synchronize()
    }
    func getCountyCode()-> String
    {
        return UserDefaults.standard.value(forKey: "country_code")! as! String
        
    }
    
    func setCountyImg(token:String)
    {
        UserDefaults.standard.set(token, forKey: "country_img")
        UserDefaults.standard.synchronize()
    }
    func getCountyImg()-> String
    {
        return UserDefaults.standard.value(forKey: "country_img")! as! String
        
    }
    
    
    
    func setCountyName(token:String)
    {
        UserDefaults.standard.set(token, forKey: "country_name")
        UserDefaults.standard.synchronize()
    }
    func getCountyName()-> String
    {
        return UserDefaults.standard.value(forKey: "country_name")! as! String
        
    }
    
    func setOperatorName(token:String)
    {
        UserDefaults.standard.set(token, forKey: "operator_name")
        UserDefaults.standard.synchronize()
    }
    func getOperatorName()-> String
    {
        return UserDefaults.standard.value(forKey: "operator_name")! as! String
        
    }
    func setOperatorID(token:String)
    {
        UserDefaults.standard.set(token, forKey: "operator_id")
        UserDefaults.standard.synchronize()
    }
    func getOperatorID()-> String
    {
        return UserDefaults.standard.value(forKey: "operator_id")! as! String
        
    }
    
    func clearOperatorID()
    {
        UserDefaults.standard.removeObject(forKey: "operator_id")
        UserDefaults.standard.synchronize()
    }
    func clearOperatorName()
    {
        UserDefaults.standard.removeObject(forKey: "operator_name")
        UserDefaults.standard.synchronize()
    }
    
    
    func setZipCode(loginStatus:String)
    {
        UserDefaults.standard.set(loginStatus, forKey: "ZipCode")
        UserDefaults.standard.synchronize()
    }
    
    func getSelectedCountryNameFromMap() -> String {
        return UserDefaults.standard.string(forKey: "country_name_Map")!
    }
    
    
    func setSelectedCountryNameFromMap(loginStatus:String)
    {
        UserDefaults.standard.set(loginStatus, forKey: "country_name_Map")
        UserDefaults.standard.synchronize()
    }
    
    
    func setCity(loginStatus:String)
    {
        UserDefaults.standard.set(loginStatus, forKey: "City")
        UserDefaults.standard.synchronize()
    }
    func getCity() -> String {
        return UserDefaults.standard.string(forKey: "City")!
    }
    func getZipCode() -> String {
        return UserDefaults.standard.string(forKey: "ZipCode")!
    }
    
    func setFlatName(loginStatus:String)
    {
        UserDefaults.standard.set(loginStatus, forKey: "FlatName")
        UserDefaults.standard.synchronize()
    }
    func setRoadName(loginStatus:String)
    {
        UserDefaults.standard.set(loginStatus, forKey: "RoadName")
        UserDefaults.standard.synchronize()
    }
    func getRoadName() -> String {
        return UserDefaults.standard.string(forKey: "RoadName")!
    }
    
    func setLandMArk(loginStatus:String)
    {
        UserDefaults.standard.set(loginStatus, forKey: "LandMark")
        UserDefaults.standard.synchronize()
    }
    func getLandMark() -> String {
        return UserDefaults.standard.string(forKey: "LandMark")!
    }
    func getFlatName() -> String {
        return UserDefaults.standard.string(forKey: "FlatName")!
    }
    func setNewFcmToken(token:String)
    {
        UserDefaults.standard.set(token, forKey: "new_fcm_token")
        UserDefaults.standard.synchronize()
    }
    func getNewFcmToken()-> String
    {
        return UserDefaults.standard.value(forKey: "new_fcm_token")! as! String
        
    }
    func clearFcmToken()
       {
           UserDefaults.standard.removeObject(forKey: "fcm_token")
           UserDefaults.standard.synchronize()
       }
    func setFcmToken(token:String)
       {
           UserDefaults.standard.set(token, forKey: "fcm_token")
           UserDefaults.standard.synchronize()
       }
       func getFcmToken()-> String
       {
           return UserDefaults.standard.value(forKey: "fcm_token")! as! String
           
       }
}
