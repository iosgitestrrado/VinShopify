//
//  AddNewAddressVC.swift
//  Vinner
//
//  Created by softnotions on 31/07/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire
import SwiftyJSON




class AddNewAddressVC: UIViewController,UITextFieldDelegate ,UITableViewDelegate,UITableViewDataSource {
    var editStatus: Bool = false
    var addNew: Bool = false

    var editID: String?
    var adType: String?
    var flatNo: String?
    var zipCode: String?
    var roadName: String?
    var landMark: String?
    var sCity: String?
    var sName: String?
    var sCountry: String?
    var sProductCurrency: String?
    var sEditAdreessFromBag: Bool = false

    
    var flatNoAdd: String?
    var zipCodeAdd: String?
    var roadNameAdd: String?
    var landMarkAdd: String?
    
    @IBOutlet weak var btnCheck: UIButton!
    var checkBoxStatus : Bool? = false
    @IBOutlet weak var lblPageTitle: UILabel!
    var addAddressModel:AddAddressModel?
    
    @IBOutlet weak var imgHome: UIImageView!
    
    @IBOutlet weak var imgWork: UIImageView!
    @IBOutlet weak var txtCity: UITextField!
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var scrollAddAddress: UIScrollView!
    @IBOutlet weak var txtLandmark: UITextField!
    @IBOutlet weak var txtRoadName: UITextField!
    @IBOutlet weak var txtZipcode: UITextField!
    @IBOutlet weak var txtFlatNo: UITextField!
    @IBOutlet weak var txtAddressType: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCLocation: UIButton!
    @IBOutlet weak var viewLocation: UIView!
    let sharedData = SharedDefault()
    var addToCartModel : AddToCartModel?

    var sAdressType = String()
    var stxtFlatNo = String()
    var stxtRoadName = String()
    var stxtLandmark = String()
    var stxtZipcode = String()
    var strdefoult = String()
    var stxtCountry = String()
    var stxtCity = String()
var stxtName = String()
//    var itemsNames = ["AE","BH","SA","RW"]
    
    var itemsNames = ["AE","BH","SA"]

    var itemsImages = ["uae","baharin","saudi"]
    
     var itemsCode = ["+971","+973","+966"]
    @IBOutlet weak var viewContry: UIView!
    @IBOutlet weak var tbldropdown: UITableView!
    
    @IBOutlet weak var txtCountry: UITextField!
    
    // MARK: Checkbox Action
    @IBAction func btnCheckAction(_ sender: UIButton) {
        print("btnCheckAction")
        if checkBoxStatus == true {
            self.btnCheck.setBackgroundImage(UIImage(named:"unchecked"), for: .normal)
            checkBoxStatus = false
        }
        else {
            self.btnCheck.setBackgroundImage(UIImage(named:"checked"), for: .normal)
            checkBoxStatus = true
        }
    }
    // MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool)
    {
        
        self.navigationController?.navigationBar.topItem?.title = ""
        tbldropdown.isHidden = true
        tbldropdown.layer.cornerRadius = 10
        tbldropdown.layer.borderWidth = 1.0
        tbldropdown.layer.borderColor = Constants.borderColor.cgColor
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap1(_:)))
        self.viewContry.addGestureRecognizer(tap1)
        txtCountry.text  = sharedData.getCountyName()

//        if self.sharedData.getSelectedCountryNameFromMap().count > 0
//        {
//            if self.sharedData.getSelectedCountryNameFromMap() != "AE" ||  self.sharedData.getSelectedCountryNameFromMap() != "BH" || self.sharedData.getSelectedCountryNameFromMap() != "SA"
//            {
//                self.showToast(message: "Currently we are not serving in this region")
//                self.sharedData.setSelectedCountryNameFromMap(loginStatus: "")
//            }
//            else
//            {
//                if editStatus == true
//                {
//                    lblPageTitle.text = "Edit Address"
//                    // self.navigationController?.navigationBar.topItem?.title = "Edit Address"
//                    self.addBackButton(title: "Edit Address")
//                    txtLandmark.text = landMark
//                    txtRoadName.text = roadName
//                    txtZipcode.text = zipCode
//                    txtFlatNo.text = flatNo
//
//                    if adType == "Home"
//                    {
//                        imgHome.image = UIImage(named: "radioSelected")
//                        imgWork.image = UIImage(named: "radioUnSelected")
//                        sAdressType = "Home"
//                    }
//                    else
//                    {
//                        imgWork.image = UIImage(named: "radioSelected")
//                        imgHome.image = UIImage(named: "radioUnSelected")
//                        sAdressType = "Work"
//                    }
//
//                    txtCity.text = sCity
//                    txtName.text = sName
//                    txtCountry.text = sCountry
//                }
//                else  if editStatus == false
//                {
//                    //self.navigationController?.navigationBar.topItem?.title = "Add New Address"
//                    self.addBackButton(title: "Add New Address")
//                    lblPageTitle.text = "Add New Address"
//                    let userdefaults = UserDefaults.standard
//                    if let savedValue = userdefaults.string(forKey: "ZipCode")
//                    {
//                       txtZipcode.text = savedValue
//                    }
//                    else
//                    {
//                      txtZipcode.text = ""
//                    }
//
//                    if let savedVa = userdefaults.string(forKey: "FlatName")
//                    {
//                       txtFlatNo.text = savedVa
//                    }
//                    else
//                    {
//                      txtFlatNo.text = ""
//                    }
//
//                    if let savedVa = userdefaults.string(forKey: "RoadName")
//                    {
//                        txtRoadName.text = savedVa
//                    }
//                    else
//                    {
//                        txtRoadName.text = ""
//                    }
//                    if let savedVa = userdefaults.string(forKey: "LandMark")
//                    {
//                        txtLandmark.text = savedVa
//                    }
//                    else
//                    {
//                        txtLandmark.text = ""
//                    }
//                    if let savedVa = userdefaults.string(forKey: "City")
//                    {
//                        txtCity.text = savedVa
//                    }
//                    else
//                    {
//                        txtCity.text = ""
//                    }
//
//
//                }
//
//
//                if addNew == true
//                {
//                    txtLandmark.text = ""
//                    txtRoadName.text = ""
//                    txtZipcode.text = ""
//                    txtFlatNo.text = ""
//
//                        imgWork.image = UIImage(named: "radioUnSelected")
//                        imgHome.image = UIImage(named: "radioUnSelected")
//                        sAdressType = ""
//                    txtCity.text = ""
//                    txtName.text = ""
//                    txtZipcode.text = ""
//                }
//            }
//        }
//        else
//        {
            if editStatus == true
            {
                lblPageTitle.text = "Edit Address"
                // self.navigationController?.navigationBar.topItem?.title = "Edit Address"
                self.addBackButton(title: "Edit Address")
                txtLandmark.text = landMark
                txtRoadName.text = roadName
                txtZipcode.text = zipCode
                txtFlatNo.text = flatNo
    //            txtAddressType.text = adType
                
                if adType == "Home"
                {
                    imgHome.image = UIImage(named: "radioSelected")
                    imgWork.image = UIImage(named: "radioUnSelected")
                    sAdressType = "Home"
                }
                else
                {
                    imgWork.image = UIImage(named: "radioSelected")
                    imgHome.image = UIImage(named: "radioUnSelected")
                    sAdressType = "Work"
                }
                
                txtCity.text = sCity
                txtName.text = sName
                txtCountry.text = sCountry
            }
            else  if editStatus == false
            {
                //self.navigationController?.navigationBar.topItem?.title = "Add New Address"
                self.addBackButton(title: "Add New Address")
                lblPageTitle.text = "Add New Address"
                //self.txtFlatNo.text = flatNoAdd
                let userdefaults = UserDefaults.standard
                if let savedValue = userdefaults.string(forKey: "ZipCode")
                {
                   txtZipcode.text = savedValue
                }
                else
                {
                  txtZipcode.text = ""
                }
                
                if let savedVa = userdefaults.string(forKey: "FlatName")
                {
                   txtFlatNo.text = savedVa
                }
                else
                {
                  txtFlatNo.text = ""
                }
                
                if let savedVa = userdefaults.string(forKey: "RoadName")
                {
                    txtRoadName.text = savedVa
                }
                else
                {
                    txtRoadName.text = ""
                }
                if let savedVa = userdefaults.string(forKey: "LandMark")
                {
                    txtLandmark.text = savedVa
                }
                else
                {
                    txtLandmark.text = ""
                }
                if let savedVa = userdefaults.string(forKey: "City")
                {
                    txtCity.text = savedVa
                }
                else
                {
                    txtCity.text = ""
                }
                
                
            }
            
            
            if addNew == true
            {
                txtLandmark.text = ""
                txtRoadName.text = ""
                txtZipcode.text = ""
                txtFlatNo.text = ""
               
                    imgWork.image = UIImage(named: "radioUnSelected")
                    imgHome.image = UIImage(named: "radioUnSelected")
                    sAdressType = ""
                txtCity.text = ""
                txtName.text = ""
                txtZipcode.text = ""
            }
//        }
        
        
       
        
        print("viewWillAppear")
    }
    
    @objc func handleTap1(_ sender: UITapGestureRecognizer? = nil)
    {
        // handling code
        print("handleTapffggfgfgf")
        
        if !sEditAdreessFromBag
        {
           
        if sProductCurrency!.count > 0
        {
            let alert = UIAlertController(title: Constants.appName, message: "If you are selecting a different region, this address will be removed from the address list. Do you wish to change?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { _ in
                
                self.tbldropdown.reloadData()
                self.tbldropdown.isHidden = false
               
            }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { _ in
                print("NO")
                
                self.tbldropdown.isHidden = true

            }))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            self.tbldropdown.reloadData()
            self.tbldropdown.isHidden = false
        }
        }
       
    }
    // MARK: - tableview delegate
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if tableView == tbldropdown {
            let countryCell = self.tbldropdown.dequeueReusableCell(withIdentifier: "CountryTCell2", for: indexPath) as! CountryTCell
            countryCell.lblCountry2.text = itemsNames[indexPath.row]
            countryCell.imgCountry2.image = UIImage(named: itemsImages[indexPath.row])
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
        txtCountry.text = itemsNames[indexPath.row]
        tbldropdown.isHidden = true
        print(itemsNames[indexPath.row])
        print(itemsCode[indexPath.row].dropFirst(1))
        print(itemsImages[indexPath.row])
//        self.sharedData.setCountyImg(token: self.itemsImages[indexPath.row])
//        self.sharedData.setCountyCode(token: self.itemsCode[indexPath.row])
//        self.sharedData.setCountyName(token: self.itemsNames[indexPath.row])
//        self.RemoveFromCart()
        
//        txtCity.text = ""
//        txtZipcode.text = ""
//        txtLandmark.text = ""
//        txtFlatNo.text = ""
//        txtRoadName.text = ""
//        txtFlatNo.text = ""
//        txtName.text = ""
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
       
        return  1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsImages.count
    }

    
    // MARK: Checkbox Action
    @IBAction func checkAction(sender: UIButton) {
        tbldropdown.isHidden = true

        if checkBoxStatus! {
            sender.setImage(UIImage(named:"checked"), for: .normal)
            checkBoxStatus = false
        }
        else {
            sender.setImage( UIImage(named:"unchecked"), for: .normal)
            checkBoxStatus = true
        }
    }
     // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viewLocation.layer.cornerRadius = 5
        viewLocation.layer.borderColor = Constants.borderColor.cgColor
        viewLocation.layer.borderWidth = 1
        btnSave.layer.cornerRadius = 5
        
        txtLandmark.delegate = self
        txtRoadName.delegate = self
        txtZipcode.delegate = self
        txtFlatNo.delegate = self
        
        
        
        
        
        
        
        
//        txtAddressType.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelNumberPad)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWithNumberPad))]
        numberToolbar.sizeToFit()
        txtZipcode.inputAccessoryView = numberToolbar
        
        
        if editStatus == true
        {
            
            
            txtLandmark.text = landMark
            txtRoadName.text = roadName
            txtZipcode.text = zipCode
            txtFlatNo.text = flatNo
            if adType == "Home"
            {
                imgHome.image = UIImage(named: "radioSelected")
                imgWork.image = UIImage(named: "radioUnSelected")
                sAdressType = "Home"
            }
            else
            {
                imgWork.image = UIImage(named: "radioSelected")
                imgHome.image = UIImage(named: "radioUnSelected")
                sAdressType = "Work"
            }

            txtCity.text = sCity
            txtName.text = sName
            txtCountry.text = sCountry
            
        }
        
        else
        
        {
            txtLandmark.text = ""
            txtRoadName.text = ""
            txtZipcode.text = ""
            txtFlatNo.text = ""
//            txtAddressType.text = ""
            txtCity.text = ""
            txtName.text = ""
        }
        // cb1.isChecked = true
        if checkBoxStatus == true
        {
            self.btnCheck.setBackgroundImage(UIImage(named:"checked"), for: .normal)
            
        }
        else {
            self.btnCheck.setBackgroundImage(UIImage(named:"unchecked"), for: .normal)
            
        }
        
        
    }
    
    
    @objc func cancelNumberPad() {
           //Cancel with number pad
           txtZipcode.resignFirstResponder()
       }
       @objc func doneWithNumberPad() {
           //Done with number pad
        txtZipcode.resignFirstResponder()
       }
    
    
    @IBAction func ActionRadioSelection(_ sender: UIButton)
    {
        tbldropdown.isHidden = true

        if sender.tag == 11
        {
            imgHome.image = UIImage(named: "radioSelected")
            imgWork.image = UIImage(named: "radioUnSelected")
            sAdressType = "Home"

        }
        else if sender.tag == 12
        {
            imgHome.image = UIImage(named: "radioUnSelected")
            imgWork.image = UIImage(named: "radioSelected")
            sAdressType = "Work"

        }
    }
    
    
    
    
    
    
    // MARK: keyboard notification
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollAddAddress.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollAddAddress.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollAddAddress.contentInset = contentInset
    }
    // MARK: - Textfield Delegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        print("textFieldShouldBeginEditing")
        tbldropdown.isHidden = true
        
        return true;
    }
    
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
    
    
    
    
    // MARK: - Save Action
    @IBAction func btnSaveAction(_ sender: UIButton)
    {
         if txtName.text!.count<=0
        {
            self.showToast(message: Constants.demoEmptyNameMsg)
        }
       
        else if txtFlatNo.text!.count<=0
        {
            self.showToast(message: Constants.flatNoEmtyMsg)
        }
        else if txtZipcode.text!.count<=0
        {
            self.showToast(message: Constants.zipCodeEmtyMsg)
        }
        else if txtRoadName.text!.count<=0
        {
            self.showToast(message: Constants.roadEmtyMsg)
        }
        else if txtLandmark.text!.count<=0
        {
            self.showToast(message: Constants.landmarkEmtyMsg)
        }
        else if txtCity.text!.count<=0
        {
            self.showToast(message: Constants.demoEmptyCityMsg)
        }
        else if sAdressType.count<=0
        {
            self.showToast(message: Constants.addTypeEmtyMsg)
        }
        else
        {
            if editStatus == true
            {
                print("editStatus")
                self.addNewAddress()
                
            }
            else if editStatus == false
            {
                self.addNewAddress()
            }
            
        }
    }
    
    
    // MARK: - Show Map Action
    @IBAction func btnCLocationAction(_ sender: UIButton)
    {
//        let next = self.storyboard?.instantiateViewController(withIdentifier: "MapViewVC") as! MapViewVC
//        self.navigationController?.pushViewController(next, animated: true)
        addNew = false
        let next = self.storyboard?.instantiateViewController(withIdentifier: "MapView2ViewController") as! MapView2ViewController
        self.navigationController?.pushViewController(next, animated: true)
        
        
    }
    
    // MARK: - Add New Address Method Action
    
    func addNewAddress() {
        self.view.activityStartAnimating()
        var def :  String?
        if checkBoxStatus == true
        {
            def = "1"
            if editID != nil
            {
                sharedData.setAddressID(loginStatus: editID!)

            }
        }
        else
        {
            def = "0"
        }
        var postDict = Dictionary<String,String>()
        var urlString:String?
        if editStatus == true
        {
            postDict = [
                "address_id": editID!,
                "access_token":sharedData.getAccessToken(),
//                "address_type":txtAddressType.text!,
                "address_type":sAdressType,

                "house_flat":txtFlatNo.text!,
                "zipcode":txtZipcode.text!,
                "road_name":txtRoadName.text!,
                "landmark":txtLandmark.text!,
                "city":txtCity.text!,
                "country_code":txtCountry.text!,
                "name":txtName.text!,
                "default":def!
                
            ]
            urlString = Constants.baseURL+Constants.editAddressURL
        }
        else if editStatus == false
        {
            //sharedData.getAccessToken()
            postDict = [
                
                "access_token":sharedData.getAccessToken(),
//                "address_type":txtAddressType.text!,
                "address_type":sAdressType,

                "house_flat":txtFlatNo.text!,
                "zipcode":txtZipcode.text!,
                "road_name":txtRoadName.text!,
                "landmark":txtLandmark.text!,
                "city":txtCity.text!,
                "country_code":txtCountry.text!,
                "name":txtName.text!,
                "default":def!
                
            ]
            urlString = Constants.baseURL+Constants.addAddressURL
        }
        
        
        print("PostData: ",postDict)
        
        
        let loginURL = urlString!
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
                        print("registerResponseModel ----- ",self.addAddressModel)
                        self.showToast(message: (self.addAddressModel?.message)!)
                        self.view.activityStopAnimating()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
                            
                            self.view.activityStopAnimating()
                            
                            
//                            self.sAdressType = self.txtAddressType.text!
//                            self.sAdressType = sAdressType
                            self.stxtName = self.txtName.text!
                            self.stxtCity = self.txtCity.text!
                            self.stxtCountry = self.txtCountry.text!
                            self.stxtFlatNo = self.txtFlatNo.text!
                            self.stxtRoadName = self.txtRoadName.text!
                            self.stxtLandmark = self.txtLandmark.text!
                            self.stxtZipcode = self.txtZipcode.text!

                            if checkBoxStatus == true {
                                self.strdefoult = "1"
                            } else {
                                self.strdefoult = "0"
                            }
                            
//                            let sAddress =     self.sAdressType + "," + self.stxtFlatNo + "," + self.stxtRoadName + "," +  self.stxtLandmark + "," + self.stxtZipcode
                            let sAddress =    self.stxtName + "," + self.sAdressType + "," + self.stxtFlatNo + "," + self.stxtRoadName + "," + self.stxtCity + "," + self.stxtLandmark + "," + self.stxtCountry + ","  +  self.stxtZipcode + "," + self.strdefoult

                            sharedData.setAddress(loginStatus: sAddress)

                            self.navigationController?.popViewController(animated:  true
                                                                         

                            )
                        }
                        
                    }
                    if statusCode == 400
                    {
                        self.view.activityStopAnimating()
                        self.showToast(message: (self.addAddressModel?.message)!)
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
    
    
    
    
    func RemoveFromCart()
    {
        
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()

        postDict = [
            "access_token":sharedData.getAccessToken()
            
        ]
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.clearCartURL
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
                    self.addToCartModel = AddToCartModel(response)
                    let statusCode = Int((self.addToCartModel?.httpcode)!)
                    if statusCode == 200{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
                        {
                            print("response ",response)
                            self.showToast(message: (self.addToCartModel?.message)!)
                            self.view.activityStopAnimating()
                        }
                    }
                    if statusCode == 400{
                        self.showToast(message: (self.addToCartModel?.message)!)
                        self.view.activityStopAnimating()
                    }
                    
                }
                catch let err {
                    self.view.activityStopAnimating()
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
}
