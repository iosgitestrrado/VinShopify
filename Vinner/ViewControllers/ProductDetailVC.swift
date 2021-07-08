//
//  ProductDetailVC.swift
//  Vinner
//
//  Created by softnotions on 22/07/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import SDWebImage
import Cosmos
import MobileCoreServices
import Alamofire
import SwiftyJSON
import ImageSlideshow

import FBSDKShareKit

import BraintreeDropIn
import Braintree

class ProductDetailVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, SharingDelegate,BTViewControllerPresentingDelegate,BTAppSwitchDelegate  {
    let braintreeToken = "sandbox_gpf95mc9_3zj8334nxfxh8nrs"
    var braintreeClient: BTAPIClient?
    @IBOutlet weak var pdtTotalRatingView: CosmosView!
    @IBOutlet weak var lblPdtTotalRatingCount: UILabel!
    
    @IBOutlet weak var lblProductHeight: UILabel!
    @IBOutlet weak var lblProductWidth: UILabel!
    @IBOutlet weak var lblProductLength: UILabel!
    @IBOutlet weak var lblProductWeight: UILabel!
    @IBOutlet weak var lblReturnPolicy: UILabel!
    @IBOutlet weak var lbltotalCustRating: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblCustReviewDetail: UILabel!
    @IBOutlet weak var lblCustReviewTitle: UILabel!
    @IBOutlet weak var lblCustReviewName: UILabel!
    @IBOutlet weak var cusRating: CosmosView!
    @IBOutlet weak var lblCustReviewDate: UILabel!

    @IBOutlet weak var stackViewButtons: UIStackView!
    var productID:String?
    var CurrentStock:String?
    var product_url:String?

    var bPriceZero:Bool?
    var bEnableAddToCartOrBuyNow:Bool?
   var iRating = Double()
    var sProductName = String()
    var iCurrentStatusCount = Int()
    var cartListModel : CartListModel?
    var cartList = [CartItems]()
    var cartProductStockModel : CartProductsStockModel?
    var cartProductStockList = [CartProductsStockData]()

    var pdtDetailResponseModel : ProductDetailResponseModel?
    let sharedData = SharedDefault()
    var addToCartModel : AddToCartModel?
    var imageArray = [String]()
    @IBOutlet weak var scrollReturn: UIScrollView!
    @IBOutlet weak var viewReturnPolicy: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    var sdImageSource = [SDWebImageSource]()
    
    @IBOutlet weak var collectionProduct: UICollectionView!
    
    @IBOutlet weak var btnBuyNow: UIButton!
    @IBOutlet weak var btnAddToCart: UIButton!
    @IBOutlet weak var lblDescData: UILabel!
    @IBOutlet weak var lblDesctption: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var btnReturnPolicy: UIButton!
    @IBOutlet weak var lblPdtName: UILabel!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var imgProduct: ImageSlideshow!
    @IBOutlet weak var viewScrollBG: UIView!
    @IBOutlet weak var scrollProduct: UIScrollView!
    var pdtReviews = [Reviews]()
    var relatedPdts = [RelatedProducts]()
    
    
    let tab = TabBarController()
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var countVar:Int = 0
        if collectionView == collectionProduct {
            countVar = self.relatedPdts.count
        }
        return countVar
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if collectionView == collectionProduct {
            let productListCCell = collectionProduct.dequeueReusableCell(withReuseIdentifier: "RelatedPdtCCell", for: indexPath as IndexPath) as! RelatedPdtCCell
            productListCCell.viewBG.layer.borderWidth = 1.0
            productListCCell.viewBG.layer.borderColor = Constants.borderColor.cgColor
            productListCCell.viewBG.layer.cornerRadius = 5.0
            productListCCell.imgPdt.sd_setImage(with: URL(string: self.relatedPdts[indexPath.row].productImage!), placeholderImage: UIImage(named: "Transparent"))
//            productListCCell.lblPdtName.text = self.relatedPdts[indexPath.row].productTitle!
            
            
            self.sProductName = self.relatedPdts[indexPath.row].productTitle!
            
            productListCCell.lblPdtName.text = self.sProductName.capitalized
            
            
            productListCCell.lblQty.text = self.relatedPdts[indexPath.row].prdQty! + " " + self.relatedPdts[indexPath.row].unit!
            
            if self.relatedPdts[indexPath.row].price == "0" || self.relatedPdts[indexPath.row].price == "" || self.relatedPdts[indexPath.row].price == nil
            {
                productListCCell.lblPdtPrice.text = ""

            }
            else
            
            {
                
                
                let iPricerate = self.ConvertCurrencyFormat(sNumber: Double(self.relatedPdts[indexPath.row].price!)! as NSNumber)
                let result1 = String(iPricerate.dropFirst())    //
//                productListCCell.lblPdtPrice.text = self.relatedPdts[indexPath.row].price!  + " " + self.relatedPdts[indexPath.row].currency!
                productListCCell.lblPdtPrice.text = self.relatedPdts[indexPath.row].currency!  + " " + result1


            }
            
            
            if self.relatedPdts[indexPath.row].rating! == ""
            {
                productListCCell.ratingView.rating = Double("0")!

            }
            else
            {
                productListCCell.ratingView.rating = Double(self.relatedPdts[indexPath.row].rating!)!

            }
            
            
            cell = productListCCell
            
            
            //productListCCell.lblPdt.text = self.relatedPdts[indexPath.row].productTitle!
            //productListCCell.imgPdt.sd_setImage(with: URL(string: self.relatedPdts[indexPath.row].productImage!), placeholderImage: UIImage(named: "Transparent"))
            // productListCCell.lblPdt.text = self.relatedPdts[indexPath.row].productTitle
            //productListCCell.lblPdtPrice.text = self.relatedPdts[indexPath.row].price! + " " + self.relatedPdts[indexPath.row].currency!
            
            //productListCCell.lblPrice.text = self.relatedPdts[indexPath.row].price! + " " + self.relatedPdts[indexPath.row].currency!
            
            //productListCCell.ratingView.rating = 0.0
            //productListCCell.ratingView.rating = Double(self.relatedPdts[indexPath.row].rating!)!
            
            //productListCCell.lblQty.text = self.relatedPdts[indexPath.row].prdQty
            //productListCCell.lblQty.text = self.relatedPdts[indexPath.row].prdQty! + " " + self.relatedPdts[indexPath.row].unit!
            
            
            
            
            //productListCCell.ratingView.rating = Double(self.relatedPdts[indexPath.row].rating!)!
            //productListCCell.lblPdt.text = self.relatedPdts[indexPath.row].productTitle!
            //productListCCell.lblQty.text = self.relatedPdts[indexPath.row].prdQty! + " " + self.relatedPdts[indexPath.row].unit!
            //productListCCell.lblPdtPrice.text = self.relatedPdts[indexPath.row].price! + " " + self.relatedPdts[indexPath.row].currency!
            
            //categoryBGColor
            
            
        }
        
        
        return cell
    }
    func addToCart()
    {
        
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        postDict = [
            "product_id":productID! as String,
            "access_token":sharedData.getAccessToken(),
            "country_code": sharedData.getCountyName()
            
        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.addToCartURL
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            print("response ",response)
                            self.showToast(message: (self.addToCartModel?.message)!)
                            UserDefaults.standard.setValue("No", forKey: "CartCleared")
                            self.iCurrentStatusCount = self.iCurrentStatusCount + 1
                            
                            self.GetCartList()
//                            self.GetCurrentStockUpdates()
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
    
    func getProductDetail(){
        self.view.activityStartAnimating()
        
        var postDict = Dictionary<String,String>()
        //21 "product_id":productID! as String,
        postDict = [
            "product_id":productID! as String,
            "access_token":sharedData.getAccessToken(),
            "country_code": sharedData.getCountyName()

            
        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.productDetailURL
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
                    self.pdtDetailResponseModel = ProductDetailResponseModel(response)
                    let statusCode = Int((self.pdtDetailResponseModel?.httpcode)!)
                    if statusCode == 200{
                        
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
//                        {
                            print("response ",response)
                            
                            self.CurrentStock = self.pdtDetailResponseModel?.productDetailData?.product?.current_stock
                            self.lblProductHeight.text = (self.pdtDetailResponseModel?.productDetailData?.product?.height!)! +  " " + (self.pdtDetailResponseModel?.productDetailData?.product?.dimension_unit!)!
                            self.lblProductWidth.text = (self.pdtDetailResponseModel?.productDetailData?.product?.width!)! + " " + (self.pdtDetailResponseModel?.productDetailData?.product?.dimension_unit!)!
                            self.lblProductLength.text = (self.pdtDetailResponseModel?.productDetailData?.product?.length)! + " " + (self.pdtDetailResponseModel?.productDetailData?.product?.dimension_unit!)!
                            self.lblProductWeight.text = (self.pdtDetailResponseModel?.productDetailData?.product?.weight)! + " " + (self.pdtDetailResponseModel?.productDetailData?.product?.weight_unit!)!
                            
                            
                            
                            self.product_url = self.pdtDetailResponseModel?.productDetailData?.product?.product_url
                            
                            if self.pdtDetailResponseModel?.productDetailData?.product?.current_stock == "0"
                            {
                                
                               self.showToast(message: "Out of stock")

                            }
                          else
                            
                            {
                            self.lblCategory.text =  self.pdtDetailResponseModel?.productDetailData?.product?.category!
                            self.lblPdtName.text = self.pdtDetailResponseModel?.productDetailData?.product?.productName!
                                
                                self.sProductName = (self.pdtDetailResponseModel?.productDetailData?.product?.productName!)!
                                
                                self.lblPdtName.text = self.sProductName.capitalized
                                
                                
                                if self.pdtDetailResponseModel?.productDetailData?.product?.return_policy == "" || self.pdtDetailResponseModel?.productDetailData?.product?.return_policy == "No Return Policy"
                                {
                                    
                                   self.showToast(message: "No Return Policy available for this product")
                                    
                                   let sReturnPolicy  = "No Return Policy available for "

                                    self.lblReturnPolicy.text  =  sReturnPolicy + (self.pdtDetailResponseModel?.productDetailData?.product?.productName!)!

                                }
                                else
                                {
                                    self.lblReturnPolicy.text  = self.pdtDetailResponseModel?.productDetailData?.product?.return_policy

                                }
                            var str:String? = self.pdtDetailResponseModel?.productDetailData?.product?.description!.convertHtmlToNSAttributedString?.string
                            //let boldFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
                            let normalFontAttributes = [NSAttributedString.Key.foregroundColor:UIColor(red: 201.0/255.0, green: 201.0/255.0, blue: 201.0/255.0, alpha: 1.0), NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
                                
                                let normalFontAttributes1 = [NSAttributedString.Key.foregroundColor:UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]

                            
                            let partTwo = NSMutableAttributedString(string: str!, attributes: normalFontAttributes1)
                            let combination = NSMutableAttributedString()
                            
                            combination.append(partTwo)
                            self.lblDescData.attributedText = combination
                            
                                // Changes by Praveen
                                
                                if self.pdtDetailResponseModel?.productDetailData?.product?.price == "0" ||  self.pdtDetailResponseModel?.productDetailData?.product?.price == "" ||  self.pdtDetailResponseModel?.productDetailData?.product?.price == nil
                                {
                                    self.lblPrice.text = ""
                                    self.bPriceZero = true
                                    self.stackViewButtons.isHidden  = true
                                }
                                
                                else
                                {
                                    
                                    
                                    let iPricerate = self.ConvertCurrencyFormat(sNumber: Double((self.pdtDetailResponseModel?.productDetailData?.product?.price!)!)! as NSNumber)
                                    let result1 = String(iPricerate.dropFirst())    // "ello"
                                    
                                    self.lblPrice.text =  (self.pdtDetailResponseModel?.productDetailData?.product?.currency!)! + " " + result1

//                                    self.lblPrice.text =  (self.pdtDetailResponseModel?.productDetailData?.product?.price!)! + " " + (self.pdtDetailResponseModel?.productDetailData?.product?.currency!)!
                                    
                                    
                                    self.stackViewButtons.isHidden  = false

                                    self.bPriceZero = false
                                    

                                }
                                
                                
                                
                                
                                
                                if self.pdtDetailResponseModel?.productDetailData?.product?.rating == ""
                                {
                                    self.ratingView.rating = Double("0")!
                                    self.pdtTotalRatingView.rating = Double("0")!
                                    self.iRating = 0.0


                                }
                                else
                                {
                                    self.iRating = Double((self.pdtDetailResponseModel?.productDetailData?.product?.rating!)!)!

                                    self.ratingView.rating = Double((self.pdtDetailResponseModel?.productDetailData?.product?.rating!)!)!
                                self.pdtTotalRatingView.rating = Double((self.pdtDetailResponseModel?.productDetailData?.product?.rating!)!)!
                                    
                                }
                            
                              

                            self.imageArray.removeAll()
                            
                            self.imageArray = (self.pdtDetailResponseModel?.productDetailData?.product?.productImage!)!
                            
                            for img in self.imageArray{
                                self.sdImageSource.append(SDWebImageSource(urlString: img)!)
                            }
                            
                            self.imgProduct.setImageInputs(self.sdImageSource)
                            
                            self.relatedPdts = (self.pdtDetailResponseModel?.productDetailData?.relatedProducts)!
                            self.pdtReviews = (self.pdtDetailResponseModel?.productDetailData?.reviews)!
                            self.collectionProduct.reloadData()
                            
                            
                            if self.pdtReviews.count>0
                            {
//                                self.lblCustReviewName.text = self.pdtReviews[0].user
//                                self.lblCustReviewTitle.text = self.pdtReviews[0].reviewTitle
//                                self.lblCustReviewDetail.text = self.pdtReviews[0].review
//                                self.lblCustReviewDate.text = self.pdtReviews[0].reviewDate
//                                var strRating:String = self.pdtReviews[0].rating!
//
//                                self.cusRating.rating = Double(strRating)!
                                
                            }
                            
                            self.lbltotalCustRating.text = String(self.pdtReviews.count)
                            var totalRating:Int? = 0
                            for item in self.pdtReviews{
                                let temp = item.rating
                                
                                totalRating = totalRating! + (temp as! NSString).integerValue
                                print("item tot",totalRating)
                            }
                            
                                // costomer review
                          // Changed on 15-02-2021
//                            if self.pdtReviews.count>0
//                            {
//                                self.lblPdtTotalRatingCount.text = String(totalRating!/self.pdtReviews.count) + " out of 5"
//                                self.pdtTotalRatingView.rating = Double(totalRating!/self.pdtReviews.count)
//                            }
//                            else
//                            {
//                                self.lblPdtTotalRatingCount.text =  " 0 out of 5"
//                                self.pdtTotalRatingView.rating = 0.0
//                            }
//
                            }
//
                            // Changed on 15-02-2021

                            self.view.activityStopAnimating()
//                        }
                    }
                    if statusCode == 400{
                        self.showToast(message: (self.pdtDetailResponseModel?.message)!)
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
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        if collectionView == collectionProduct {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
            next.productID = self.relatedPdts[indexPath.row].productId! as String
            //next.productID = self.pdtList[indexPath.row].productId! as String
            self.navigationController?.pushViewController(next, animated: true)
        }
        
    }
    @objc func didTapSearchButton()
    {

        let next = self.storyboard?.instantiateViewController(withIdentifier: "BagVC") as! BagVC
        self.navigationController?.pushViewController(next, animated: true)
        
       }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.bEnableAddToCartOrBuyNow = true
        iCurrentStatusCount = 0
        self.iRating = 0.0
        self.navigationController?.navigationBar.topItem?.titleView = nil


        self.addBackButton(title: "Product Detail")

                BTAppSwitch.setReturnURLScheme("com.vinshopify.vinner.payments")


                // Do any additional setup after loading the view.
                
                braintreeClient = BTAPIClient(authorization: braintreeToken)!
                
                //navigationController?.navigationBar.topItem?.hidesBackButton = true
                viewReturnPolicy.isHidden = true
                btnCancel.layer.cornerRadius = 10.0
                viewReturnPolicy.layer.cornerRadius = 10.0
                viewReturnPolicy.layer.borderWidth = 1.0
                viewReturnPolicy.layer.borderColor = Constants.borderColor.cgColor
                

                
                let pageIndicator = UIPageControl()
                pageIndicator.frame = CGRect(x: pageIndicator.frame.origin.x, y: pageIndicator.frame.origin.y, width: pageIndicator.frame.size.width, height: 0)
                pageIndicator.currentPageIndicatorTintColor = UIColor.white
                pageIndicator.pageIndicatorTintColor = UIColor.lightGray
                pageIndicator.layer.cornerRadius = 10.0
                pageIndicator.sizeToFit()
                self.imgProduct.pageIndicator = pageIndicator
                self.navigationController?.navigationBar.isHidden = false
                self.imgProduct.layer.borderWidth = 1.5
                self.imgProduct.layer.borderColor = Constants.borderColor.cgColor
                self.imgProduct.layer.cornerRadius = 5.0
                self.imgProduct.contentScaleMode = .scaleAspectFit
                self.imgProduct.slideshowInterval = 2.0
                
                self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "NavBG"), for: UIBarMetrics.default)
                btnShare.layer.cornerRadius = 0.5 * btnShare.bounds.size.width
                btnShare.clipsToBounds = true
                
                btnReturnPolicy.layer.cornerRadius = 5
                btnReturnPolicy.clipsToBounds = true
                
                btnBuyNow.layer.cornerRadius = 10
                btnReturnPolicy.clipsToBounds = true
                btnAddToCart.layer.cornerRadius = 10
                btnReturnPolicy.clipsToBounds = true
                self.stackViewButtons.isHidden  = true

                self.getProductDetail()
        let saccessToken = UserDefaults.standard.value(forKey: "access_token") as! String
        
        if saccessToken.count>0
        {
            navigationItem.rightBarButtonItem = nil
            self.GetCartList()

        }
                let layouts = MyLeftCustomFlowLayout()
                layouts.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
                layouts.scrollDirection = .horizontal
                self.collectionProduct.collectionViewLayout = layouts
                
                let height = self.collectionProduct.collectionViewLayout.collectionViewContentSize.height
                //self.collectionProduct.collectionViewLayout.heightConstraint.height
                self.heightConstraint.constant = height
                
        //        self.stackViewButtons.isHidden = true
                
            }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iCurrentStatusCount = 0
        self.navigationController?.navigationBar.topItem?.titleView = nil
        self.iRating = 0.0
        

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = self.collectionProduct.collectionViewLayout.collectionViewContentSize.height
        //self.collectionProduct.collectionViewLayout.heightConstraint.height
        self.heightConstraint.constant = height
        self.view.layoutIfNeeded()
    }
    // MARK: - Actions
    
    @IBAction func btnShowAllReviewAction(_ sender: UIButton) {
        
        /*
         if self.pdtReviews.count>0{
         self.lblCustReviewName.text = self.pdtReviews[0].user
         self.lblCustReviewTitle.text = self.pdtReviews[0].reviewTitle
         self.lblCustReviewDetail.text = self.pdtReviews[0].review
         self.lblCustReviewDate.text = self.pdtReviews[0].reviewDate
         var strRating:String = self.pdtReviews[0].rating!
         
         self.cusRating.rating = Double(strRating)!
         
         }
         
         self.lbltotalCustRating.text = String(self.pdtReviews.count)
         var totalRating:Int? = 0
         for item in self.pdtReviews{
         let temp = item.rating
         
         totalRating = totalRating! + (temp as! NSString).integerValue
         print("item tot",totalRating)
         }
         print("item tot",totalRating!/self.pdtReviews.count)
         
         self.lblPdtTotalRatingCount.text = String(totalRating!/self.pdtReviews.count) + " out of 5"
         self.pdtTotalRatingView.rating = Double(totalRating!/self.pdtReviews.count)
         */
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "ShowAllReviewVC") as! ShowAllReviewVC
        next.reviewList = self.pdtReviews
        next.iRating = self.iRating
        self.navigationController?.pushViewController(next, animated: true)
        
        
    }
    @IBAction func btnBuyNowAction(_ sender: UIButton)
    {
        
        
        if bEnableAddToCartOrBuyNow == false
        {
            showToast(message: "Out of stock")

        }
        else
        {
        if CurrentStock == "0"
        {
            showToast(message: "Out of stock")
        }
        else
        {
            let iCurrentStCount = Int(CurrentStock!)
            if iCurrentStCount == self.iCurrentStatusCount
            {
                showToast(message: "Out of stock")

            }
            
            else
            {
            if self.bPriceZero == true
            {
                showToast(message: "Currently the product is not for sale")
            }
            else
            {
                
                if !sharedData.getLoginStatus()
                {

                    let alert = UIAlertController(title: Constants.appName, message: Constants.signInMessage, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                    
                    let next = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController

                    self.navigationController?.pushViewController(next, animated: true)
                   
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
                    print("Cancel")
                    

                }))
                self.present(alert, animated: true, completion: nil)
                
            }
                else
                {
                    self.addToCart()
                    let next = self.storyboard?.instantiateViewController(withIdentifier: "BagVC") as! BagVC
                    self.navigationController?.pushViewController(next, animated: true)
                    
                }

            }
            
        }
        }
            
        }
        
    }
    @IBAction func btnAddToCartAction(_ sender: UIButton)
    {
        //let next = self.storyboard?.instantiateViewController(withIdentifier: "BagVC") as! BagVC
        //self.navigationController?.navigationBar.topItem?.title = "Bag"
        // self.navigationController?.pushViewController(next, animated: true)
        /*
         var pdtStatus: Int = 0
         for item in myCart {
         if self.pdtDetailResponseModel?.productDetailData?.product?.productId! == item.productId {
         pdtStatus = 1
         self.showToast(message: Constants.pdtRepeatMsg)
         
         }
         }
         if pdtStatus == 0 {
         myCart.append((self.pdtDetailResponseModel?.productDetailData?.product)!)
         self.showToast(message: Constants.pdtAddSuccessMsg)
         }
         */
        
        
        
        if self.bEnableAddToCartOrBuyNow == false
        {
            showToast(message: "Out of stock")

        }
        else
        {
        
        if CurrentStock == "0"
        {
            showToast(message: "Out of stock")
        }
        else
        {
            let iCurrentStCount = Int(CurrentStock!)
            if iCurrentStCount == self.iCurrentStatusCount
            {
                showToast(message: "Out of stock")

            }
            
            else
            {
            if self.bPriceZero == true
            {
                showToast(message: "Currently the product is not for sale")
            }
            else
            {
                
                if !sharedData.getLoginStatus()
                {

                    let alert = UIAlertController(title: Constants.appName, message: Constants.signInMessage, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                    
                    let next = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController

                    self.navigationController?.pushViewController(next, animated: true)
                   
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
                    print("Cancel")
                    

                }))
                self.present(alert, animated: true, completion: nil)
                
            }
                else
                {
                    self.addToCart()
//                    let next = self.storyboard?.instantiateViewController(withIdentifier: "BagVC") as! BagVC
//                    self.navigationController?.pushViewController(next, animated: true)
                    
                }

            }
            }
        }
        }
    }
    @IBAction func btnRetPolicyAction(_ sender: UIButton)
    {
        viewReturnPolicy.isHidden = false
        //self.startCheckout()
        
        //self.showDropIn(clientTokenOrTokenizationKey: braintreeToken)
    }
    @IBAction func btnShareAction(_ sender: UIButton)
    {
        print("DasSasaSass")
//        let alert = UIAlertController(title: "Share", message: "", preferredStyle: .actionSheet)
//
//        alert.addAction(UIAlertAction(title: "Facebook", style: .default, handler: { action in
//
//
//
//            self.shareTextOnFaceBook(sText: self.product_url!)
//
//
//        }))
//
//        alert.addAction(UIAlertAction(title: "WhatsApp", style: .default, handler: { action in
//
//            self.shareOnWhatsApp()
//        }))
//        alert.addAction(UIAlertAction(title: "Other", style: .default, handler: { action in
//
//            self.ShareTextOnOtherApps(sText: "")
//        }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//
//        self.present(alert, animated: true)
        
        
        
        
        let url = URL(string: self.product_url!)!
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(vc, animated: true)
        
    }
    
    
    
    func ShareTextOnOtherApps(sText:String)
    {
        let text = self.product_url
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare as [Any] , applicationActivities: nil)
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
    
    
    
    
    func shareOnWhatsApp() {
        var imgurl :String?
        if imageArray.count > 0
        {
            
            imgurl = imageArray[0]
        }
        else
        {
            imgurl = ""
        }
//        let urlString = "whatsapp://send?text=" + imgurl! + " " + self.lblDescData.text!
        
        
        
        
        let urlString = "whatsapp://send?text=" + self.product_url!
        
        
        print("urlString ",urlString)
        
//        let urlStringEncoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//
//        let URL = NSURL(string: urlStringEncoded!)
//        if #available(iOS 10.0, *) {
//            UIApplication.shared.open(URL! as URL, options: [:], completionHandler: nil)
//        }
//        else {
//            UIApplication.shared.openURL(URL! as URL)
//        }
        
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
                    let webURL = URL(string: self.product_url!)
                    
                    if #available(iOS 10.0, *)
                    {
                        UIApplication.shared.open(webURL!, options: [:], completionHandler: nil)
                    }
                    else
                    {
                        UIApplication.shared.openURL(webURL!)
                    }
                    
                   print("Cannot open whatsapp")
                  self.showToast(message: "Whatsapp not installed")
                    
                }
            }
        }
        
    }
//    func shareTextOnFaceBook()
//    {
//
//        let shareContent = ShareLinkContent()
////        if imageArray.count > 0
////        {
////
////            shareContent.contentURL = URL.init(string:  self.imageArray[0])! //your link
////        }
//        shareContent.contentURL = URL.init(string:  self.product_url!)! //your link
//
//        shareContent.quote = self.lblDescData.text
//        ShareDialog(fromViewController: self, content: shareContent, delegate: self).show()
//    }
    
    
    
    
    
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
    @IBAction func btnCancelAction(_ sender: UIButton) {
        viewReturnPolicy.isHidden = true
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func showDropIn(clientTokenOrTokenizationKey: String) {
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request)
        { (controller, result, error) in
            if (error != nil) {
                print("ERROR")
            } else if (result?.isCancelled == true) {
                print("CANCELLED")
            } else if let result = result {
                // Use the BTDropInResult properties to update your UI
                // result.paymentOptionType
                // result.paymentMethod
                // result.paymentIcon
                // result.paymentDescription
            }
            controller.dismiss(animated: true, completion: nil)
        }
        self.present(dropIn!, animated: true, completion: nil)
    }
    
    func startCheckout() {
        // Example: Initialize BTAPIClient, if you haven't already
        //braintreeClient = BTAPIClient(authorization: braintreeToken)!
        
        let payPalDriver = BTPayPalDriver(apiClient: braintreeClient!)
        payPalDriver.viewControllerPresentingDelegate = self
        payPalDriver.appSwitchDelegate = self // Optional
        
        // Specify the transaction amount here. "2.32" is used in this example.
        let request = BTPayPalRequest(amount: "1.32")
        request.currencyCode = "USD"//USD//AED // Optional; see BTPayPalRequest.h for more options
        
        payPalDriver.requestOneTimePayment(request) { (tokenizedPayPalAccount, error) in
            if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
                
                // Access additional information
                let email = tokenizedPayPalAccount.email
                let firstName = tokenizedPayPalAccount.firstName
                let lastName = tokenizedPayPalAccount.lastName
                let phone = tokenizedPayPalAccount.phone
                
                // See BTPostalAddress.h for details
                let billingAddress = tokenizedPayPalAccount.billingAddress
                let shippingAddress = tokenizedPayPalAccount.shippingAddress
            } else if let error = error {
                // Handle error here...
            } else {
                // Buyer canceled payment approval
            }
        }
    }
    
    // MARK: - BTViewControllerPresentingDelegate
    
    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
        //present(viewController, animated: true, completion: nil)
    }
    
    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        //viewController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - BTAppSwitchDelegate
    
    
    // Optional - display and hide loading indicator UI
    func appSwitcherWillPerformAppSwitch(_ appSwitcher: Any) {
        
    }
    
    func appSwitcherWillProcessPaymentInfo(_ appSwitcher: Any) {
        
    }
    
    func appSwitcher(_ appSwitcher: Any, didPerformSwitchTo target: BTAppSwitchTarget) {
        
    }
    
    // MARK: - Private methods
    
    func showLoadingUI() {
        // ...
    }
    
    @objc func hideLoadingUI() {
        
    }
    
    
    
    
    
    
    func GetCartList()
    {
        
       
        
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
                            
                            
                            if self.cartList.count > 0
                            {
                            let badgeCount = UILabel(frame: CGRect(x: 15, y: -05, width: 20, height: 20))
                            badgeCount.layer.borderColor = UIColor.clear.cgColor
                            badgeCount.layer.borderWidth = 2
                            badgeCount.layer.cornerRadius = badgeCount.bounds.size.height / 2
                            badgeCount.textAlignment = .center
                            badgeCount.layer.masksToBounds = true
                            badgeCount.textColor = .white
                            badgeCount.font = badgeCount.font.withSize(12)
                            badgeCount.backgroundColor = .red
                            badgeCount.text = String(self.cartList.count)

                            let rightBarButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))

                            rightBarButton.setImage(UIImage(named: "NewCartSmall"), for: .normal)

                            rightBarButton.addTarget(self, action: #selector(self.didTapSearchButton), for: .touchUpInside)
                            rightBarButton.addSubview(badgeCount)


                            let rightBarButtomItem = UIBarButtonItem(customView: rightBarButton)
                                self.navigationItem.rightBarButtonItem = rightBarButtomItem
                            }
                            else
                            {
                                self.navigationItem.rightBarButtonItem = nil

                            }
                            
                            
                            
                            
                            
                            
                            for item in self.cartList{
                                print("item qty",
                                      item.productQuantity!)
                                print("item price", item.productTotal!)
                                //print("productTotal --- ",Int(item.productQuantity!)!*Int(item.productTotal!)!)
                                
//                                self.sArrayCurrentStock.append(item.current_stock)
//                                self.getProductDetail(sProductId: item.productId!)
                                
                                
                                if item.productId == self.productID
                                {
                                    print("Same products")
                                    
                                    print("Current Stock", item.current_stock)
                                    
                                    print("Product Count" , item.productQuantity!)
                                    
                                    let iProductCount = Int(item.productQuantity!)

                                    let iCurrentCount = Int(item.current_stock)
                                    
                                    let iCount = iCurrentCount! - iProductCount!

                                    if iCount <= 0
                                    {
                                        self.bEnableAddToCartOrBuyNow = false
                                    }
                                    else
                                    
                                    {
                                        print("Not Equel")

                                    }
                                    
                                }

                                
//                            }
                            
                        
                    }
                    if statusCode == 400{
                    }
                    }
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
        
    }
    
    
    
    func GetCurrentStockUpdates()
    {
        
       
        
        var postDict = Dictionary<String,String>()
        postDict = [
            "access_token":sharedData.getAccessToken()
            
        ]
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.cartProductStockURL
        print("loginURL",loginURL)
        
        AF.request(loginURL, method: .post, parameters: postDict, encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
            print("Response getCartList :***:",data.description)
            
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
                    self.cartProductStockModel = CartProductsStockModel(response)
                    let statusCode = Int((self.cartProductStockModel?.httpcode)!)
                    if statusCode == 200{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
                            print("response ",response)
                            
                            self.cartProductStockList = (self.cartProductStockModel?.cartProductsStockData)!
                            var iCount:Int = 0
                            var iCount1 = Int()

                            
                            
                            if self.cartProductStockList.count > 0
                            {
                            
                            for item in self.cartProductStockList
                            {
                               
//                                self.lblCount.text = item.qty
                            }
                            }
                            else
                            {
                                
                                
                            }
                        
                    }
                    
                    }
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
        
    }
    
    
    
}
