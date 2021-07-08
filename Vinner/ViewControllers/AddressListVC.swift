//
//  AddressListVC.swift
//  Vinner
//
//  Created by softnotions on 01/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire
import SwiftyJSON

class AddressListVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
let userdefaults = UserDefaults.standard
    var addressStatus: Bool = false
    var selectedAddressID:Int? = 0
     var tempAddressID:Int? = 0
    var sSearchText:String? = ""
    var addressListModel: AddressListModel?
    let sharedDefault = SharedDefault()
    var addressList = [AddressListData]()
    var profileUpRespModel: ProfileUpRespModel?
    var sAddresData: String?
    var sProductCurrency: String?
    var sSelectedAddressType: String?
    var sCountry:  String?
    var sSelectedFlatNo: String?
    var sSelectedRoadName: String?
    var sSelectedLandMark: String?
    var sSelectedZipCode: String?
    var sSelectedCity: String?
    var sEditAdreessFromBag: Bool = false

   
    
    
    @IBOutlet weak var btnAddAddress: UIButton!
    @IBOutlet weak var tableAddressList: UITableView!
    @IBOutlet weak var viewAddAddress: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var lblYourAddress: UILabel!
    override func viewWillAppear(_ animated: Bool)
    {
        self.addressList.removeAll()
        self.getAddressList()
        self.addBackButton(title: sAddresData!)

        self.navigationController?.navigationBar.topItem?.title = ""

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.navigationController?.navigationBar.topItem?.title = "My Delivery Address"
        viewAddAddress.layer.cornerRadius = 5
        viewAddAddress.layer.borderColor = Constants.borderColor.cgColor
        viewAddAddress.layer.borderWidth = 1
        self.lblYourAddress.text = sAddresData
        
        self.searchBar.delegate = self
         self.searchBar.showsCancelButton = true
        self.searchBar.layer.cornerRadius = self.searchBar.frame.size.height/2
        self.searchBar.barTintColor = UIColor.lightGray
        self.searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        self.searchBar.backgroundColor  = .white
        self.searchBar.alwaysShowCancelButton()
        
        if let textfield = self.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
            textfield.layer.cornerRadius  = textfield.frame.size.height/2
        }
        
        self.tableAddressList.tableFooterView = UIView()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        print("Search bar",searchBar.text!)
        if self.searchBar.text!.count>0
        {
            sSearchText = searchBar.text
            addressList.removeAll()
            self.getSearchedAddressList()
            tableAddressList.reloadData()
            
        }
        else
        {
            self.showToast(message: "Enter the content to search")
        }
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
      searchBar.text = ""
        sSearchText = ""

       searchBar.resignFirstResponder()
        
        
        
        if searchBar.text?.count == 0
        {
            self.navigationController?.popViewController(animated: true)
        }
        else
        {
            addressList.removeAll()
            self.getSearchedAddressList()
            searchBar.alwaysShowCancelButton()

            
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1)
            {
                self.sSearchText = searchBar.text
                self.addressList.removeAll()
                self.getSearchedAddressList()
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if tableView == tableAddressList {
            let cellNotify = tableAddressList.dequeueReusableCell(withIdentifier: "AddressListTCell", for: indexPath) as! AddressListTCell
           
            //self.btnCheck.setBackgroundImage(UIImage(named:"checked"), for: .normal)
            //self.btnCheck.setBackgroundImage(UIImage(named:"unchecked"), for: .normal)
            
           
            cellNotify.btnSelect.tag = indexPath.section
            
            
            
            cellNotify.lblAddrType.text = self.addressList[indexPath.section].addressType
          
            var tempID = "0"
            if let savedValue = userdefaults.string(forKey: "AddressID"){
                tempID = savedValue
            }
            
            if Int(tempID) == Int(self.addressList[indexPath.section].adrsId!)
            {
//               cellNotify.btnSelect.setBackgroundImage(UIImage(named:"checked"), for: .normal)
                
                
                let sName = (self.addressList[indexPath.section].name)! as String
                sCountry = (self.addressList[indexPath.section].country)!  as String
                sSelectedAddressType = self.addressList[indexPath.section].addressType
                sSelectedFlatNo = self.addressList[indexPath.section].address1
                sSelectedRoadName = self.addressList[indexPath.section].roadName
                sSelectedLandMark = self.addressList[indexPath.section].landmark
                sSelectedCity = self.addressList[indexPath.section].city
                sSelectedZipCode = self.addressList[indexPath.section].zip

                let sDefoult = (self.addressList[indexPath.section].defaultField)! as String

                
                if  sCountry == "Saudi Arabia"
                {
                    sCountry = "SA"
                }
                 else if sCountry == "Bahrain"
                 {
                    sCountry = "BH"

                 }
                else if sCountry == "United Arab Emirates"
                {
                    sCountry = "AE"

                }

                
        //        let sAddress = sSelectedAddressType! + "," + sSelectedFlatNo! + "," + sSelectedRoadName! + "," +  sSelectedLandMark! + "," + sSelectedCity! + "," + sSelectedZipCode!
                let sAddress =    sName + "," + sSelectedAddressType! + "," + sSelectedFlatNo! + "," + sSelectedRoadName! + "," + sSelectedCity! + "," + sSelectedLandMark! + "," + sCountry! + ","  +  sSelectedZipCode! + ","  +  sDefoult
                
                self.sharedDefault.setAddress(loginStatus: sAddress)
           }
           else
            {
//               cellNotify.btnSelect.setBackgroundImage(UIImage(named:"unchecked"), for: .normal)
           }
            cellNotify.lblHouseName.text =  self.addressList[indexPath.section].name!  + "," + self.addressList[indexPath.section].address1! + "," + self.addressList[indexPath.section].roadName! + ","  + self.addressList[indexPath.section].city! + "," + self.addressList[indexPath.section].landmark! + "," + self.addressList[indexPath.section].country!

            //bagTableCell.btnAdd .addTarget(self, action: #selector(btnEditAddrAction), for: .touchUpInside)
            cellNotify.btnDelete.layer.cornerRadius = 5
            cellNotify.btnEdit.layer.cornerRadius = 5
             cellNotify.btnSelect.addTarget(self, action: #selector(btnSelectAction), for: .touchUpInside)
            
            cellNotify.btnDelete.addTarget(self, action: #selector(btnDelAddAction), for: .touchUpInside)
            cellNotify.btnEdit.addTarget(self, action: #selector(btnEditAddrAction), for: .touchUpInside)
            cellNotify.lblAddress.text = self.addressList[indexPath.section].zip!
            
            if self.addressList[indexPath.section].defaultField == "1"
            {
                cellNotify.imgDefault.isHidden = false
                cellNotify.btnSelect.setBackgroundImage(UIImage(named:"checked"), for: .normal)

            }
            else
            {
                 cellNotify.imgDefault.isHidden = true
                cellNotify.btnSelect.setBackgroundImage(UIImage(named:"unchecked"), for: .normal)

            }
            
            cellNotify.btnEdit.tag = indexPath.section
            cellNotify.btnDelete.tag = indexPath.section
            cellNotify.layer.borderWidth = 1
            cellNotify.layer.borderColor = Constants.borderColor.cgColor
            cellNotify.layer.cornerRadius = 5
            cellNotify.clipsToBounds = true
            cellNotify.selectionStyle = .none
            cell = cellNotify
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("tableNotification ",indexPath.row)
        print("tableNotification section ",indexPath.section)
 
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
      
        let indexPath = IndexPath(row: indexPath.row, section: 0)
        let cell:AddressListTCell = tableAddressList.cellForRow(at: indexPath) as! AddressListTCell
     
    }
    
      func numberOfSections(in tableView: UITableView) -> Int {
        return self.addressList.count
      }

      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return 1
      }
      
      func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))

        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = ""
        //label.font = UIFont().futuraPTMediumFont(16) // my custom font
        //label.textColor = UIColor.charcolBlackColour() // my custom colour

        headerView.addSubview(label)

        return headerView
    }
      func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
          return 20
      }
    @IBAction func btnSelectAction(_ sender: UIButton)
    {
        
//        print(sender.tag)
//        let indexPath = IndexPath(row: 0, section: sender.tag)
//        selectedAddressID = Int(self.addressList[indexPath.section].adrsId!)!
//        let sName = (self.addressList[indexPath.section].name)! as String
//        var sCountry = (self.addressList[indexPath.section].country)!  as String
//        sSelectedAddressType = self.addressList[indexPath.section].addressType
//        sSelectedFlatNo = self.addressList[indexPath.section].address1
//        sSelectedRoadName = self.addressList[indexPath.section].roadName
//        sSelectedLandMark = self.addressList[indexPath.section].landmark
//        sSelectedCity = self.addressList[indexPath.section].city
//        sSelectedZipCode = self.addressList[indexPath.section].zip
//        let sDefoult = (self.addressList[indexPath.section].defaultField)! as String
//        if  sCountry == "Saudi Arabia"
//        {
//            sCountry = "SA"
//        }
//         else if sCountry == "Bahrain"
//         {
//            sCountry = "BH"
//
//         }
//        else if sCountry == "United Arab Emirates"
//        {
//            sCountry = "AE"
//
//        }
//
//        let sAddress =    sName + "," + sSelectedAddressType! + "," + sSelectedFlatNo! + "," + sSelectedRoadName! + "," + sSelectedCity! + "," + sSelectedLandMark! + "," + sCountry + ","  +  sSelectedZipCode! + ","  +  sDefoult
//        tableAddressList.reloadData()
//        tempAddressID = selectedAddressID
        
        // Change on 11-12-2020 by Praveen
        print(sender.tag)
        let indexPath = IndexPath(row: 0, section: sender.tag)
        let cell:AddressListTCell = tableAddressList.cellForRow(at: indexPath) as! AddressListTCell
        selectedAddressID = Int(self.addressList[indexPath.section].adrsId!)!
        print("selectedAddressID", selectedAddressID)
        print("tempAddressID", tempAddressID)
        let addrID = selectedAddressID
        sharedDefault.setAddressID(loginStatus: String(addrID!))
        tableAddressList.reloadData()
        tempAddressID = selectedAddressID
       
    }
    
    @objc func btnEditAddrAction(sender: UIButton!)
    {
        print("btnEditAddrAction", sender.tag)
        let next = self.storyboard?.instantiateViewController(withIdentifier: "AddNewAddressVC") as! AddNewAddressVC
        next.editStatus = true
        next.adType = self.addressList[sender.tag].addressType!
        next.flatNo = self.addressList[sender.tag].address1!
        next.zipCode = self.addressList[sender.tag].zip!
        next.roadName = self.addressList[sender.tag].roadName!
        next.landMark = self.addressList[sender.tag].landmark!
        next.sCity = self.addressList[sender.tag].city!
        next.sName = self.addressList[sender.tag].name!
        next.sProductCurrency = sProductCurrency
        next.sEditAdreessFromBag = sEditAdreessFromBag
        var sCountry = self.addressList[sender.tag].country!

        if  sCountry == "Saudi Arabia" || sCountry == "SA"
        {
            sCountry = "SA"
        }
         else if sCountry == "Bahrain" || sCountry == "BH"
         {
            sCountry = "BH"

         }
        else if sCountry == "United Arab Emirates" || sCountry == "AE"
        {
            sCountry = "AE"

        }
        next.sCountry = sCountry
        
//        if self.addressList[sender.tag].country == ""
//        {
//            next.sCountry = ""
//        }
        next.editID = self.addressList[sender.tag].adrsId!
        
        if self.addressList[sender.tag].defaultField! == "0"
        {
            next.checkBoxStatus = false
        }
        else if self.addressList[sender.tag].defaultField! == "1"
        {
            next.checkBoxStatus = true
        }
        
        self.navigationController?.pushViewController(next, animated: true)
        
    }
    @objc func btnDelAddAction(sender: UIButton!)
    {
        print("btnDelAddAction", sender.tag)
        let alert = UIAlertController(title: Constants.appName, message: Constants.deleteAddressMSG, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { _ in
            //Yes Action
            print("YES")
            self.deleteAddress(addressID: String(sender.tag))
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
            print("NO")
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func btnAddNewAddress(_ sender: UIButton)
    {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "AddNewAddressVC") as! AddNewAddressVC
        next.addNew = true
        next.sProductCurrency = ""
        next.sEditAdreessFromBag = sEditAdreessFromBag

        self.navigationController?.pushViewController(next, animated: true)
        
    }
    
    func getAddressList(){
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = [
            "access_token":sharedDefault.getAccessToken(),
            "country_code":sharedDefault.getCountyName(),

        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.addressListURL
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
                    self.addressListModel = AddressListModel(response)
                    let statusCode = Int((self.addressListModel?.httpcode)!)
                    if statusCode == 200{
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            
                            self.view.activityStopAnimating()
                            self.addressList.removeAll()
                            if self.sProductCurrency!.count > 0
                            {
                            for item in (self.addressListModel?.addressListData)!
                            {
                                var sCountry = item.country!
                                var sArrayProductCurrency = String()
                                
                                if  sCountry == "Saudi Arabia" || sCountry == "SA"
                                {
                                    sCountry = "SA"
                                }
                                 else if sCountry == "Bahrain" || sCountry == "BH"
                                 {
                                    sCountry = "BH"

                                 }
                                else if sCountry == "United Arab Emirates" || sCountry == "AE"
                                {
                                    sCountry = "AE"

                                }
                                sArrayProductCurrency = Locale.currency[sCountry]!!
                                if self.sProductCurrency!.contains(Locale.currency[sCountry]!!) || self.sProductCurrency == sArrayProductCurrency
                                {
                                    self.addressList.append(item)
                                }
                            }
                            }
                            else
                            {
                                self.addressList = (self.addressListModel?.addressListData)!

                            }
                            self.tableAddressList.reloadData()
                            print("addressList ",self.addressList)
//                        }
                    }
                    if statusCode == 400{
                        self.view.activityStopAnimating()
                        self.showToast(message: (self.addressListModel?.message)!)
                    }
                    
                }
               catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    
    func getSearchedAddressList(){
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = [
            "access_token":sharedDefault.getAccessToken(),
//            "country_code":sharedDefault.getCountyName(),
            "search":sSearchText! as String

        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.search_addressURL
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
                    self.addressListModel = AddressListModel(response)
                    let statusCode = Int((self.addressListModel?.httpcode)!)
                    if statusCode == 200{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            
                            self.view.activityStopAnimating()
//                            self.addressList = (self.addressListModel?.addressListData)!
                            
                            self.addressList.removeAll()
                            if self.sProductCurrency!.count > 0
                            {
                            for item in (self.addressListModel?.addressListData)!
                            {
                                print(Locale.currency[item.country!] as Any)
                                var sCountry = item.country!

                                if  sCountry == "Saudi Arabia" || sCountry == "SA"
                                {
                                    sCountry = "SA"
                                }
                                 else if sCountry == "Bahrain" || sCountry == "BH"
                                 {
                                    sCountry = "BH"

                                 }
                                else if sCountry == "United Arab Emirates" || sCountry == "AE"
                                {
                                    sCountry = "AE"

                                }
                                let sArrayCurrencyDetails = Locale.currency[sCountry]!!
                                if self.sProductCurrency!.contains(sArrayCurrencyDetails)

                                {
                                    self.addressList.append(item)
                                }
                            }
                            }
                            else
                            {
                                self.addressList = (self.addressListModel?.addressListData)!

                            }
                            
                            
                            self.tableAddressList.reloadData()
                            print("addressList ",self.addressList)
                        }
                    }
                    if statusCode == 400{
                        self.view.activityStopAnimating()
                        self.showToast(message: (self.addressListModel?.message)!)
                    }
                    
                }
               catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    func deleteAddress(addressID:String)
    {
        print("deleteAddress",String(self.addressList[Int(addressID)!].adrsId!))
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = [
            "access_token":sharedDefault.getAccessToken(),
            "address_id":String(self.addressList[Int(addressID)!].adrsId!)
           
        ]
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.deleteAddressURL
        print("loginURL",loginURL)
        AF.request(loginURL, method: .post, parameters: postDict, encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
            print("Response deleteAddress :***:",data.description)
            
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
                    self.profileUpRespModel = ProfileUpRespModel(response)
                    let statusCode = Int((self.profileUpRespModel?.httpcode)!)
                    if statusCode == 200{
                        self.view.activityStopAnimating()
                        self.showToast(message: (self.profileUpRespModel?.message)!)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            
                            
                            self.getAddressList()
                        }
                    }
                    if statusCode == 400{
                        self.view.activityStopAnimating()
                        self.showToast(message: (self.profileUpRespModel?.message)!)
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
