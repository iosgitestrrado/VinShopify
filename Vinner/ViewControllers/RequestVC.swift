//
//  RequestVC.swift
//  Vinner
//
//  Created by softnotions on 21/07/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import ImageSlideshow

import MobileCoreServices
import Alamofire
import SwiftyJSON
import CoreLocation
import AlamofireImage
class RequestVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var btnService: UIButton!
    @IBOutlet weak var btnDemo: UIButton!
    @IBOutlet weak var viewTDemo: UIView!
    @IBOutlet weak var viewTService: UIView!
    @IBOutlet weak var viewService: UIView!
    @IBOutlet weak var viewDemo: UIView!
    @IBOutlet weak var viewPageTopViewBG: UIView!
    @IBOutlet weak var viewRequest: UIView!
    @IBOutlet weak var viewCat: UIView!
    @IBOutlet weak var btnCatSeeAll: UIButton!
    @IBOutlet weak var btnFeatPdtSeeAll: UIButton!
    @IBOutlet weak var collectionReqProduct: UICollectionView!
    @IBOutlet weak var collectionReqCategory: UICollectionView!
    @IBOutlet weak var imgSlideShow: ImageSlideshow!
    @IBOutlet weak var viewPdt: UIView!
    let sharedData = SharedDefault()
    var sCategoryName = String()

    let categoryName = ["Cleaning","Protection","Air Purifiers","Hand Care","Sanitization"]
    var sdImageSource = [SDWebImageSource]()
    var homeResponseModel: HomeResponseModel?
    var pdtListResponseModel: PdtListResponseModel?
    var pdtList = [PdtListData]()
    
    var bannerList = [BannerSlider]()
    var feturedList = [Featured]()
    var categoryList = [Categories]()
      
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.navigationBar.topItem?.title = "Request"
        //viewRequest.animShow()
        
        topBool = false
        self.navigationController?.navigationBar.topItem?.title = ""
        viewRequest.layer.cornerRadius = 25
        viewRequest.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        viewDemo.layer.cornerRadius = 25
        viewService.layer.cornerRadius = 25
        viewDemo.layer.borderWidth = 1
        viewService.layer.borderWidth = 1
        
        viewDemo.layer.borderColor = UIColor(red: 59.0/255.0, green: 160.0/255.0, blue: 13.0/255.0, alpha: 1.0).cgColor
        viewService.layer.borderColor = UIColor(red: 59.0/255.0, green: 160.0/255.0, blue: 13.0/255.0, alpha: 1.0).cgColor

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        viewPageTopViewBG.addGestureRecognizer(tap)
        
        let layouts = MyLeftCustomFlowLayout()
                      layouts.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
                      self.collectionReqCategory.collectionViewLayout = layouts
        
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil)
    {
        // handling code
        print("handleTap")
        self.tabBarController?.selectedIndex = 0
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
        
        
        let pageIndicator = UIPageControl()
        pageIndicator.frame = CGRect(x: pageIndicator.frame.origin.x, y: pageIndicator.frame.origin.y, width: pageIndicator.frame.size.width, height: 0)
        pageIndicator.currentPageIndicatorTintColor = UIColor.white
        pageIndicator.pageIndicatorTintColor = UIColor.lightGray
        pageIndicator.layer.cornerRadius = 10.0
        pageIndicator.sizeToFit()
        imgSlideShow.pageIndicator = pageIndicator
        self.navigationController?.navigationBar.isHidden = false
        imgSlideShow.layer.borderWidth = 1.5
        imgSlideShow.layer.borderColor = Constants.borderColor.cgColor
        imgSlideShow.layer.cornerRadius = 5.0
        imgSlideShow.contentScaleMode = .scaleToFill
        imgSlideShow.slideshowInterval = 2.0
        /*
            imgSlideShow.setImageInputs([ImageSource(image: UIImage(named: "Image0")!),
                                     ImageSource(image: UIImage(named: "Image1")!),
                                     ImageSource(image: UIImage(named: "Image2")!),
                                     ImageSource(image: UIImage(named: "Image3")!)
            
        ])
 */
        self.getHomeContent()
    }
    func getHomeContent(){
        //self.view.activityStartAnimating()
        var postDict = Dictionary<String,String>()
        postDict = [
          "access_token":sharedData.getAccessToken(),
          "country_code":sharedData.getCountryCode()
        ]
        print(postDict)
        let loginURL = Constants.baseURL+Constants.homeURL
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
                    self.homeResponseModel = HomeResponseModel(response)
                    let statusCode = Int((self.homeResponseModel?.httpcode)!)
                    if statusCode == 200{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.bannerList = (self.homeResponseModel?.homeData?.bannerSlider!)!
                            self.categoryList = (self.homeResponseModel?.homeData?.categories!)!
                            self.feturedList = (self.homeResponseModel?.homeData?.featured!)!
                            self.collectionReqProduct.reloadData()
                            self.collectionReqCategory.reloadData()
                            print("self.bannerList --",self.bannerList.count)
                            print("self.categoryList --",self.categoryList.count)
                            print("self.feturedList --",self.feturedList.count)
                            var imageArray = [String]()
                            
                            for img in self.bannerList{
                                imageArray.append(img.sliderImage!)
                            }
                            /*
                            self.imgSlideShow.setImageInputs([ImageSource(image: UIImage(named: "banner")!),
                                                         ImageSource(image: UIImage(named: "banner")!),
                                                         ImageSource(image: UIImage(named: "banner")!),
                                                         ImageSource(image: UIImage(named: "banner")!)
                                
                            ])
                            */
                            
                            
                            for img in imageArray{
                                self.sdImageSource.append(SDWebImageSource(urlString: img)!)
                            }
                            
                            self.imgSlideShow.setImageInputs(self.sdImageSource)
                                self.view.activityStopAnimating()
                            
                        }
                    }
                    if statusCode == 400{
                        self.view.activityStopAnimating()
                        self.showToast(message: (self.homeResponseModel?.message)!)
                    }
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var countVar:Int = 0
        if collectionView == collectionReqCategory {
            countVar = categoryName.count
        } else if collectionView == collectionReqProduct {
            countVar = self.feturedList.count
        }
        return countVar
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: ((self.view.frame.size.width/2) - 10), height: 215)
        }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if collectionView == collectionReqCategory
        {
            let categoryCCell = collectionReqCategory.dequeueReusableCell(withReuseIdentifier: "CategoryRequestCCell", for: indexPath as IndexPath) as! CategoryRequestCCell
            categoryCCell.viewImgBG.layer.cornerRadius = 20
            categoryCCell.lblCatName.text = categoryName[indexPath.row]
            cell = categoryCCell
            
        }
        else if collectionView == collectionReqProduct
        {
            let productListCCell = collectionReqProduct.dequeueReusableCell(withReuseIdentifier: "ProductListRequestCCell", for: indexPath as IndexPath) as! ProductListRequestCCell
            
            
            
            if  self.feturedList[indexPath.row].current_stock == "0"
            {
                print("Out of stack")
                
                productListCCell.viewOutOfStock.isHidden = false
                
                productListCCell.viewOutOfStock.backgroundColor = UIColor.white.withAlphaComponent(0.7)
                
                productListCCell.viewOutStock.layer.shadowColor = UIColor.black.cgColor
                productListCCell.viewOutStock.layer.shadowOpacity = 0.2
                productListCCell.viewOutStock.layer.shadowOffset = .zero
                productListCCell.viewOutStock.layer.shadowRadius = 10
                productListCCell.viewOutStock.layer.cornerRadius = 5.0
                productListCCell.viewOutStock.layer.shadowPath = UIBezierPath(rect: productListCCell.viewOutStock.bounds).cgPath
                productListCCell.viewOutStock.layer.shouldRasterize = true
                productListCCell.imgPdt.sd_setImage(with: URL(string: self.feturedList[indexPath.row].prdImage!), placeholderImage: UIImage(named: "Transparent"))
                
                if self.feturedList[indexPath.row].rating == ""
                {
                    productListCCell.ratingView.rating = 0.0

                }
                else
                {
                    productListCCell.ratingView.rating = Double(self.feturedList[indexPath.row].rating!)!

                }
                productListCCell.lblPdtName.text = self.feturedList[indexPath.row].prdName!
                
                
                self.sCategoryName = self.feturedList[indexPath.row].prdName!
                
                productListCCell.lblPdtName.text = self.sCategoryName.capitalized
                
                
                print("Capitalized Wordings",self.sCategoryName.capitalized)
                
    //            productListCCell.lblQty.text = self.feturedList[indexPath.row].qty! + " " + self.feturedList[indexPath.row].unit!
                
                if self.feturedList[indexPath.row].price == "0" || self.feturedList[indexPath.row].price?.count == 0
                {
                    productListCCell.lblPdtPrice.text = ""
                }
                else
                {
                    let iPricerate = ConvertCurrencyFormat(sNumber: Double(self.feturedList[indexPath.row].price!) as! NSNumber)
                    let result1 = String(iPricerate.dropFirst())    // "ello"
//                productListCCell.lblQty.text = self.feturedList[indexPath.row].price! + " " + self.feturedList[indexPath.row].currency!
                    productListCCell.lblPdtPrice.text = self.feturedList[indexPath.row].currency! + " " + result1

                }
                print("Out of Stock Product Title is in Home Screen :",self.feturedList[indexPath.row].prdName!)


            }
            else
            {
                productListCCell.viewOutOfStock.isHidden = true

                // cellCategory.imgCategory.sd_setImage(with: URL(string: categoryItems[indexPath.row].categoryImg!), placeholderImage: UIImage(named: ""))
                productListCCell.imgPdt.sd_setImage(with: URL(string: self.feturedList[indexPath.row].prdImage!), placeholderImage: UIImage(named: "Transparent"))
                
                
                if self.feturedList[indexPath.row].rating == ""
                {
                    productListCCell.ratingView.rating = 0.0

                }
                else
                {
                    productListCCell.ratingView.rating = Double(self.feturedList[indexPath.row].rating!)!

                }
                
                productListCCell.lblPdtName.text = self.feturedList[indexPath.row].prdName!
                self.sCategoryName = self.feturedList[indexPath.row].prdName!
                
                productListCCell.lblPdtName.text = self.sCategoryName.capitalized
                
                
    //            productListCCell.lblQty.text = self.feturedList[indexPath.row].qty! + " " + self.feturedList[indexPath.row].unit!
                
                if self.feturedList[indexPath.row].price == "0" || self.feturedList[indexPath.row].price?.count == 0
                {
                    productListCCell.lblPdtPrice.text = ""
                }
                else
                {
                    let iPricerate = ConvertCurrencyFormat(sNumber: Double(self.feturedList[indexPath.row].price!) as! NSNumber)
                    let result1 = String(iPricerate.dropFirst())    // "ello"

//                    productListCCell.lblQty.text = self.feturedList[indexPath.row].price! + " " + self.feturedList[indexPath.row].currency!
                    
                    productListCCell.lblPdtPrice.text = self.feturedList[indexPath.row].currency! + " " + result1

                }

    //            productListCCell.lblPdtPrice.text = self.feturedList[indexPath.row].price! + " " + self.feturedList[indexPath.row].currency!
            }
            
            
            
            
//            productListCCell.imgPdt.sd_setImage(with: URL(string: self.feturedList[indexPath.row].prdImage!), placeholderImage: UIImage(named: "Transparent"))
//            productListCCell.lblPdtName.text = self.feturedList[indexPath.row].prdName!
//
//            if self.feturedList[indexPath.row].price == "0" || self.feturedList[indexPath.row].price?.count == 0
//            {
//                productListCCell.lblPdtPrice.text = ""
//            }
//            else
//            {
//                let iPricerate = ConvertCurrencyFormat(sNumber: Double(self.feturedList[indexPath.row].price!) as! NSNumber)
//                let result1 = String(iPricerate.dropFirst())    // "ello"
////                productListCCell.lblQty.text = self.feturedList[indexPath.row].price! + " " + self.feturedList[indexPath.row].currency!
//                productListCCell.lblPdtPrice.text = self.feturedList[indexPath.row].currency! + " " + result1
//
//            }
            
            productListCCell.viewBG.layer.borderWidth = 1.0
            productListCCell.viewBG.layer.borderColor = Constants.borderColor.cgColor
            productListCCell.viewBG.layer.cornerRadius = 5.0
            cell = productListCCell
            
        }
        
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        
        if collectionView == collectionReqCategory {
            
        } else  if collectionView == collectionReqProduct {
                   
               }
        
    }
    
     // MARK: - Btn Actions
    
    
    @IBAction func btnFPdtSeeAllAction(_ sender: UIButton) {
        print("btnFPdtSeeAllAction")
    }
    
    @IBAction func btnCatSeeAllAction(_ sender: UIButton) {
        print("btnCatSeeAllAction")
    }
    @IBAction func btnDemoAction(_ sender: UIButton) {
        print("btnDemoAction")
        let next = self.storyboard?.instantiateViewController(withIdentifier: "RequestDemoVC") as! RequestDemoVC
        self.navigationController?.pushViewController(next, animated: true)
    }
    @IBAction func btnServicesAction(_ sender: UIButton) {
        print("btnServicesAction")
        let next = self.storyboard?.instantiateViewController(withIdentifier: "RequestServicesVC") as! RequestServicesVC
        self.navigationController?.pushViewController(next, animated: true)
        
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
