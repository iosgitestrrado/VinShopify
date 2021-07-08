//
//  BagVC.swift
//  Vinner
//
//  Created by softnotions on 21/07/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire
import SwiftyJSON
import iOSDropDown

class BagVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var viewDropDownHide: UIView!
    @IBOutlet weak var dropDownHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var scrollBag: UIScrollView!
    @IBOutlet weak var viewScrollBG: UIView!
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var viewShipingAgent: UIView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDelDate: UILabel!
    var dateFormatter = DateFormatter()
    var pdtDetailResponseModel : ProductDetailResponseModel?
    var CurrentStock:String?
    var sProductName = String()
    var iProductTotal = Double()
    var sProductTotal = String()
    var sArrayShippingOperatorName = [String]()
    var sArrayShippingOperatorId = [String]()
    var bSelected = Bool()

    @IBOutlet weak var tblShippingAgent: UITableView!
    var iCurrentStatusCount = Int()
    @IBOutlet weak var lblChangeAddress: UILabel!
    @IBOutlet weak var btnChangeAddress: UIButton!
    @IBOutlet weak var viewBGNoPdt: UIView!
    @IBOutlet weak var lblItemCount: UILabel!
    @IBOutlet weak var dropShipAgent: DropDown!
    
    @IBOutlet weak var txtSelectShippingOperator: UITextField!
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnCheckOut: UIButton!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var tableCartItems: UITableView!
    let sharedData = SharedDefault()
    var operatorList = [OperatorData]()
    var operatorListModel : OperatorListModel?
    var cartList = [CartItems]()
    var sArrayCurrentStock  = [String]()
    var cartListModel : CartListModel?
    var cartUpdateModel : CartUpdateModel?
    var deliveryFeeModel :DeliveryFeeModel?
    var selectedProductID = String()
    var selectedCartID = String()
    var operatorID = String()
     var pageStatus: Bool = false
    var sCountryCodes  = String()
     var cartID = String()
    var sCurrency = String()
    var sEditAdreessFromBag: Bool = false
    var sDeliveredAddress = String()
    var addToCartModel : AddToCartModel?

    var weightStatus: Bool = false
    
    let userdefaults = UserDefaults.standard
    @IBOutlet weak var lblGrandTotal: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblItemTotal: UILabel!
    @IBOutlet weak var lblDeliveryFee: UILabel!
    
    override func viewDidAppear(_ animated: Bool)
    {
        
        self.viewBGNoPdt.isHidden = true
        self.viewScrollBG.isHidden = true
        
        self.tblShippingAgent.isHidden = true
        
        self.bSelected = false
       
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.viewDropDownHide.addGestureRecognizer(gesture)

        self.tblShippingAgent.isHidden = true
        self.tblShippingAgent.layer.cornerRadius = 10
        self.tblShippingAgent.layer.borderWidth = 1.0
        self.tblShippingAgent.layer.borderColor = Constants.borderColor.cgColor
        
        
        
        /////
//
//        let saccessToken = UserDefaults.standard.value(forKey: "access_token") as! String
//
//        if saccessToken.count == 0
//        {
//            self.viewBGNoPdt.isHidden = false
//
//        }
//
//        else
//        {
        
        if UserDefaults.standard.value(forKey: "CartCleared") as! String == "Yes"
        {
            self.viewBGNoPdt.isHidden = false
        }
        else
        {
            
    
        print("Address",userdefaults.string(forKey: "Address") as Any)

       
        topBool = false
        
        if pageStatus == true
        {
            self.tabBarController?.selectedIndex = 0
        }
        
//        dropShipAgent.isSearchEnable = false
            
            if !sharedData.getLoginStatus()
            {

                let alert = UIAlertController(title: Constants.appName, message: Constants.signInMessage, preferredStyle: UIAlertController.Style.alert)
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
           
//        dropShipAgent.didSelect{(selectedText , index ,id) in
//        //self.valueLabel.text = "Selected String: \(selectedText) \n index: \(index)"
//            print("selectedText ----- ",selectedText)
//            self.operatorID = self.operatorList[index].shippingOperatorId!
//            self.sharedData.setOperatorID(token: self.operatorList[index].shippingOperatorId!)
//            self.sharedData.setOperatorName(token: self.operatorList[index].operatorField!)
//            if self.operatorID.count>0
//            {
//                self.getShipFee()
//            }
//            else
//            {
//
//            self.showToast(message: "No shipping operator available")
//
//            }
//
//        }
//
//
        
        viewAddress.layer.cornerRadius = 5
        viewAddress.layer.borderWidth = 1.0
        viewAddress.layer.borderColor = Constants.borderColor.cgColor
            
            
            
            
            
            
        tableCartItems.delegate = self
        tableCartItems.dataSource = self
        //tableHeight.constant = self.tableViewHeight + 50
        btnCheckOut.layer.cornerRadius = 5
//        print("tableCartItems ------ ",self.tableViewHeight)
        //tableCartItems.layoutIfNeeded()
//        tableCartItems.reloadData()
//
//
        self.getShipAgent()
        self.getCartList()
        
        viewShipingAgent.layer.cornerRadius = 5
        viewShipingAgent.layer.borderWidth = 1.0
        viewShipingAgent.layer.borderColor = Constants.borderColor.cgColor
        
        let userdefaults = UserDefaults.standard
        
        if let savedValue = userdefaults.string(forKey: "operator_id")
        {
           print("Here you will get saved value")
            self.operatorID = sharedData.getOperatorID()
//            dropShipAgent.text = sharedData.getOperatorName()
            self.txtSelectShippingOperator.text = sharedData.getOperatorName()

        }
        else
        {
           print("No value in Userdefault,Either you can save value here or perform other operation")
          /// userdefaults.set("Here you can save value", forKey: "key")
        }
        
       tableCartItems.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        print("AddressviewWillAppear",userdefaults.string(forKey: "Address") as Any)

        if let savedValue = userdefaults.string(forKey: "Address")
        {
//            if self.sharedData.getAddress().contains(",0")
//            {
//                self.lblAddress.text = self.sharedData.getAddress().replacingOccurrences(of: ",0", with: "", options: NSString.CompareOptions.literal, range:nil)
//            }
//            else if self.sharedData.getAddress().contains(",1")
//            {
//                self.lblAddress.text = self.sharedData.getAddress().replacingOccurrences(of: ",1", with: "", options: NSString.CompareOptions.literal, range:nil)
//
//            }
//
            
            self.lblAddress.text = self.sDeliveredAddress
            self.lblChangeAddress.text = "Change Address"
          
            

        }
        else
        {
            self.lblAddress.text = ""
            self.lblChangeAddress.text = "Add Address"

        }
            
            
           
            
        }
            
        }
//        }
        
        
    }
    
    
    
    // MARK: - Textfield Delegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print("textFieldShouldReturn")

        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        print("textFieldShouldBeginEditing")
        
        return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        print("shouldChangeCharactersIn")
        
        return true;
       
    }
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
       

        self.addBackButton(title: "Bag")

        iCurrentStatusCount = 0
        iProductTotal = 0
        print("Address",userdefaults.string(forKey: "Address") as Any)
        self.navigationController?.navigationBar.topItem?.title = ""
        self.viewBGNoPdt.isHidden = true
        self.viewScrollBG.isHidden = true
        
        if UserDefaults.standard.value(forKey: "CartCleared") as! String == "Yes"
        {
            self.viewBGNoPdt.isHidden = false
        }
        else
        {
            
        topBool = false
        
        if pageStatus == true
        {
            self.tabBarController?.selectedIndex = 0
        }
        
            
            if !sharedData.getLoginStatus()
            {

                let alert = UIAlertController(title: Constants.appName, message: Constants.bagInfo, preferredStyle: UIAlertController.Style.alert)
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
                
                
            
//        dropShipAgent.isSearchEnable = false
//        dropShipAgent.didSelect{(selectedText , index ,id) in
//        //self.valueLabel.text = "Selected String: \(selectedText) \n index: \(index)"
//            print("selectedText ----- ",selectedText)
//
//            self.operatorID = self.operatorList[index].shippingOperatorId!
//            self.sharedData.setOperatorID(token: self.operatorList[index].shippingOperatorId!)
//            self.sharedData.setOperatorName(token: self.operatorList[index].operatorField!)
//            if self.operatorID.count>0
//            {
//                self.getShipFee()
//            }
//            else
//            {
//                self.showToast(message: "No shipping operator available")
//
//            }
//
//        }
        
        
        
        viewAddress.layer.cornerRadius = 5
        viewAddress.layer.borderWidth = 1.0
        viewAddress.layer.borderColor = Constants.borderColor.cgColor
            
            
       
            
            
            
            
        tableCartItems.delegate = self
        tableCartItems.dataSource = self
        //tableHeight.constant = self.tableViewHeight + 50
        btnCheckOut.layer.cornerRadius = 5
//        print("tableCartItems ------ ",self.tableViewHeight)
        //tableCartItems.layoutIfNeeded()
        tableCartItems.reloadData()
        
        
//        self.getShipAgent()
//        self.getCartList()
        
        viewShipingAgent.layer.cornerRadius = 5
        viewShipingAgent.layer.borderWidth = 1.0
        viewShipingAgent.layer.borderColor = Constants.borderColor.cgColor
        
        let userdefaults = UserDefaults.standard
        
        if let savedValue = userdefaults.string(forKey: "operator_id")
        {
           print("Here you will get saved value")
            self.operatorID = sharedData.getOperatorID()
//            dropShipAgent.text = sharedData.getOperatorName()
            txtSelectShippingOperator.text = sharedData.getOperatorName()

        }
        else
        {
           print("No value in Userdefault,Either you can save value here or perform other operation")
          /// userdefaults.set("Here you can save value", forKey: "key")
        }
        
       tableCartItems.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        print("AddressviewWillAppear",userdefaults.string(forKey: "Address") as Any)

        if let savedValue = userdefaults.string(forKey: "Address")
        {
//            self.lblAddress.text = self.sharedData.getAddress()
            self.lblChangeAddress.text = "Change Address"
            
            
//            if self.sDeliveredAddress.contains(",0")
//            {
//                self.lblAddress.text = self.sDeliveredAddress.replacingOccurrences(of: ",0", with: "", options: NSString.CompareOptions.literal, range:nil)
//            }
//            else if self.sharedData.getAddress().contains(",1")
//            {
//                self.lblAddress.text = self.sharedData.getAddress().replacingOccurrences(of: ",1", with: "", options: NSString.CompareOptions.literal, range:nil)
//
//            }
            
            self.lblAddress.text = self.sDeliveredAddress


        }
        else
        {
            self.lblAddress.text = ""
            self.lblChangeAddress.text = "Add Address"

        }
            }
        }
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]
            {
                let newsize  = newvalue as! CGSize
               tableHeight.constant = newsize.height
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        //tableCartItems.removeObserver(self, forKeyPath: "contentSize")
        super.viewWillDisappear(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
      
            self.viewBGNoPdt.isHidden = true
            self.viewScrollBG.isHidden = true
        
        
        
    }
    
    
    @IBAction func ActionContinueShopping(_ sender: Any)
    {
        
//        self.navigationController?.popToRootViewController(animated: true)


        guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabbar") as? TabBarController else {
                                            return
                                        }
                                        let navigationController = UINavigationController(rootViewController: rootVC)

                                        UIApplication.shared.windows.first?.rootViewController = navigationController
                                        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
   
    }
    
    
    
    // MARK: - tableview delegate
    
//    var tableViewHeight: CGFloat {
//        tableCartItems.layoutIfNeeded()
//
//        return tableCartItems.contentSize.height
//    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if tableView == tableCartItems {
            let bagTableCell = tableCartItems.dequeueReusableCell(withIdentifier: "BagTableCell", for: indexPath) as! BagTableCell
            bagTableCell.layer.borderWidth = 1.0
            bagTableCell.layer.borderColor = Constants.borderColor.cgColor
            bagTableCell.layer.cornerRadius = 5.0
            bagTableCell.btnAdd.layer.cornerRadius = 5.0
            bagTableCell.btnDec.layer.cornerRadius = 5.0
            //bagTableCell.imgProduct.image = UIImage(named: "Transparent")
            bagTableCell.imgProduct.sd_setImage(with: URL(string: (self.cartList[indexPath.section].productImage)!), placeholderImage: UIImage(named: "Transparent"))
            bagTableCell.lblPdtName.text = self.cartList[indexPath.section].productName!
            
            self.sProductName = self.cartList[indexPath.section].productName!
            
            bagTableCell.lblPdtName.text = self.sProductName.capitalized
            
            
            bagTableCell.lblCategory.text = self.cartList[indexPath.section].categoryName!
            
            
            if self.cartList[indexPath.section].productTotal == "0" ||  self.cartList[indexPath.section].productTotal == "" ||  self.cartList[indexPath.section].productTotal == nil
            {
                bagTableCell.lblPrice.text = ""
            }
            else
            {
                
                
                let iPricerate = self.ConvertCurrencyFormat(sNumber: Double(self.cartList[indexPath.section].productTotal!)! as NSNumber)
                let result1 = String(iPricerate.dropFirst())    //
                bagTableCell.lblPrice.text = self.cartList[indexPath.section].currency! + " " + result1

            }
          
            
             bagTableCell.lblCount.text = self.cartList[indexPath.section].productQuantity!
            bagTableCell.btnAdd.tag = indexPath.section
             bagTableCell.btnDec.tag = indexPath.section
            bagTableCell.btnRemove.tag = indexPath.section
            
            
            bagTableCell.btnAdd .addTarget(self, action: #selector(getAddQty), for: .touchUpInside)
            bagTableCell.btnDec .addTarget(self, action: #selector(getDecQty), for: .touchUpInside)
             bagTableCell.btnRemove .addTarget(self, action: #selector(removeCartItem), for: .touchUpInside)
            bagTableCell.btnRemove.tag = indexPath.section
            bagTableCell.lblDelivery.text = self.cartList[indexPath.section].delivery!
            bagTableCell.selectionStyle = .none
            cell = bagTableCell
        }
        else
        {
            let shippingDropDownTableViewCell = tblShippingAgent.dequeueReusableCell(withIdentifier: "ShippingDropDownTableViewCell", for: indexPath) as! ShippingDropDownTableViewCell
            shippingDropDownTableViewCell.lblShippingOperator.text = self.operatorList[indexPath.row].operatorField!
            cell = shippingDropDownTableViewCell

        }
        
        return cell
    }
    
    
    
    @IBAction func ActionDropDown(_ sender: Any) {
        
        if bSelected == false
        {
            let iHeight = 45 * Int(self.operatorList.count)
            
            self.dropDownHeightConstraints.constant = CGFloat(Double(iHeight))

            
            tblShippingAgent.isHidden = false
            tblShippingAgent.reloadData()
            bSelected = true
        }
        else
        
        {
            tblShippingAgent.isHidden = true
            bSelected = false

        }
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        // Do what you want
        tblShippingAgent.isHidden = true
        bSelected = false
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tableNotification ",indexPath.row)
        print("tableNotification section ",indexPath.section)
        
        if tableView == tableCartItems
        {
            tblShippingAgent.isHidden = true
            bSelected = false
        }
        else
        {
            self.operatorID = self.operatorList[indexPath.row].shippingOperatorId!
            self.sharedData.setOperatorID(token: self.operatorList[indexPath.row].shippingOperatorId!)
            self.sharedData.setOperatorName(token: self.operatorList[indexPath.row].operatorField!)
            self.txtSelectShippingOperator.text = self.sharedData.getOperatorName()
            if self.operatorID.count>0
            {
                self.getShipFee()
            }
            else
            {
                
            self.showToast(message: "No shipping operator available")

            }
            tblShippingAgent.isHidden = true

        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView == tableCartItems
        {
            return  self.cartList.count

        }
        else
        
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblShippingAgent
        {
            return  self.operatorList.count

        }
        else
        {
            return 1

        }
    }
//    // Make the background color show through
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//
//        let headerView = UIView()
//        headerView.backgroundColor = UIColor.red
//        return headerView
//    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0.0
//    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                var height:CGFloat = CGFloat()
                if tableView == tableCartItems {
                    height = 165
                }
                else
                {
                    height = 35
                }

                return height
            }
    
    
    
    
    
    
    // MARK: - IBActions
    @IBAction func btnCheckoutAction(_ sender: Any)
    {
        //self.tableCartItems .removeObserver(self, forKeyPath: "contentSize")
        
       
        if self.sharedData.getAddress().count > 0
        {
    
        let components = self.sharedData.getAddress().components(separatedBy: ",")
        let sAddressCountrty = components[6]

        print(Locale.currency[sAddressCountrty] as Any)
        
            var sArrayCurrencyDetails:String
            if Locale.currency[sAddressCountrty] == nil
            {
                sArrayCurrencyDetails = "nil"
            }
            else
            {
                sArrayCurrencyDetails = Locale.currency[sAddressCountrty]!!

            }
//            if !self.sProductCurrency.contains(sArrayCurrencyDetails!!)
//            {
//        if sCurrency != sArrayCurrencyDetails
            if !self.sCurrency.contains(sArrayCurrencyDetails)

        {
            self.showToast(message: "Selected country not matching with your default delivery address. Please choose correct delivery address")
        }
        else
        {
        sCountryCodes = UserDefaults.standard.value(forKey: "country_code")! as! String
        
        if sCountryCodes  == "+971" || sCountryCodes == "+973" || sCountryCodes == "+966" || sCountryCodes  == "971" || sCountryCodes == "973" || sCountryCodes == "966"
            
        {
        
        let userdefaults = UserDefaults.standard
        if let savedValue = userdefaults.string(forKey: "operator_id")
        {
            if savedValue.count>0
            {
                if weightStatus == true
                {
                
                let next = self.storyboard?.instantiateViewController(withIdentifier: "CheckoutVC") as! CheckoutVC
                    
                    
                    
                    
                    if self.deliveryFeeModel?.deliveryFeeData?.price == "0" ||  self.deliveryFeeModel?.deliveryFeeData?.price == "" ||  self.deliveryFeeModel?.deliveryFeeData?.price == nil
                    {
                        next.itemTotal = "0"
                    
                    }
                    else
                    {
                        let iPricerate = self.ConvertCurrencyFormat(sNumber: Double((self.deliveryFeeModel?.deliveryFeeData?.price!)!)! as NSNumber)
                        let result1 = String(iPricerate.dropFirst())
                        next.itemTotal = (self.deliveryFeeModel?.deliveryFeeData?.currency!)! +
                            " " + result1
                        

                    }
                  
                    
                    
                    if self.deliveryFeeModel?.deliveryFeeData?.deliveryFee == "0" ||  self.deliveryFeeModel?.deliveryFeeData?.deliveryFee == ""
                    {
                        next.delFee = "0"
                    
                    }
                    else
                    {
                        let iPricerate1 = self.ConvertCurrencyFormat(sNumber: Double((self.deliveryFeeModel?.deliveryFeeData?.deliveryFee!)!)! as NSNumber)
                        let result11 = String(iPricerate1.dropFirst())
                        next.delFee = (self.deliveryFeeModel?.deliveryFeeData?.currency!)! +
                            " " + result11

                    }
                  
                   
                    
//                next.itemTotal = (self.deliveryFeeModel?.deliveryFeeData?.price!)! +
//                    " " + (self.deliveryFeeModel?.deliveryFeeData?.currency!)!
                    
//                    next.delFee = (self.deliveryFeeModel?.deliveryFeeData?.deliveryFee!)! +
//                        " " + (self.deliveryFeeModel?.deliveryFeeData?.currency!)!
                    
//                next.subTotal = (self.deliveryFeeModel?.deliveryFeeData?.subTotal!)! +
//                    " " + (self.deliveryFeeModel?.deliveryFeeData?.currency!)!
//                    next.grantTotal = (self.deliveryFeeModel?.deliveryFeeData?.totalAmount!)! +
//                        " " + (self.deliveryFeeModel?.deliveryFeeData?.currency!)!
                    
                    
                    
                    if self.deliveryFeeModel?.deliveryFeeData?.subTotal == "0" ||  self.deliveryFeeModel?.deliveryFeeData?.subTotal == "" ||  self.deliveryFeeModel?.deliveryFeeData?.subTotal == nil
                    {
                        next.subTotal = "0"
                    
                    }
                    else
                    {
                        let iPricerate2 = self.ConvertCurrencyFormat(sNumber: Double((self.deliveryFeeModel?.deliveryFeeData?.subTotal!)!)! as NSNumber)
                        let result2 = String(iPricerate2.dropFirst())
                        next.subTotal = (self.deliveryFeeModel?.deliveryFeeData?.currency!)! +
                            " " + result2
                    }
                  
                    
                    
                    if self.deliveryFeeModel?.deliveryFeeData?.totalAmount == "0" ||  self.deliveryFeeModel?.deliveryFeeData?.totalAmount == "" ||  self.deliveryFeeModel?.deliveryFeeData?.totalAmount == nil
                    {
                        next.grantTotal = "0"
                    
                    }
                    else
                    {
                        let iPricerate3 = self.ConvertCurrencyFormat(sNumber: Double((self.deliveryFeeModel?.deliveryFeeData?.totalAmount!)!)! as NSNumber)
                        let result3 = String(iPricerate3.dropFirst())
                        next.grantTotal = (self.deliveryFeeModel?.deliveryFeeData?.currency!)! +
                            " " + result3
                        
                  
                    }
                  
                    
                    
                    
                 
                    
                    
                    next.sAmount = self.deliveryFeeModel?.deliveryFeeData?.totalAmount!
                
                // Changes by Praveen
//                if self.sharedData.getAddress().contains(",0")
//                {
//                    next.delAddress = self.sharedData.getAddress().replacingOccurrences(of: ",0", with: "", options: NSString.CompareOptions.literal, range:nil)
//                }
//                else if self.sharedData.getAddress().contains(",1")
//                {
//                    next.delAddress = self.sharedData.getAddress().replacingOccurrences(of: ",1", with: "", options: NSString.CompareOptions.literal, range:nil)
//
//                }
                    next.delAddress =  self.sDeliveredAddress
                let components = self.sharedData.getAddress().components(separatedBy: ",")

                next.address_type = components[1]
                next.housename = components[2]
                next.sZip = components[7]
                next.roadname = components[3]
                next.landmark = components[5]
                next.sCity = components[4]
                next.sName = components[0]
                    
                    next.sCurrency = sCurrency
                    
                    if components[6] == "BH"
                    {
                        next.sCountry = "Bahrain"

                    }
                    else if components[6] == "SA"
                    {
                        next.sCountry = "Saudi Arabia"

                    }
                    else if components[6] == "AE"
                    {
                        next.sCountry = "United Arab Emirates"

                    }
                
//                let sAdressType = (self.cartListModel?.cartListData?.address?.addressType)! as String
//                let stxtFlatNo = (self.cartListModel?.cartListData?.address?.houseFlat)!  as String
//                let stxtRoadName = (self.cartListModel?.cartListData?.address?.roadName)!  as String
//                let stxtLandmark = (self.cartListModel?.cartListData?.address?.landmark)!  as String
//                let stxtZipcode = (self.cartListModel?.cartListData?.address?.zip)!  as String
//
//
//                let sAddress =     sAdressType + "," + stxtFlatNo + "," + stxtRoadName + "," +  stxtLandmark + "," +  stxtZipcode
                
//                next.delAddress =  sAddress
              
//                next.address_type = self.cartListModel?.cartListData?.address?.addressType
//                next.housename = self.cartListModel?.cartListData?.address?.houseFlat
//                next.roadname = self.cartListModel?.cartListData?.address?.roadName
//                next.landmark = self.cartListModel?.cartListData?.address?.landmark
//                next.sZip = self.cartListModel?.cartListData?.address?.zip
//                next.sCity = self.cartListModel?.cartListData?.address?.city
//                next.sName = self.cartListModel?.cartListData?.address?.name

                
                
                
                
                next.cartID = self.cartList[0].cartItemId
                
                
                self.navigationController?.pushViewController(next, animated: true)
                }
                else
                {
//                            self.showToast(message: "Total weight of shipment exceeds the maximum limit allowed in your area.")
                        
//                    self.showToast(message: "Sorry, your cart is under weight for shipping")
                    
                    self.showToast(message: UserDefaults.standard.value(forKey: "Msg") as! String)
                    
                }
                    
            }
            else
            {
                self.showToast(message: "Please select operator")
            }
        }
        else
        {
            print("No value in Userdefault,Either you can save value here or perform other operation")
            self.showToast(message: " Please select operator")
        }
        
        
        
    }
        else
        {
            self.showToast(message: "Selected country not matching with your default delivery address. Please choose correct delivery address")

        }
        }
    }
        else
        {
            self.showToast(message: "Please provide your address")

        }
        
}
    
    
    @IBAction func btnEditAddress(_ sender: UIButton)
    {
        
        if self.lblChangeAddress.text == "Add Address"
        {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "AddNewAddressVC") as! AddNewAddressVC
            next.sProductCurrency = ""
            next.sEditAdreessFromBag = true
            self.navigationController?.pushViewController(next, animated: true)
            
        }
        
        else
        {
        print("btnEditAddress")
//        let next = self.storyboard?.instantiateViewController(withIdentifier: "AddNewAddressVC") as! AddNewAddressVC
//
//
//
//        next.editStatus = true
//
//
//            let components = self.sharedData.getAddress().components(separatedBy: ",")
//            next.sProductCurrency = self.sCurrency
//            next.adType = components[1]
//            next.flatNo = components[2]
//            next.zipCode = components[7]
//            next.roadName = components[3]
//            next.landMark = components[5]
//            if let savedValue = userdefaults.string(forKey: "AddressID")
//            {
//                next.editID = sharedData.getAddressID()
//            }
//            next.sCity = components[4]
//            next.sName = components[0]
//            next.sCountry = components[6]
//            if let savedValue = userdefaults.string(forKey: "AddressID"){
//                next.editID = sharedData.getAddressID()
//            }
//
//            if components[8] == "0"
//            {
//                next.checkBoxStatus = false
//            }
//            else
//            {
//                next.checkBoxStatus = true
//            }
//
//
//            self.navigationController?.pushViewController(next, animated: true)
            
            
            
            
            let next = self.storyboard?.instantiateViewController(withIdentifier: "AddressListVC") as! AddressListVC
            next.sAddresData = "My Delivery Address"
            next.sProductCurrency = self.sCurrency
            next.sEditAdreessFromBag = true
            self.navigationController?.pushViewController(next, animated: true)
            
        }
    }
    
    @IBAction func btnShippingAddressEditAction(_ sender: Any)
    {
        
        
    }
    
    
    
    @objc func removeCartItem(sender: UIButton!) {
        print("removeCartItem")
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = [
          "access_token":sharedData.getAccessToken(),
          "cart_id":cartList[sender.tag].cartId!,
          "product_id":self.cartList[sender.tag].productId!
        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.removeCartItemURL
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
                    self.cartUpdateModel = CartUpdateModel(response)
                    let statusCode = Int((self.cartUpdateModel?.httpcode)!)
                    if statusCode == 200{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        
                           self.showToast(message: (self.cartUpdateModel?.message)!)
                           self.view.activityStopAnimating()
                            self.getCartList()
                        }
                    }
                    if statusCode == 400{
                        self.showToast(message: (self.cartUpdateModel?.message)!)
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
    
    func getShipFee() {
        
        self.view.activityStartAnimating()
        var postDict = Dictionary<String,String>()
        postDict = [
            "access_token":sharedData.getAccessToken(),
            "operator_id": self.operatorID
        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.deliveryFeeURL
        print("loginURL",loginURL)
        
        AF.request(loginURL, method: .post, parameters: postDict, encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
            print("getShipAgent::-------- ",data.description)
            
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
                    self.deliveryFeeModel = DeliveryFeeModel(response)
                    let statusCode = Int((self.deliveryFeeModel?.httpcode)!)
                    if statusCode == 200{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.view.activityStopAnimating()
                          
                            
                            
                            if self.deliveryFeeModel?.deliveryFeeData?.deliveryFee == "0" ||  self.deliveryFeeModel?.deliveryFeeData?.deliveryFee == "" ||  self.deliveryFeeModel?.deliveryFeeData?.deliveryFee == nil
                            {
                                self.lblDeliveryFee.text = (self.deliveryFeeModel?.deliveryFeeData?.currency!)! +
                                    " " + "0.00"
                            
                            }
                            else
                            {
                                
                                let iPricerate = self.ConvertCurrencyFormat(sNumber: Double((self.deliveryFeeModel?.deliveryFeeData?.deliveryFee!)!)! as NSNumber)
                                let result1 = String(iPricerate.dropFirst())    //
                                
                                self.lblDeliveryFee.text = (self.deliveryFeeModel?.deliveryFeeData?.currency!)! +
    " " + result1
                          
                            }
                            
                            
                            
//                            self.lblDeliveryFee.text = (self.deliveryFeeModel?.deliveryFeeData?.deliveryFee!)! +
//" " + (self.deliveryFeeModel?.deliveryFeeData?.currency!)!
                            
                            if self.deliveryFeeModel?.deliveryFeeData?.subTotal == "0" ||  self.deliveryFeeModel?.deliveryFeeData?.subTotal == "" ||  self.deliveryFeeModel?.deliveryFeeData?.subTotal == nil
                            {
                                self.lblSubTotal.text = (self.deliveryFeeModel?.deliveryFeeData?.currency!)! +
                                    " " + "0.00"
                            
                            }
                            else
                            {
                                
                                let iPricerate1 = self.ConvertCurrencyFormat(sNumber: Double((self.deliveryFeeModel?.deliveryFeeData?.subTotal!)!)! as NSNumber)
                                let result11 = String(iPricerate1.dropFirst())
                                
                                self.lblSubTotal.text = (self.deliveryFeeModel?.deliveryFeeData?.currency!)! +
    " " + result11
                          
                            }
                            
                             //
                            
//                            self.lblSubTotal.text = (self.deliveryFeeModel?.deliveryFeeData?.subTotal!)! +
//                            " " + (self.deliveryFeeModel?.deliveryFeeData?.currency!)!
                            
                    
                            
//                            self.lblSubTotal.text = (self.deliveryFeeModel?.deliveryFeeData?.subTotal!)! +
//                            " " + (self.deliveryFeeModel?.deliveryFeeData?.currency!)!
                            
                            
                            
                            
                            if self.deliveryFeeModel?.deliveryFeeData?.price == "0" ||  self.deliveryFeeModel?.deliveryFeeData?.price == "" ||  self.deliveryFeeModel?.deliveryFeeData?.price == nil
                            {
                                self.lblItemTotal.text = (self.deliveryFeeModel?.deliveryFeeData?.currency!)! +
                                    " " + "0.00"
                            
                            }
                            else
                            {
                                
                                let iPricerate2 = self.ConvertCurrencyFormat(sNumber: Double((self.deliveryFeeModel?.deliveryFeeData?.price!)!)! as NSNumber)
                                let result12 = String(iPricerate2.dropFirst())
                                
                                self.lblItemTotal.text = (self.deliveryFeeModel?.deliveryFeeData?.currency!)! +
                                " " + result12
                          
                            }
                            
                            
                          
                            
//                            self.lblItemTotal.text = (self.deliveryFeeModel?.deliveryFeeData?.price!)! +
//                            " " + (self.deliveryFeeModel?.deliveryFeeData?.currency!)!
                            
                            
                            
                            if self.deliveryFeeModel?.deliveryFeeData?.totalAmount == "0" ||  self.deliveryFeeModel?.deliveryFeeData?.totalAmount == "" ||  self.deliveryFeeModel?.deliveryFeeData?.totalAmount == nil
                            {
                                self.lblGrandTotal.text = (self.deliveryFeeModel?.deliveryFeeData?.currency!)! +
                                    " " + "0.00"
                            
                            }
                            else
                            {
                                
                                
                                let iPricerate3 = self.ConvertCurrencyFormat(sNumber: Double((self.deliveryFeeModel?.deliveryFeeData?.totalAmount!)!)! as NSNumber)
                                let result3 = String(iPricerate3.dropFirst())
                                
                                self.lblGrandTotal.text = (self.deliveryFeeModel?.deliveryFeeData?.currency!)! +
                                " " + result3
                          
                            }
                          
                          
                            
//                            self.lblGrandTotal.text = (self.deliveryFeeModel?.deliveryFeeData?.totalAmount!)! +
//                            " " + (self.deliveryFeeModel?.deliveryFeeData?.currency!)!
                           
                            
                            
                            let sOrderDate = (self.deliveryFeeModel?.deliveryFeeData?.deliveryExpDate!)

                            self.dateFormatter.dateFormat = "yyyy-MM-dd"//this your string date format
                            self.dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
                            let date = self.dateFormatter.date(from: sOrderDate!)

                            
                            self.dateFormatter = DateFormatter()
                            self.dateFormatter.dateFormat = "dd/MM/yyyy" ///this is what you want to convert format
                            self.dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
                            let timeStamp = self.dateFormatter.string(from: date!)
                            
                            
//                            self.lblDelDate.text = (self.deliveryFeeModel?.deliveryFeeData?.deliveryExpDate!)!
                            
                            self.lblDelDate.text = timeStamp

                            self.weightStatus = true
                            
                        }
                    }
                    if statusCode == 400
                    {
//                        self.lblSubTotal.text = "0.00 " + self.sCurrency
//                        self.lblDeliveryFee.text = "0.00 " + self.sCurrency
//                        self.lblSubTotal.text = "0.00 " + self.sCurrency
//                        self.lblItemTotal.text = "0.00 " + self.sCurrency
//                        self.lblGrandTotal.text = "0.00 " + self.sCurrency
                        
                        
                        self.lblSubTotal.text = self.sCurrency + " 0.00"
                        self.lblDeliveryFee.text = self.sCurrency + " 0.00"
                        self.lblSubTotal.text = self.sCurrency + " 0.00"
//                        self.lblItemTotal.text = self.sProductTotal
                        
                    
                        self.lblGrandTotal.text = self.sCurrency + " 0.00"
                        
                        self.lblDelDate.text = (self.deliveryFeeModel?.deliveryFeeData?.deliveryExpDate!)!
                        self.weightStatus = false
                        
     
                      
                        self.showToast(message: (self.deliveryFeeModel?.message)!)

                        UserDefaults.standard.setValue(self.deliveryFeeModel?.message, forKey: "Msg")
                        
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
     func getShipAgent() {
        
        self.view.activityStartAnimating()
        var postDict = Dictionary<String,String>()
        postDict = [
          "access_token":sharedData.getAccessToken()
        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.shipOperatorURL
        print("loginURL",loginURL)
        
        AF.request(loginURL, method: .post, parameters: postDict, encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
            print("getShipAgent::-------- ",data.description)
            
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
                    self.operatorListModel = OperatorListModel(response)
                    let statusCode = Int((self.operatorListModel?.httpcode)!)
                    if statusCode == 200{
                     
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                         self.view.activityStopAnimating()
                         self.operatorList = (self.operatorListModel?.operatorData)!
//                         self.dropShipAgent.optionArray.removeAll()
//                         for item in self.operatorList{
//                             self.dropShipAgent.optionArray.append(item.operatorField!)
//                         }
                         
                         self.view.activityStopAnimating()

                        }
                    }
                    if statusCode == 400
                    {
//                           self.showToast(message: (self.operatorListModel?.message)!)
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
    
    @objc func getAddQty(sender: UIButton!) {
        
        self.iProductTotal = 0
        var sCurrent_Stock = self.cartList[sender.tag].current_stock
        
        var qty:Int = Int(self.cartList[sender.tag].productQuantity!)!
        
        var qty2:Int = Int(self.cartList[sender.tag].current_stock)!


        print("Current Stock",Int(self.cartList[sender.tag].current_stock)!)
        
        if qty < qty2
        {
            qty = qty + 1
             print("AddQty",qty)
            self.view.activityStartAnimating()
            
            var postDict = Dictionary<String,String>()
            postDict = [
              "access_token":sharedData.getAccessToken(),
              "cart_id":cartList[sender.tag].cartId!,
              "product_id":self.cartList[sender.tag].productId!,
              "product_qty":String(qty)
              
            ]
            
            print("PostData: ",postDict)
            let loginURL = Constants.baseURL+Constants.updateCartURL
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
                        self.cartUpdateModel = CartUpdateModel(response)
                        let statusCode = Int((self.cartUpdateModel?.httpcode)!)
                        if statusCode == 200{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            
                               self.showToast(message: (self.cartUpdateModel?.message)!)
                               self.view.activityStopAnimating()
                                self.getCartList()
                            }
                        }
                        if statusCode == 400{
                            self.showToast(message: (self.cartUpdateModel?.message)!)
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
        else
        {
            self.showToast(message: "Out of stock")
        }
        
        
    }
    
    
    @objc func getDecQty(sender: UIButton!) {
        
        self.iProductTotal = 0

        var qty:Int = Int(self.cartList[sender.tag].productQuantity!)!
        qty = qty - 1
        print("getDecQty",qty)
        if qty >= 0 {
            self.view.activityStartAnimating()
            
            var postDict = Dictionary<String,String>()
            if qty == 0 {
                self.view.activityStopAnimating()
                self.removeCartItem(sender:sender)
                return
            } else {
                postDict = [
                    "access_token":sharedData.getAccessToken(),
                    "cart_id":cartList[sender.tag].cartId!,
                    "product_id":self.cartList[sender.tag].productId!,
                    "product_qty":String(qty)
                    
                ]
            }
            
            
            print("PostData: ",postDict)
            let loginURL = Constants.baseURL+Constants.updateCartURL
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
                        self.cartUpdateModel = CartUpdateModel(response)
                        let statusCode = Int((self.cartUpdateModel?.httpcode)!)
                        if statusCode == 200{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                
                                self.showToast(message: (self.cartUpdateModel?.message)!)
                                self.view.activityStopAnimating()
                                self.getCartList()
                            }
                        }
                        if statusCode == 400{
                            self.showToast(message: (self.cartUpdateModel?.message)!)
                            self.view.activityStopAnimating()
                        }
                        
                    }
                    catch let err {
                        self.view.activityStopAnimating()
                        print("Error::",err.localizedDescription)
                    }
                }
            }
            
            
        } else {
            
        }
        
    }
    
    func getCartList()
    {
        
       
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = [
            "access_token":sharedData.getAccessToken()
            
        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.cartListURL
        print("loginURL",loginURL)
        
        AF.request(loginURL, method: .post, parameters: postDict, encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
            print("Response getCartList :***:",data.description)
            
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
                    self.cartListModel = CartListModel(response)
                    let statusCode = Int((self.cartListModel?.httpcode)!)
                    if statusCode == 200{
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
//
                            
                            print("response ",response)
                            print("grandTotal ",(self.cartListModel?.cartListData?.cart?.grandTotal!)!)
                            print("subTotal ",(self.cartListModel?.cartListData?.cart?.totalAmount!)!)
                            
                            self.cartList = (self.cartListModel?.cartListData?.cartItems)!
                            
                            print("")
                            
                            
                            self.lblItemCount.text = String(self.cartList.count) + " Items"
                            
                            self.sCurrency = (self.cartListModel?.cartListData?.cart?.currency)!
                            

                            
                            self.lblDeliveryFee.text = (self.cartListModel?.cartListData?.cart?.currency!)! + " " + "0.00"
                            self.lblItemTotal.text = (self.cartListModel?.cartListData?.cart?.currency!)! + " " + "0.00"


                            self.iProductTotal = 0
                            for item in self.cartList
                            {
                                print(item.productTotal!)
                                
                                if item.productTotal == "0" ||  item.productTotal == "" ||  item.productTotal == nil
                                {

                                }
                                else
                                {
                                    
                                    self.iProductTotal = self.iProductTotal + Double(item.productTotal!)!
                                    
                                    let iPricerate1 = self.ConvertCurrencyFormat(sNumber: Double(self.iProductTotal) as NSNumber)
                                    let result11 = String(iPricerate1.dropFirst())
                                    
                                    
                                    self.sProductTotal = item.currency! + " " + result11
                                    
                                    
                                    self.lblItemTotal.text = self.sProductTotal
                                    
                                    
                                    
                        

                                }
                                
                                
                            }
                            
                            
                            
                            
                        if self.txtSelectShippingOperator.text == ""
                            {
                                self.lblSubTotal.text =   self.sCurrency + " 0.00"
                                self.lblGrandTotal.text =  self.sCurrency + " 0.00"


                            }
                            else
                            {
                                
                                if self.cartListModel?.cartListData?.cart?.grandTotal == "0" ||  self.cartListModel?.cartListData?.cart?.grandTotal == "" ||  self.cartListModel?.cartListData?.cart?.grandTotal == nil
                                {
                                    self.lblSubTotal.text = ""
                                
                                }
                                else
                                {
                                    
                                    
                                    let iPricerate = self.ConvertCurrencyFormat(sNumber: Double((self.cartListModel?.cartListData?.cart?.grandTotal!)!)! as NSNumber)
                                    let result1 = String(iPricerate.dropFirst())
                                    
                                    self.lblSubTotal.text = (self.cartListModel?.cartListData?.cart?.currency!)! + " " + result1

                              
                                }
                              
                                
                              
                                
                                
                                if self.cartListModel?.cartListData?.cart?.grandTotal == "0" ||  self.cartListModel?.cartListData?.cart?.grandTotal == "" ||  self.cartListModel?.cartListData?.cart?.grandTotal == nil
                                {
                                    self.lblGrandTotal.text = ""
                                
                                }
                                else
                                {
                                    
                                    
                                    let iPricerate2 = self.ConvertCurrencyFormat(sNumber: Double((self.cartListModel?.cartListData?.cart?.grandTotal!)!)! as NSNumber)
                                    let result12 = String(iPricerate2.dropFirst())
                                    self.lblGrandTotal.text = (self.cartListModel?.cartListData?.cart?.currency!)! + " " + result12

                              
                                }
                              
                                
                              
                                
                                
                                
                               

                            }
                            

                        print("AddressNew",self.userdefaults.string(forKey: "Address") as Any)

                            
                            if (self.cartListModel?.cartListData?.cartItems!.count)!>0
                            {
                                self.cartID = self.cartListModel?.cartListData?.cartItems![0].cartId! as! String
                            }
                            
                            
                            
                            if self.cartList.count == 0
                            {

                                self.viewBGNoPdt.isHidden = false
                                self.tabBarController?.tabBar.items![2].badgeValue = nil
                                
                                    
                                        
                                        
                                        var postDict = Dictionary<String,String>()

                                        postDict = [
                                            "access_token":self.sharedData.getAccessToken()
                                            
                                        ]
                                        print("PostData: ",postDict)
                                        let loginURL = Constants.baseURL+Constants.clearCartURL
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
                                                    self.addToCartModel = AddToCartModel(response)
                                                    let statusCode = Int((self.addToCartModel?.httpcode)!)
                                                    if statusCode == 200{
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
                                                        {
                                                          
                                                            let sharedData = SharedDefault()
                                                            sharedData.clearOperatorID()
                                                            sharedData.clearOperatorName()
                                                            
                                                            
                                                            self.tabBarController?.tabBar.items![2].badgeValue = nil

                                                        }
                                                    }
                                
                                                    
                                                }
                                                catch let err {
                                                    print("Error::",err.localizedDescription)
                                                }
                                            }
                                        }
                                    
                            }
                            else
                            {
                                self.viewBGNoPdt.isHidden = true
                                self.viewScrollBG.isHidden = false
                                self.tabBarController?.tabBar.items![2].badgeValue = String(self.cartList.count)
                            }
                            
                            for item in self.cartList{
                                print("item qty",
                                      item.productQuantity!)
                                print("item price", item.productTotal!)
           
                                
                            }
                            
                            print("cartListModelcartListModel",self.cartListModel?.cartListData?.address?.addressId!.count as Any)
                            if (self.cartListModel?.cartListData?.address?.addressId!.count)!>0
                            {
                            let sName = (self.cartListModel?.cartListData?.address?.name)! as String

                            let sAdressType = (self.cartListModel?.cartListData?.address?.addressType)! as String
                            let stxtFlatNo = (self.cartListModel?.cartListData?.address?.houseFlat)!  as String
                            let stxtRoadName = (self.cartListModel?.cartListData?.address?.roadName)!  as String
                            let sCity = (self.cartListModel?.cartListData?.address?.city)!  as String

                            let stxtLandmark = (self.cartListModel?.cartListData?.address?.landmark)!  as String
                                var sCountry = (self.cartListModel?.cartListData?.address?.country)!  as String
                            let stxtZipcode = (self.cartListModel?.cartListData?.address?.zip)!  as String

                                let stxtZipcode1 = (self.cartListModel?.cartListData?.address?.defaultField)!  as String

                                
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

                              let sAddress =    sName + "," + sAdressType + "," + stxtFlatNo + "," + stxtRoadName + "," + sCity + "," + stxtLandmark + "," + sCountry + ","  +  stxtZipcode + ","  +  stxtZipcode1
                                
                                self.sDeliveredAddress =  sName + "," + stxtFlatNo + "," + stxtRoadName + "," + sCity + "," + stxtLandmark + "," + sCountry + ","  +  stxtZipcode
                                
                                self.sharedData.setAddress(loginStatus: sAddress)

                            }
                            else
                            {
                                self.sharedData.setAddress(loginStatus: "")

                            }
                            
                        self.sharedData.setAddressID(loginStatus: (self.cartListModel?.cartListData?.address?.addressId)!  as String)

                            if self.sharedData.getAddress().count > 1
                            {
                                

                                self.lblAddress.text = self.sDeliveredAddress
                                self.lblChangeAddress.text = "Change Address"
                            }
                            else
                            {
                                self.lblAddress.text = ""
                                self.lblChangeAddress.text = "Add Address"
                            }
                            
                            
                            self.tableCartItems.reloadData()
                            self.view.activityStopAnimating()
                            
                            if self.operatorID.count>0
                            {
                                print("1234567890")
                                self.getShipFee()
                            }
                            
//                        }
                    }
                    if statusCode == 400{
//                        self.showToast(message: (self.cartListModel?.message)!)
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
    @IBAction func btnChangeAddrAction(_ sender: UIButton)
    {
        if self.lblChangeAddress.text == "Change Address"
        {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "AddressListVC") as! AddressListVC
            next.sAddresData = "My Delivery Address"
            next.sProductCurrency = self.sCurrency
            next.sEditAdreessFromBag = true

            self.navigationController?.pushViewController(next, animated: true)
        }
        else
        {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "AddNewAddressVC") as! AddNewAddressVC
            self.sharedData.setZipCode(loginStatus:"")
            next.sProductCurrency = ""
            next.sEditAdreessFromBag = true

            self.navigationController?.pushViewController(next, animated: true)
        }
        print("sender.test",sender.titleLabel?.text)
        
               
    }
    
    
    
    @IBAction func btnShippingAddressChangedAction(_ sender: Any)
    {
        
        
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            // Get the new view controller using segue.destination.
//            // Pass the selected object to the new view controller.
//            if segue.identifier == "SegueToYourTabBarController" {
//                if let destVC = segue.destination as? YourTabBarController {
//                    destVC.selectedIndex = 0
//                }
//            }
}
extension Locale {
    static let currency: [String: (String?)] = isoRegionCodes.reduce(into: [:]) {
        let locale = Locale(identifier: identifier(fromComponents: [NSLocale.Key.countryCode.rawValue: $1]))
//        $0[$1] = (locale.currencyCode, locale.currencySymbol, locale.localizedString(forCurrencyCode: locale.currencyCode ?? ""))
        
        $0[$1] = (locale.currencyCode)

    }
}
