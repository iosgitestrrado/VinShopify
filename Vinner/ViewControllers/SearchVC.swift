//
//  SearchVC.swift
//  Vinner
//
//  Created by softnotions on 28/07/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire
import SwiftyJSON

class SearchVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate {
    @IBOutlet weak var viewNoPdt: UIView!
    @IBOutlet weak var collectionProduct: UICollectionView!
    
    @IBOutlet weak var lblCategoryName: UILabel!
    
    @IBOutlet weak var collectionTopConstrains: NSLayoutConstraint!
    var pdtListResponseModel: PdtListResponseModel?
    var pdtList = [PdtListData]()
    var sharedData = SharedDefault()
    private let refreshControl = UIRefreshControl()
    var searchText:String?
    var categoryID:String?
    var categoryName:String?
    var sProductName = String()
    var bScroll = Bool()
     var industryID:String?
    var offset:Int = 0
    var dragStatus:Int = 0
    /*
     type 0 search
     type 1 category
     type 2 industry
     */
    var callType:String?
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var countVar:Int = 0
        if collectionView == collectionProduct {
            countVar = self.pdtList.count
        }
        return countVar
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if collectionView == collectionProduct
        {
            
            
            
            
            let productListCCell = collectionProduct.dequeueReusableCell(withReuseIdentifier: "ProductListCCell", for: indexPath as IndexPath) as! ProductListCCell
            productListCCell.viewBG.layer.borderWidth = 1.0
            productListCCell.viewBG.layer.borderColor = Constants.borderColor.cgColor
            productListCCell.viewBG.layer.cornerRadius = 5.0
            
            if self.pdtList.count > 0
            {

            
            if  self.pdtList[indexPath.row].current_stock == "0"
            {
                print("Out of stack")
                
                productListCCell.viewOutOfStockSearch.isHidden = false
                productListCCell.viewOutOfStockSearch.backgroundColor = UIColor.white.withAlphaComponent(0.7)
                productListCCell.viewSEarchOutStock.layer.shadowColor = UIColor.black.cgColor
                productListCCell.viewSEarchOutStock.layer.shadowOpacity = 0.2
                productListCCell.viewSEarchOutStock.layer.shadowOffset = .zero
                productListCCell.viewSEarchOutStock.layer.shadowRadius = 10
                productListCCell.viewSEarchOutStock.layer.cornerRadius = 5.0
                productListCCell.viewSEarchOutStock.layer.shadowPath = UIBezierPath(rect: productListCCell.viewSEarchOutStock.bounds).cgPath
                productListCCell.viewSEarchOutStock.layer.shouldRasterize = true
                
                productListCCell.imgPdt.sd_setImage(with: URL(string: self.pdtList[indexPath.row].productImage!), placeholderImage: UIImage(named: "Transparent"))
//                productListCCell.lblPdt.text = self.pdtList[indexPath.row].productTitle!
                
                self.sProductName = self.pdtList[indexPath.row].productTitle!
                
                productListCCell.lblPdt.text = self.sProductName.capitalized
                
    
                    if self.pdtList[indexPath.row].price == "0"
                    {
                        productListCCell.lblQty.text = ""
                    }
                    else
                    {
                   
//                        productListCCell.lblQty.text = self.pdtList[indexPath.row].price! + " " + self.pdtList[indexPath.row].currency!
                        let iPricerate = ConvertCurrencyFormat(sNumber: Double(self.pdtList[indexPath.row].price!) as! NSNumber)
                        let result1 = String(iPricerate.dropFirst())    // "ello"
                        
                        productListCCell.lblQty.text = self.pdtList[indexPath.row].currency! + " " + result1

                    }
                
                let iRating = self.pdtList[indexPath.row].rating!
                
                if iRating == ""
                {
                    productListCCell.ProductRatingView.rating = Double("0.0")!

                }
                else
                {
                    productListCCell.ProductRatingView.rating = Double(self.pdtList[indexPath.row].rating!)!

                }
            
     
                print("Out of Stock Product Title is :",self.pdtList[indexPath.row].productTitle!)
            }
            else
            {
                productListCCell.viewOutOfStockSearch.isHidden = true

            
            productListCCell.imgPdt.sd_setImage(with: URL(string: self.pdtList[indexPath.row].productImage!), placeholderImage: UIImage(named: "Transparent"))
            productListCCell.lblPdt.text = self.pdtList[indexPath.row].productTitle!
                
                
                self.sProductName = self.pdtList[indexPath.row].productTitle!
                
                productListCCell.lblPdt.text = self.sProductName.capitalized
                
                
                if self.pdtList[indexPath.row].price == "0"
                {
                    productListCCell.lblQty.text = ""
                }
                else
                {
//                productListCCell.lblQty.text = self.pdtList[indexPath.row].price! + " " + self.pdtList[indexPath.row].currency!
                    let iPricerate = ConvertCurrencyFormat(sNumber: Double(self.pdtList[indexPath.row].price!) as! NSNumber)
                    let result1 = String(iPricerate.dropFirst())    // "ello"
                    
                    productListCCell.lblQty.text = self.pdtList[indexPath.row].currency! + " " + result1
                }
            
            let iRating = self.pdtList[indexPath.row].rating!
            
            if iRating == ""
            {
                productListCCell.ProductRatingView.rating = Double("0.0")!

            }
            else
            {
                productListCCell.ProductRatingView.rating = Double(self.pdtList[indexPath.row].rating!)!

            }
                        
 
            }
            }
            cell = productListCCell

        }
        
        
        return cell
    }
    
    
    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        var val = view.bounds.width/2.0
//        val = val.rounded()
//        print("Val")
//        print(val)
//        return CGSize(width: 100, height: 100)
//    }
//    
//    
    
    
    
    // MARK: - UICollectionViewDelegate protocol
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
//    {
//        return 15
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
            return CGSize(width: (collectionView.frame.width/2) - 3, height: collectionView.frame.width/2 - 3)
       
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        if collectionView == collectionProduct
        {
            
            if self.pdtList.count > 0
            {
                
        
            
            if  self.pdtList[indexPath.row].current_stock == "0"
            {
                print("Out of stack")
//                self.showToast(message: "Out of stack")
                
            }
            else
            {
//                if self.pdtList[indexPath.row].price == "0" || self.pdtList[indexPath.row].price == ""
//                {
//                    print("No Price")
//                    self.showToast(message: "Currently the product is not for sale")
//
//                }
//                else
//                {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
            next.productID = self.pdtList[indexPath.row].productId!
            self.navigationController?.pushViewController(next, animated: true)
//                }
            }
            }
        }
        
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //Bottom Refresh

        if scrollView == collectionProduct {

            
            bScroll = true

            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
//                if searchText.text == ""
//                {
                print("bottomRefresh ----------------------------------> ")
//                if callType == "3"
//                {
//                    dragStatus = 1
//                    offset = offset + 10
//                    refreshControl.endRefreshing()
//                    self.GetAllFeaturedProducts()
//                }
//                else
//                {
//                    dragStatus = 1
//                    offset = offset + 10
//                    refreshControl.endRefreshing()
//                    self.getProductList()
//
//                }
                
                if callType == "0"
                {
                    dragStatus = 1
                    offset = offset + 10
                    refreshControl.endRefreshing()
                    self.getProductList()
                }
                else if callType == "1"
                {
                    dragStatus = 1
                    offset = offset + 10
                    refreshControl.endRefreshing()
                    self.getBrowseCat()
                }
                else if callType == "2"
                {
                    dragStatus = 1
                    offset = offset + 10
                    refreshControl.endRefreshing()
                    self.getBrowseIndustry()
                }
                else if callType == "3"
                {
                    dragStatus = 1
                    offset = offset + 10
                    refreshControl.endRefreshing()
                    self.GetAllFeaturedProducts()
                }
                
                
                print("ofsetValue ----------------------------------> ")

//                }
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        self.pdtList.removeAll()

        self.navigationController?.navigationBar.topItem?.titleView = nil
        self.navigationController?.navigationBar.topItem?.title = ""

        let searchBar = UISearchBar()
        searchBar.placeholder = " Search..."
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.tintColor = .white
        searchBar.alwaysShowCancelButton()
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .black

        
        self.navigationController?.navigationBar.topItem?.titleView = searchBar
        
        let cancelButtonAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.black]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(cancelButtonAttributes, for: .normal)
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {

            textfield.backgroundColor = UIColor.white
            textfield.font = UIFont.systemFont(ofSize: 15)
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])

            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.black
            }
           
        }
        
        
        
        
        if #available(iOS 10.0, *)
        {
            collectionProduct.refreshControl = refreshControl
        }
        else
        {
            collectionProduct.addSubview(refreshControl)
        }
        // Configure Refresh Control
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        refreshControl.tintColor = UIColor.clear
        
       
        self.navigationController?.navigationBar.topItem?.title = ""
        
        
        if callType == "0"
        {
            self.pdtList.removeAll()

            self.lblCategoryName.isHidden = true
            collectionTopConstrains.constant = 10
            self.getProductList()
        }
        else if callType == "1"
        {
            self.pdtList.removeAll()

            collectionTopConstrains.constant = 35
            self.lblCategoryName.isHidden = false
            self.getBrowseCat()
        }
        else if callType == "2"
        {
            self.pdtList.removeAll()

            collectionTopConstrains.constant = 35
            self.lblCategoryName.isHidden = false
            self.getBrowseIndustry()
        }
        else if callType == "3"
        {
            self.pdtList.removeAll()

            self.lblCategoryName.isHidden = true
            collectionTopConstrains.constant = 10
            self.GetAllFeaturedProducts()
        }
        
    }
    override func viewWillAppear(_ animated: Bool)
    {
        print("Search viewWillAppear ")
        bScroll = false
        self.lblCategoryName.text = categoryName
        self.addBackButton(title: "")

        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
         layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
         let width = UIScreen.main.bounds.width
         layout.itemSize = CGSize(width: width/2 , height: width/2 )
         layout.minimumInteritemSpacing = 5
         layout.minimumLineSpacing = 5
        self.collectionProduct.collectionViewLayout = layout
    }
    override func viewDidLoad()
    {
        print("Search viewDidLoad ")

        super.viewDidLoad()
        self.addBackButton(title: "")

    
    }
    @objc private func refreshData(_ sender: Any)
    {
        bScroll = true
        

        if callType == "0"
        {
            dragStatus = 1
            offset = offset + 10
            refreshControl.endRefreshing()
            self.getProductList()
        }
        else if callType == "1"
        {
            dragStatus = 1
            offset = offset + 10
            refreshControl.endRefreshing()
            self.getBrowseCat()
        }
        else if callType == "2"
        {
            dragStatus = 1
            offset = offset + 10
            refreshControl.endRefreshing()
            self.getBrowseIndustry()
        }
        else if callType == "3"
        {
            dragStatus = 1
            offset = offset + 10
            refreshControl.endRefreshing()
            self.GetAllFeaturedProducts()
        }
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchText.isEmpty {
            
            self.viewNoPdt.isHidden = true
            self.pdtList.removeAll()
            if callType == "3"
            {
                self.GetAllFeaturedProducts()

            }
            else
            {
                self.getProductList()

            }
            
            if callType == "0"
            {
                
                self.getProductList()
            }
            else if callType == "1"
            {
               
                self.getBrowseCat()
            }
            else if callType == "2"
            {
                self.getBrowseIndustry()
            }
            else if callType == "3"
            {
                self.GetAllFeaturedProducts()

            }
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//
//            }
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        print("Search bar",searchBar.text!)
        searchBar.resignFirstResponder()
        searchText = searchBar.text!
        self.pdtList.removeAll()
//        self.searchProduct()
        
        if callType == "0"
        {
            
            self.searchProduct()
        }
        else if callType == "1"
        {
           
            self.getBrowseCatSearch()
        }
        else if callType == "2"
        {
            self.getBrowseIndustrySearch()
        }
        else if callType == "3"
        {
            self.searchFeateredProduct()

        }
        
        
    }
          func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
          {
//            searchBar.text = ""
            self.viewNoPdt.isHidden = true

            searchBar.resignFirstResponder()
            searchBar.endEditing(true)

            if searchBar.text?.count == 0
            {
                self.navigationController?.popViewController(animated: true)
            }
            else
            {
            self.pdtList.removeAll()
            if callType == "3"
            {
                self.GetAllFeaturedProducts()

            }
            else
            {
                self.getProductList()

            }
            
            if callType == "0"
            {
                
                self.getProductList()
            }
            else if callType == "1"
            {
               
                self.getBrowseCat()
            }
            else if callType == "2"
            {
                self.getBrowseIndustry()
            }
            else if callType == "3"
            {
                self.GetAllFeaturedProducts()

            }
                searchBar.alwaysShowCancelButton()

            }
            
          }
    func searchProduct(){
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = [
            "search":searchText!,
            "country_code":sharedData.getCountyName()
        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.searchURL
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
                    self.pdtListResponseModel = PdtListResponseModel(response)
                    let statusCode = Int((self.pdtListResponseModel?.httpcode)!)
                    if statusCode == 200{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            
                            self.pdtList = self.pdtListResponseModel!.pdtListData!
                            if self.pdtList.count > 0
                            {
                                print("self.self.pdtList ----- ",self.pdtList)
                                self.collectionProduct .reloadData()
                            }
                          else
                            {
                                self.showToast(message: (self.pdtListResponseModel?.message)!)
                                self.viewNoPdt.isHidden = false
                            }
                            self.view.activityStopAnimating()
                        }
                    }
                    if statusCode == 400{
                        self.view.activityStopAnimating()
                        self.viewNoPdt.isHidden = false
                        self.showToast(message: (self.pdtListResponseModel?.message)!)
                    }
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    
    func searchFeateredProduct(){
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = [
            "search":searchText!,
            "country_code":sharedData.getCountyName()
        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.featured_product_searchURL
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
                    self.pdtListResponseModel = PdtListResponseModel(response)
                    let statusCode = Int((self.pdtListResponseModel?.httpcode)!)
                    if statusCode == 200{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            
                            self.pdtList = self.pdtListResponseModel!.pdtListData!
                            if self.pdtList.count > 0
                            {
                                print("self.self.pdtList ----- ",self.pdtList)
                                self.collectionProduct .reloadData()
                            }
                          else
                            {
                                self.showToast(message: (self.pdtListResponseModel?.message)!)
                                self.viewNoPdt.isHidden = false
                            }
                            self.view.activityStopAnimating()
                        }
                    }
                    if statusCode == 400{
                        self.view.activityStopAnimating()
                        self.viewNoPdt.isHidden = false
                        self.showToast(message: (self.pdtListResponseModel?.message)!)
                    }
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    
    
    func getProductList(){
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = [
            "limit":"10",
            "offset": String(offset),
            "country_code":sharedData.getCountyName()

        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.productListURL
        print("loginURL",loginURL)
        
        AF.request(loginURL, method: .post, parameters: postDict, encoding: URLEncoding.default, headers: nil).responseJSON { [self] (data) in
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
                    self.pdtListResponseModel = PdtListResponseModel(response)
                    let statusCode = Int((self.pdtListResponseModel?.httpcode)!)
                    if statusCode == 200{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            if self.dragStatus == 1
                            {
                                self.pdtList.append(contentsOf: self.pdtListResponseModel!.pdtListData!)
                            }
                            else
                            {
                                self.pdtList = self.pdtListResponseModel!.pdtListData!
                                
                            }
                            if self.pdtList.count > 0
                            {
                                print("self.self.pdtList ----- ",self.pdtList)
                                self.collectionProduct .reloadData()
                            }
                          else
                            {
                                self.showToast(message: (self.pdtListResponseModel?.message)!)
                                self.viewNoPdt.isHidden = false
                            }

                            self.view.activityStopAnimating()
                        }
                        

                    }
                    if statusCode == 400{
                        
                        if !self.bScroll
                        {
                            self.showToast(message: (self.pdtListResponseModel?.message)!)
                            self.viewNoPdt.isHidden = false
                        }
                        self.view.activityStopAnimating()

                    }
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    func getBrowseCat(){
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = [
            "country_code": sharedData.getCountyName(),
            "category_id": self.categoryID!

        ]
        //"category_id": self.categoryID!
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.browseCatURL
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
                    self.pdtListResponseModel = PdtListResponseModel(response)
                    let statusCode = Int((self.pdtListResponseModel?.httpcode)!)
                    if statusCode == 200{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.pdtList = self.pdtListResponseModel!.pdtListData!
                            if self.pdtList.count > 0
                            {
                                print("self.self.pdtList ----- ",self.pdtList)
                                self.collectionProduct .reloadData()
                            }
                          else
                            {
                                self.showToast(message: (self.pdtListResponseModel?.message)!)
                                self.viewNoPdt.isHidden = false
                            }
                        }
                    }
                    if statusCode == 400{
                        if !self.bScroll
                        {
                        self.showToast(message: (self.pdtListResponseModel?.message)!)
                        self.viewNoPdt.isHidden = false
                        }
                    }
                    self.view.activityStopAnimating()
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    func getBrowseCatSearch(){
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = [
            "country_code": sharedData.getCountyName(),
            "category_id": self.categoryID!,
            "search": searchText!

        ]
        //"category_id": self.categoryID!
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.category_product_searchURL
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
                    self.pdtListResponseModel = PdtListResponseModel(response)
                    let statusCode = Int((self.pdtListResponseModel?.httpcode)!)
                    if statusCode == 200{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.pdtList = self.pdtListResponseModel!.pdtListData!
                            if self.pdtList.count > 0
                            {
                                print("self.self.pdtList ----- ",self.pdtList)
                                self.collectionProduct .reloadData()
                            }
                          else
                            {
                                self.showToast(message: (self.pdtListResponseModel?.message)!)
                                self.viewNoPdt.isHidden = false
                            }
                        }
                    }
                    if statusCode == 400{
                        self.showToast(message: (self.pdtListResponseModel?.message)!)
                        self.viewNoPdt.isHidden = false
                    }
                    self.view.activityStopAnimating()
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    func getBrowseIndustry(){
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = [
            "country_code": sharedData.getCountyName(),
            "industry_id": self.industryID!

        ]
        //"category_id": self.categoryID!
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.browseIndustryURL
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
                    self.pdtListResponseModel = PdtListResponseModel(response)
                    let statusCode = Int((self.pdtListResponseModel?.httpcode)!)
                    if statusCode == 200{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.pdtList = self.pdtListResponseModel!.pdtListData!
                            if self.pdtList.count > 0
                            {
                                print("self.self.pdtList ----- ",self.pdtList)
                                self.collectionProduct .reloadData()
                            }
                          else
                            {
                                self.showToast(message: (self.pdtListResponseModel?.message)!)
                                self.viewNoPdt.isHidden = false
                            }
                        }
                    }
                    if statusCode == 400{
                        if !self.bScroll
                        {
                        self.showToast(message: (self.pdtListResponseModel?.message)!)
                        self.viewNoPdt.isHidden = false
                        }
                    }
                    self.view.activityStopAnimating()
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    
    
    func getBrowseIndustrySearch(){
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = [
            "country_code": sharedData.getCountyName(),
            "industry_id": self.industryID!,
            "search": searchText!


        ]
        //"category_id": self.categoryID!
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.industry_product_searchURL
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
                    self.pdtListResponseModel = PdtListResponseModel(response)
                    let statusCode = Int((self.pdtListResponseModel?.httpcode)!)
                    if statusCode == 200{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.pdtList = self.pdtListResponseModel!.pdtListData!
                            
                            if self.pdtList.count > 0
                            {
                                print("self.self.pdtList ----- ",self.pdtList)
                                self.collectionProduct .reloadData()
                            }
                          else
                            {
                                self.showToast(message: (self.pdtListResponseModel?.message)!)
                                self.viewNoPdt.isHidden = false
                            }
                        }
                    }
                    if statusCode == 400{
                        self.showToast(message: (self.pdtListResponseModel?.message)!)
                        self.viewNoPdt.isHidden = false
                    }
                    self.view.activityStopAnimating()
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    
    
    
    func GetAllFeaturedProducts(){
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = [
            "limit":"10",
            "offset": String(offset),
            "country_code":sharedData.getCountyName()

        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.featured_product
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
                    self.pdtListResponseModel = PdtListResponseModel(response)
                    let statusCode = Int((self.pdtListResponseModel?.httpcode)!)
                    if statusCode == 200{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            if self.dragStatus == 1
                            {
                                self.pdtList.append(contentsOf: self.pdtListResponseModel!.pdtListData!)
                            }
                            else
                            {
                                self.pdtList = self.pdtListResponseModel!.pdtListData!
                                
                            }
                            if self.pdtList.count > 0
                            {
                                print("self.self.pdtList ----- ",self.pdtList)
                                self.collectionProduct .reloadData()
                            }
                          else
                            {
                                self.showToast(message: (self.pdtListResponseModel?.message)!)
                                self.viewNoPdt.isHidden = false
                            }

                            self.view.activityStopAnimating()
                        }
                        

                    }
                    if statusCode == 400{
                        self.view.activityStopAnimating()

                        if !self.bScroll
                        {
                        self.showToast(message: (self.pdtListResponseModel?.message)!)
                        self.viewNoPdt.isHidden = false
                        }
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
extension UISearchBar {
  func alwaysShowCancelButton() {
    for subview in self.subviews {
      for ss in subview.subviews {
        if #available(iOS 13.0, *) {
          for s in ss.subviews {
            self.enableCancel(with: s)
          }
        }else {
          self.enableCancel(with: ss)
        }
      }
    }
  }
  private func enableCancel(with view:UIView) {
   if NSStringFromClass(type(of: view)).contains("UINavigationButton") {
      (view as! UIButton).isEnabled = true
    }
  }
}
