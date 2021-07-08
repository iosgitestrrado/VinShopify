//
//  BrowseVC.swift
//  Vinner
//
//  Created by softnotions on 21/07/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire
import SwiftyJSON

class BrowseVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var indListModel: IndustryListModel?
    var catListModel: CategoryListModel?
    
    @IBOutlet weak var viewIndustryHeight: NSLayoutConstraint!
    @IBOutlet weak var viewCatHeight: NSLayoutConstraint!
    var categoryList = [CategoryListData]()
    var industryList = [IndustryListData]()
    var sProductCurrency = String()
    var cartListModel : CartListModel?
    var cartList = [CartItems]()
    var addToCartModel : AddToCartModel?

    @IBOutlet weak var viewIndustry: UIView!
    let sharedData = SharedDefault()
    
    @IBOutlet weak var scrollBrowse: UIScrollView!
    @IBOutlet weak var viewBGScroll: UIView!
    @IBOutlet weak var lblCategoryTitle: UILabel!
    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var collectionCategory: UICollectionView!
    @IBOutlet weak var collectionIndustry: UICollectionView!
    let categoryName = ["Cleaning","Protection","Air Purifiers","Hand Care","Sanitization"]
    let industryName = ["HoReCa","Health Care","Homes","Education","Government","Transportation"]
    var categoryImage = [UIImage]()
    var industryImage = [UIImage]()
    var categoryBGColor = [UIColor]()
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = self.collectionCategory.collectionViewLayout.collectionViewContentSize.height
        self.viewCatHeight.constant = height
        
        let heightIndstry = self.collectionIndustry.collectionViewLayout.collectionViewContentSize.height
        self.viewIndustryHeight.constant = heightIndstry
        
        
        //self.view.layoutIfNeeded()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.navigationBar.topItem?.title = "Browse"
        topBool = false
        
        self.navigationController?.navigationBar.topItem?.title = ""

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        categoryBGColor.append(UIColor(red: 255.0/255.0, green: 237.0/255.0, blue: 237.0/255.0, alpha: 1.0))
        categoryBGColor.append(UIColor(red: 255.0/255.0, green: 240.0/255.0, blue: 180.0/255.0, alpha: 1.0))
        categoryBGColor.append(UIColor(red: 216.0/255.0, green: 194.0/255.0, blue: 252.0/255.0, alpha: 1.0))
        categoryBGColor.append(UIColor(red: 221.0/255.0, green: 255.0/255.0, blue: 163.0/255.0, alpha: 1.0))
        categoryBGColor.append(UIColor(red: 203.0/255.0, green: 255.0/255.0, blue: 255.0/220.0, alpha: 1.0))
        
        categoryImage.append(UIImage(named: "clean")!)
         categoryImage.append(UIImage(named: "protection")!)
         categoryImage.append(UIImage(named: "air")!)
         categoryImage.append(UIImage(named: "hand")!)
         categoryImage.append(UIImage(named: "sanit")!)
        
        
        industryImage.append(UIImage(named: "Industry")!)
        industryImage.append(UIImage(named: "Health")!)
        industryImage.append(UIImage(named: "Home")!)
        industryImage.append(UIImage(named: "Edu")!)
        industryImage.append(UIImage(named: "Gov")!)
        industryImage.append(UIImage(named: "Trans")!)
         
//        let sCartcount = UserDefaults.standard.value(forKey: "cartCount") as! String
//
//        if sCartcount.count > 0
//        {
//            if sCartcount == "0"
//            {
//
//            }
//            else
//            {
//                let saccessToken = UserDefaults.standard.value(forKey: "access_token") as! String
//
//                if saccessToken.count>0
//                {
//                    self.getCartList()
//
//                }
//            }
//
//        }
         self.getCategoryList()
         self.getIndustryList()
        let layout = MyLeftCustomFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.collectionCategory.collectionViewLayout = layout
        
        let layouts = MyLeftCustomFlowLayout()
        layouts.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.collectionIndustry.collectionViewLayout = layouts
        
    }
    override func viewDidAppear(_ animated: Bool)
    {
        

//        let sCartcount = UserDefaults.standard.value(forKey: "cartCount") as! String
//        
//        if sCartcount.count > 0
//        {
//            if sCartcount == "0"
//            {
//
//            }
//            else
//            {
//                let saccessToken = UserDefaults.standard.value(forKey: "access_token") as! String
//                
//                if saccessToken.count>0
//                {
//                    self.getCartList()
//
//                }
//            }
//
//        }
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var countVar:Int = 0
        if collectionView == collectionCategory {
            //countVar = categoryName.count
            countVar = categoryList.count
        }
        else if collectionView == collectionIndustry {
            //countVar = categoryName.count
            countVar = industryList.count
        }
        return countVar
    }
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if collectionView == collectionCategory {
            let categoryCCell = collectionCategory.dequeueReusableCell(withReuseIdentifier: "CategoryCCell", for: indexPath as IndexPath) as! CategoryCCell
            categoryCCell.viewImgBG.layer.cornerRadius = 20
            categoryCCell.viewImgBG.clipsToBounds = true
            categoryCCell.lblCatName.textColor = UIColor(red: 1.0/255.0, green: 99.0/255.0, blue: 168.0/255.0, alpha: 1.0)
            categoryCCell.lblCatName.text = categoryList[indexPath.row].categoryName
            categoryCCell.imgCategory.sd_setImage(with: URL(string: categoryList[indexPath.row].categoryImage!), placeholderImage: UIImage(named: "Transparent"))
            //categoryCCell.viewImgBG.backgroundColor = categoryBGColor[indexPath.row]
           /*
            categoryCCell.imgTop.constant = 10
            categoryCCell.imgLeading.constant = 10
            categoryCCell.imgTrailing.constant = 10
            categoryCCell.imgBottomConstraint.constant = 10
            */
            if UIDevice.current.screenType.rawValue == "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8" {
                categoryCCell.viewHeight.constant = 70
                categoryCCell.viewWidth.constant = 70
            }
            else if UIDevice.current.screenType.rawValue == "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus" {
                //topupCell.widthViewBG.constant = 370
                categoryCCell.viewHeight.constant = 100
                categoryCCell.viewWidth.constant = 100
            }
            else if UIDevice.current.screenType.rawValue == "iPhone XS Max or iPhone Pro Max" {
                //topupCell.widthViewBG.constant = 370
            }
            else if UIDevice.current.screenType.rawValue == "iPhone X or iPhone XS" {
                //topupCell.widthViewBG.constant = 370
                categoryCCell.viewHeight.constant = 100
                categoryCCell.viewWidth.constant = 100
                
            }
            else if UIDevice.current.screenType.rawValue == "iPhone XR or iPhone 11" {
                
                //topupCell.widthViewBG.constant = 370
            }
            else if UIDevice.current.screenType.rawValue == "iPhone XR or iPhone 11" {
                
                //topupCell.widthViewBG.constant = 370
            }
            else {
                //topupCell.widthViewBG.constant = 370
                categoryCCell.viewHeight.constant = 90
                categoryCCell.viewWidth.constant = 90
                
            }
            cell = categoryCCell
            
        }
        else if collectionView == collectionIndustry{
            let industryCCell = collectionIndustry.dequeueReusableCell(withReuseIdentifier: "IndustryCCell", for: indexPath as IndexPath) as! IndustryCCell
            industryCCell.viewBG.layer.cornerRadius = 25
            industryCCell.viewBG.layer.borderWidth = 1
            industryCCell.viewBG.layer.borderColor = UIColor(red: 75.0/255.0, green: 135.0/255.0, blue: 49.0/255.0, alpha: 1.0).cgColor
            industryCCell.lblText.textColor = UIColor(red: 11.0/255.0, green: 91.0/255.0, blue: 178.0/255.0, alpha: 1.0)
            
            industryCCell.lblText.text = industryList[indexPath.row].industryName
            industryCCell.imgIndustry.sd_setImage(with: URL(string: industryList[indexPath.row].industryImage!), placeholderImage: UIImage(named: "Transparent"))
            if UIDevice.current.screenType.rawValue == "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8" {
                
                industryCCell.imgHeight.constant = 70
                industryCCell.imgWidth.constant = 105
            }
            else if UIDevice.current.screenType.rawValue == "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus" {
               industryCCell.imgHeight.constant = 70
               industryCCell.imgWidth.constant = 110
            }
            else if UIDevice.current.screenType.rawValue == "iPhone XS Max or iPhone Pro Max" {
                
            }
            else if UIDevice.current.screenType.rawValue == "iPhone X or iPhone XS" {
                industryCCell.imgHeight.constant = 70
                industryCCell.imgWidth.constant = 105
               
                
            }
            else if UIDevice.current.screenType.rawValue == "iPhone XR or iPhone 11" {
                
                
            }
            
            else {
               
                industryCCell.imgHeight.constant = 70
                industryCCell.imgWidth.constant = 100
            }
            cell = industryCCell
            
        }
       
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        if collectionView == collectionCategory {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
            next.callType = "1"
            next.categoryID = self.categoryList[indexPath.row].categoryId!
            next.categoryName = self.categoryList[indexPath.row].categoryName
            self.navigationController?.pushViewController(next, animated: true)
        }
        else if collectionView == collectionIndustry{
            let next = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
            next.callType = "2"
            next.industryID = self.industryList[indexPath.row].industryId!
            next.categoryName = self.industryList[indexPath.row].industryName
            self.navigationController?.pushViewController(next, animated: true)
        }
        
    }

    
    func getCategoryList(){
        self.view.activityStartAnimating()
        var postDict = Dictionary<String,String>()
        postDict = [
            "access_token":sharedData.getAccessToken()
        ]
  
        let loginURL = Constants.baseURL+Constants.categoryListURL
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
                    self.catListModel = CategoryListModel(response)
                    let statusCode = Int((self.catListModel?.httpcode)!)
                    if statusCode == 200{
                        
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            
                          self.categoryList = (self.catListModel?.categoryListData)!
                          self.collectionCategory.reloadData()
                          self.view.activityStopAnimating()
                            
                         
//                        }
                    }
                    if statusCode == 400{
                      self.view.activityStopAnimating()
                        self.showToast(message: (self.catListModel?.message)!)
                      self.getIndustryList()
                    }
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    func getIndustryList(){
        self.view.activityStartAnimating()
        var postDict = Dictionary<String,String>()
        postDict = [
            "access_token":sharedData.getAccessToken()
        ]
        let loginURL = Constants.baseURL+Constants.industryListURL
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
                    self.indListModel = IndustryListModel(response)
                    let statusCode = Int((self.indListModel?.httpcode)!)
                    if statusCode == 200{
                        
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            
                          self.industryList = (self.indListModel?.industryListData)!
                          self.collectionIndustry.reloadData()
                          self.view.activityStopAnimating()
                            
                            let heightIndstry = self.collectionIndustry.collectionViewLayout.collectionViewContentSize.height
                            self.viewIndustryHeight.constant = heightIndstry
                            
                            
                            self.view.layoutIfNeeded()
//                        }
                    }
                    if statusCode == 400{
                      self.view.activityStopAnimating()
                        self.showToast(message: (self.indListModel?.message)!)
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
                            
                            self.sProductCurrency = (self.cartListModel?.cartListData?.cart?.currency)!
                            
                            print(Locale.currency[self.sharedData.getCountyName()] as Any)
                            
                            let sArrayCurrencyDetails = Locale.currency[self.sharedData.getCountyName()]
                            self.cartList = (self.cartListModel?.cartListData?.cartItems)!
                       
                        
                        if self.cartList.count != 0
                        {
                        if self.sProductCurrency.count > 0
                        {
//                            if self.sProductCurrency != sArrayCurrencyDetails
//                            {
                          
                                
                            
                                
                                if !self.sProductCurrency.contains(sArrayCurrencyDetails!!)
                                {
//
                                let alert = UIAlertController(title: Constants.appName, message: Constants.removeCartMSG, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { _ in
                                    
                                    self.tabBarController?.selectedIndex = 2

                                   
                                }))
                                alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { _ in
                                    print("NO")
                                    
                                    self.RemoveFromCart()

                                }))
                                self.present(alert, animated: true, completion: nil)
                                
                            }
                            }
                        }
                            
                        self.view.activityStopAnimating()

                            
                        
                    }
                    if statusCode == 400
                    {
                        self.showToast(message: (self.cartListModel?.message)!)
                        self.view.activityStopAnimating()
                    }
                    
                }
                catch let err
                {
                    self.view.activityStopAnimating()
                    print("Error::",err.localizedDescription)
                }
            }
        }
        
    }
    
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
                            
                            let sharedData = SharedDefault()
                            sharedData.clearOperatorID()
                            sharedData.clearOperatorName()
                            self.view.activityStopAnimating()
                            self.tabBarController?.tabBar.items![2].badgeValue = nil

                        }
                    }
//                    if statusCode == 400
//                    {
//                        self.showToast(message: (self.addToCartModel?.message)!)
//                        self.view.activityStopAnimating()
//                    }
                    
                }
                catch let err {
                    self.view.activityStopAnimating()
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
}
