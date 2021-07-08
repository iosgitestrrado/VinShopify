//
//  HomeVC.swift
//  Vinner
//
//  Created by softnotions on 19/07/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import ImageSlideshow
import MobileCoreServices
import Alamofire
import SwiftyJSON
import CoreLocation
import AlamofireImage
import iOSDropDown

var topBool:Bool?
class HomeVC:UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var viewCollectionCat: UIView!
    @IBOutlet weak var topScrollConstants: NSLayoutConstraint!
    @IBOutlet weak var collectionProductHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionCatHeight: NSLayoutConstraint!
    var locationManager = CLLocationManager()
     //var dropTextField = UITextField()
    var dropTextField: DropDown!
    var homeResponseModel: HomeResponseModel?
    var pdtListResponseModel: PdtListResponseModel?
    var pdtList = [PdtListData]()
    let sharedData = SharedDefault()
    var bannerList = [BannerSlider]()
    var feturedList = [Featured]()
    var categoryList = [Categories]()
    var regionList = [Regions]()
    var scountryName1 = String()
     var sCartCount = String()
    var sCategoryName = String()
    var scountryName2 = String()
    var iCartCount = Int()
    @IBOutlet weak var lblTiming: UILabel!
    
    var sCountryNameLogin = String()

    
    
    var cartListModel : CartListModel?
    var sProductCurrency = String()
    var imgFlag = UIImageView()
    var itemsNames = ["AE","BH","SA"]
     var itemsImages = ["uae","baharin","saudi"]
      var itemsCode = ["+971","+973","+966"]
    var cartList = [CartItems]()
    var versionModel: VersionModel?

    var timer: Timer?
    var runCount = 0
    
    var imgList = [Image]()
    let img = ["uae","baharin","saudi"]
    
    var addToCartModel : AddToCartModel?

    
    
    var offset:Int = 0
    
    var sdImageSource = [SDWebImageSource]()
    
    @IBOutlet weak var btnCatSeeAll: UIButton!
    @IBOutlet weak var btnFeatPdtSeeAll: UIButton!
    @IBOutlet weak var collectionProduct: UICollectionView!
    @IBOutlet weak var collectionCategory: UICollectionView!
    @IBOutlet weak var imgSlideShow: ImageSlideshow!
    let categoryName = ["Cleaning","Protection","Air Purifiers","Hand Care","Sanitization"]
    
    var categoryImage = [UIImage]()
    var categoryBGColor = [UIColor]()
    
    override func viewDidAppear(_ animated: Bool) {
    
        
        self.iCartCount = 0
        
        self.sCountryNameLogin = sharedData.getCountyName()
        
        
        if topBool == true {
             self.topScrollConstants.constant = 0.0//0
        }
        else {
            self.topScrollConstants.constant = 0.0
        }
        self.addTextfield()

//        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)

        
        self.getHomeContent()

        self.getVersion()

      
    }
//    @objc func fireTimer() {
//        print("Timer fired!")
//        runCount += 1
//        let iresult = "Timing      " + String(runCount)
//
//        self.lblTiming.text = "Timing      " + String(runCount)
//
//        print("Timing :::::,",iresult)
//
//    }
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
         

        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
         layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
         let width = UIScreen.main.bounds.width
         layout.itemSize = CGSize(width: width/2 , height: width/2 )
         layout.minimumInteritemSpacing = 5
         layout.minimumLineSpacing = 5
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        self.collectionProduct.collectionViewLayout = layout
        
        
        
        
        
            
        /*
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
       */
        navigationController?.navigationBar.topItem?.hidesBackButton = true
        
        //self.addBackButton()
        self.navigationController?.navigationBar.topItem?.title = ""
        // Change Praveen
        self.addCustControls()
        
        let countryLocale = NSLocale.current
        let countryCode = countryLocale.regionCode
        let country = (countryLocale as NSLocale).displayName(forKey: NSLocale.Key.countryCode, value: countryCode)!
        print("country", country as String)
        //dropTextField.text = country as String
        if !(UIDevice.isSimulator)
        {
            locationManager.requestWhenInUseAuthorization()
            
            print("LOC",CLLocationManager.authorizationStatus())
            var currentLoc: CLLocation!
            if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() == .authorizedAlways) {
                currentLoc = locationManager.location
                
                let user_lat = String(format: "%f", currentLoc.coordinate.latitude)
                let user_long = String(format: "%f", currentLoc.coordinate.longitude)
                print("user_lat ---",user_lat)
                print("user_long --",user_long)
                
                
            } else {
                locationManager.requestWhenInUseAuthorization()
            }
        }
        
        self.collectionCategory.isScrollEnabled = false
        self.collectionCategory.isPagingEnabled = false

           
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
      
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
         layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
         layout.itemSize = CGSize(width: 100 , height: 157 )
         layout.minimumInteritemSpacing = 5
         layout.minimumLineSpacing = 15
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        self.collectionCategory.collectionViewLayout = layout
        
        
        
        
        
        let btnLeftMenu: UIButton = UIButton()
        let image = UIImage(named: "logo");
        btnLeftMenu.setImage(image, for: .normal)
        btnLeftMenu.setTitle("", for: .normal);
        btnLeftMenu.sizeToFit()
        
        let barButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = barButton
        print("releaseVersionNumber", Bundle.main.releaseVersionNumber as Any)
        print("buildVersionNumber",Bundle.main.buildVersionNumber as Any)

        
       
    }
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()

        
        let height = self.collectionCategory.collectionViewLayout.collectionViewContentSize.height
        self.collectionCatHeight.constant = height
        self.collectionProductHeight.constant = 250

        self.view.layoutIfNeeded()
        
        
    }
    @objc func addTapped() {
        print("addTapped")
    }
    
    @objc func playTapped() {
        print("playTapped")
    }
    func getHomeContent(){
        self.view.activityStartAnimating()
        var postDict = Dictionary<String,String>()
        
        let saccessToken = UserDefaults.standard.value(forKey: "access_token") as! String
        
        if saccessToken.count>0
        {
            postDict = [
              "access_token":sharedData.getAccessToken(),
              "country_code":sharedData.getCountyName()

            ]
        }
        else
        {
            postDict = [
              "country_code":sharedData.getCountyName()

            ]

        }
       
    
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
                    if statusCode == 200
                    {
                        self.view.activityStopAnimating()

//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
//                        {
                            self.view.activityStopAnimating()
                        
                        
//                        print("Timer Stopped!")
//                        self.lblTiming.text = "Timing Stopped " + String(self.runCount)

//                            self.timer?.invalidate()
                            self.bannerList.removeAll()
                            self.categoryList.removeAll()
                            self.feturedList.removeAll()
                              self.regionList.removeAll()
                            self.bannerList = (self.homeResponseModel?.homeData?.bannerSlider!)!
                            self.categoryList = (self.homeResponseModel?.homeData?.categories!)!
                            self.feturedList = (self.homeResponseModel?.homeData?.featured!)!
                            self.regionList = (self.homeResponseModel?.homeData?.regions!)!
                            
                            self.sCartCount = (self.homeResponseModel?.homeData?.cartcount!)!
                            
                            
                           

                            
                            
                            UserDefaults.standard.setValue(self.sCartCount, forKey: "cartCount")
                            self.collectionProduct.reloadData()
                            self.collectionCategory.reloadData()
                            //self.collectionCatHeight.constant = self.collectionCategory.contentSize.height
                            
                            let cartCount = Int((self.homeResponseModel?.homeData?.cartcount!)!)
                        
                        
                        
                        self.iCartCount = cartCount!
                        
                            print("cartCount",cartCount)
                            
                            
                            if  self.iCartCount > 0
                            {
                               
                                    
                                    let saccessToken = UserDefaults.standard.value(forKey: "access_token") as! String
                                    
                                    if saccessToken.count>0
                                    {
                                        self.getCartList()

                                    }


                            }

                            
                            
                            if cartCount! > 0
                            {
                                self.tabBarController?.tabBar.items![2].badgeValue = self.homeResponseModel?.homeData?.cartcount!
                            }
                            
                            else
                            
                            {
                                self.tabBarController?.tabBar.items![2].badgeValue = nil

                            }
                            
                            
                            if  UserDefaults.standard.value(forKey: "CartCleared") as! String == "Yes"
                            {
                                self.tabBarController?.tabBar.items![2].badgeValue = nil

                            }
                            /*
                             postDict = ["access_token":sharedData.getAccessToken(),
                                         "address_type":"qwewq",
                                         "housename":"qweqw",
                                         "roadname":"qwewq",
                                         "landmark":"qwewq",
                                         "pincode":"21312",
                                         "payment_status":paymentStatus,
                                         "payment_method":paymentMethod,
                                         "operator_id":sharedData.getOperatorID()
                             ]
                             
                             */
                            if (self.homeResponseModel?.homeData?.profiledata?.post!.count)! > 0
                            {
                                self.sharedData.setZipCode(loginStatus: (self.homeResponseModel?.homeData?.profiledata?.post!)!)

                            }
                                
                            
                            
                            self.sharedData.setProfileName(token: (self.homeResponseModel?.homeData?.profiledata?.name!)!)
                            self.sharedData.setProfileImageURL(token: (self.homeResponseModel?.homeData?.profiledata?.image!)!)
                            
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
                            self.sdImageSource.removeAll()
                            
                            for img in imageArray{
                                self.sdImageSource.append(SDWebImageSource(urlString: img)!)
                            }
                            
                            self.imgSlideShow.setImageInputs(self.sdImageSource)
                                self.view.activityStopAnimating()
                            
//                        }
                        
                        self.collectionProduct.reloadData()

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
  
    
    
    func GetHomeContentWithCartCurrency()
    {
        self.view.activityStartAnimating()
        var postDict = Dictionary<String,String>()
        
        
            postDict = [
              "access_token":sharedData.getAccessToken(),
              "country_code":sharedData.getCountyName()

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
                    if statusCode == 200
                    {
                        self.view.activityStopAnimating()

//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
//                        {
                            self.view.activityStopAnimating()
                            self.timer?.invalidate()
                            self.bannerList.removeAll()
                            self.categoryList.removeAll()
                            self.feturedList.removeAll()
                              self.regionList.removeAll()
                            self.bannerList = (self.homeResponseModel?.homeData?.bannerSlider!)!
                            self.categoryList = (self.homeResponseModel?.homeData?.categories!)!
                            self.feturedList = (self.homeResponseModel?.homeData?.featured!)!
                            self.regionList = (self.homeResponseModel?.homeData?.regions!)!
                            
                            UserDefaults.standard.setValue(self.sCartCount, forKey: "cartCount")
                            self.collectionProduct.reloadData()
                            self.collectionCategory.reloadData()
                          
                            var imageArray = [String]()
                            
                            for img in self.bannerList{
                                imageArray.append(img.sliderImage!)
                            }
                            
                            
                            
                      
                            self.sdImageSource.removeAll()
                            
                            for img in imageArray{
                                self.sdImageSource.append(SDWebImageSource(urlString: img)!)
                            }
                            
                            self.imgSlideShow.setImageInputs(self.sdImageSource)
                                self.view.activityStopAnimating()
                            
//                        }
                        
                        self.collectionProduct.reloadData()

                    }
                    if statusCode == 400{
                        self.view.activityStopAnimating()
//                        self.showToast(message: (self.homeResponseModel?.message)!)
                    }
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
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
        
        AF.request(loginURL, method: .post, parameters: postDict, encoding: URLEncoding.default, headers: nil).responseJSON { [self] (data) in
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
                            
                            
                            self.cartList = (self.cartListModel?.cartListData?.cartItems)!
                       
                        
                        if self.cartList.count != 0
                        {
                        
//                            if self.sProductCurrency != sArrayCurrencyDetails
//                            {
                            if self.cartListModel?.cartListData?.cart?.currency == "AED"
                            {
                                sharedData.setCountyName(token: "AE")
                                sharedData.setCountyImg(token: "uae")
                                sharedData.setCountyCode(token: "+971")
                                self.imgFlag.image = UIImage(named: "uae")!

                            }
                            else if self.cartListModel?.cartListData?.cart?.currency == "BHD"
                            {
                                sharedData.setCountyName(token: "BH")
                                sharedData.setCountyImg(token: "baharin")
                                sharedData.setCountyCode(token: "+973")
                                self.imgFlag.image = UIImage(named: "baharin")!
                            }
                            else if self.cartListModel?.cartListData?.cart?.currency == "SAR"
                            {
                                sharedData.setCountyName(token: "SA")
                                sharedData.setCountyImg(token: "saudi")
                                sharedData.setCountyCode(token: "+966")
                                self.imgFlag.image = UIImage(named: "saudi")!
                            }
                           
                            if self.sCountryNameLogin != sharedData.getCountyName()
                            {
                                self.GetHomeContentWithCartCurrency()
                            }
                            self.dropTextField.text = sharedData.getCountyName()
                            
                            print(Locale.currency[self.sharedData.getCountyName()] as Any)
                            
                            let sArrayCurrencyDetails = Locale.currency[self.sharedData.getCountyName()]
                            if self.sProductCurrency.count > 0
                            {
                                if !self.sProductCurrency.contains(sArrayCurrencyDetails!!)
                                {

                                    let alert = UIAlertController(title: Constants.appName, message: Constants.removeCartMSG, preferredStyle: UIAlertController.Style.alert)
                                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { _ in
                                    
                                    self.tabBarController?.selectedIndex = 2

                                   
                                }))
                                alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { _ in
                                    print("NO")
                                    
                                    if !sharedData.getLoginStatus()
                                    {

                                        let alert = UIAlertController(title: Constants.appName, message: Constants.cartClearInfo, preferredStyle: UIAlertController.Style.alert)
                                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                                        
                                        let next = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController

                                        self.navigationController?.pushViewController(next, animated: true)
                                       
                                    }))
                                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
                                        print("Cancel")
                                        

                                    }))
                                    }
                                    
                                    else
                                    
                                    {
                                        self.RemoveFromCart()

                                    }
                                    

                                }))
                                self.present(alert, animated: true, completion: nil)
                                
                            }
                            }
                        }
                        else
                        {
                            
                                
                                self.view.activityStartAnimating()
                                
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
//                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
//                                                {
                                                  
                                                    let sharedData = SharedDefault()
                                                    sharedData.clearOperatorID()
                                                    sharedData.clearOperatorName()
                                                    self.view.activityStopAnimating()
                                                    self.tabBarController?.tabBar.items![2].badgeValue = nil

//                                                }
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
    
    
    
    
    
    
    
    
    
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var countVar:Int = 0
        if collectionView == collectionCategory {
            countVar = categoryList.count
        } else if collectionView == collectionProduct {
            countVar = self.feturedList.count
        }
        return countVar
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if collectionView == collectionCategory
        {
            let categoryCCell = collectionCategory.dequeueReusableCell(withReuseIdentifier: "CategoryCCell", for: indexPath as IndexPath) as! CategoryCCell
            categoryCCell.viewImgBG.layer.cornerRadius = 20
            categoryCCell.lblCatName.text = categoryList[indexPath.row].categoryName
            
          
            
            categoryCCell.imgCategory.sd_setImage(with: URL(string: self.categoryList[indexPath.row].categoryImage!), placeholderImage: UIImage(named: "Transparent"))
            categoryCCell.viewImgBG.clipsToBounds = true
            categoryCCell.imgCategory.clipsToBounds = true
            //categoryCCell.viewImgBG.backgroundColor = categoryBGColor[0]
            if UIDevice.current.screenType.rawValue == "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8" {
                categoryCCell.viewHeight.constant = 85
                categoryCCell.viewWidth.constant = 85
            }
            else if UIDevice.current.screenType.rawValue == "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus" {
                //topupCell.widthViewBG.constant = 100
                categoryCCell.viewHeight.constant = 85
                categoryCCell.viewWidth.constant = 85
            }
            else if UIDevice.current.screenType.rawValue == "iPhone XS Max or iPhone Pro Max" {
                //topupCell.widthViewBG.constant = 370
                print("iPhone XS Max or iPhone Pro Max")
                
            }
            else if UIDevice.current.screenType.rawValue == "iPhone X or iPhone XS" {
                print("iPhone X or iPhone XS")
                categoryCCell.viewHeight.constant = 85
                categoryCCell.viewWidth.constant = 85
                
            }
            else if UIDevice.current.screenType.rawValue == "iPhone XR or iPhone 11" {
                print("iPhone XR or iPhone 11")
                //topupCell.widthViewBG.constant = 370
            }
                
            else if UIDevice.current.screenType.rawValue == "iPhone 11 Pro" {
                print("iPhone 11 Pro")
                //topupCell.widthViewBG.constant = 370
            }
            else {
                print("iPhone 11 Pro 11111111111111")
                categoryCCell.viewHeight.constant = 85
                categoryCCell.viewWidth.constant = 85
                
            }
            cell = categoryCCell
            
        }
        else if collectionView == collectionProduct
        {
            
            let productListCCell = collectionProduct.dequeueReusableCell(withReuseIdentifier: "ProductListCCell", for: indexPath as IndexPath) as! ProductListCCell
            
            productListCCell.viewBG.layer.borderWidth = 1.0
            productListCCell.viewBG.layer.borderColor = Constants.borderColor.cgColor
            productListCCell.viewBG.layer.cornerRadius = 5.0
            
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
                productListCCell.lblPdt.text = self.feturedList[indexPath.row].prdName!
                
                
                self.sCategoryName = self.feturedList[indexPath.row].prdName!
                
                productListCCell.lblPdt.text = self.sCategoryName.capitalized
                
                
                print("Capitalized Wordings",self.sCategoryName.capitalized)
                
    //            productListCCell.lblQty.text = self.feturedList[indexPath.row].qty! + " " + self.feturedList[indexPath.row].unit!
                
                if self.feturedList[indexPath.row].price == "0" || self.feturedList[indexPath.row].price?.count == 0
                {
                    productListCCell.lblQty.text = ""
                }
                else
                {
                    let iPricerate = ConvertCurrencyFormat(sNumber: Double(self.feturedList[indexPath.row].price!) as! NSNumber)
                    let result1 = String(iPricerate.dropFirst())    // "ello"
//                productListCCell.lblQty.text = self.feturedList[indexPath.row].price! + " " + self.feturedList[indexPath.row].currency!
                    productListCCell.lblQty.text = self.feturedList[indexPath.row].currency! + " " + result1

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
                productListCCell.lblPdt.text = self.feturedList[indexPath.row].prdName!
                self.sCategoryName = self.feturedList[indexPath.row].prdName!
                
                productListCCell.lblPdt.text = self.sCategoryName.capitalized
                
                
    //            productListCCell.lblQty.text = self.feturedList[indexPath.row].qty! + " " + self.feturedList[indexPath.row].unit!
                
                if self.feturedList[indexPath.row].price == "0" || self.feturedList[indexPath.row].price?.count == 0
                {
                    productListCCell.lblQty.text = ""
                }
                else
                {
                    let iPricerate = ConvertCurrencyFormat(sNumber: Double(self.feturedList[indexPath.row].price!) as! NSNumber)
                    let result1 = String(iPricerate.dropFirst())    // "ello"

//                    productListCCell.lblQty.text = self.feturedList[indexPath.row].price! + " " + self.feturedList[indexPath.row].currency!
                    
                    productListCCell.lblQty.text = self.feturedList[indexPath.row].currency! + " " + result1

                }

    //            productListCCell.lblPdtPrice.text = self.feturedList[indexPath.row].price! + " " + self.feturedList[indexPath.row].currency!
            }
            
            
            //categoryBGColor
            cell = productListCCell
            
        }
        
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        if collectionView == collectionCategory
        {
            let next = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
            next.callType = "1"
            next.categoryID = self.categoryList[indexPath.row].categoryId
            next.categoryName = self.categoryList[indexPath.row].categoryName

            print("self.categoryList ---- ",self.categoryList[indexPath.row].categoryId)
            //self.categoryList
            self.navigationController?.pushViewController(next, animated: true)
            
        }
        else  if collectionView == collectionProduct
        {
            if  self.feturedList[indexPath.row].current_stock == "0"
            {
                print("Out of stack")
            }
            else
            {
//                if self.feturedList[indexPath.row].price == "0" || self.feturedList[indexPath.row].price == ""
//                {
//                    print("No Price")
//                    self.showToast(message: "Currently the product is not for sale")
//
//                }
//                else
//
//                {
                    
            let next = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
            next.productID = self.feturedList[indexPath.row].prdId! as String
            //next.productID = self.pdtList[indexPath.row].productId! as String
            self.navigationController?.pushViewController(next, animated: true)
//                }
            }
        }
        
    }
    
    // MARK: - Btn Actions
    
    
    @IBAction func btnFPdtSeeAllAction(_ sender: UIButton) {
        print("btnFPdtSeeAllAction")
        let next = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
        next.callType = "3"
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func btnCatSeeAllAction(_ sender: UIButton) {
        print("btnCatSeeAllAction")
       
        let next = self.storyboard?.instantiateViewController(withIdentifier: "CategoryListVC") as! CategoryListVC
        self.navigationController?.pushViewController(next, animated: true)
        
    }
    
    func addTextfield()  {
        let viewDropBg:UIView?
        if UIDevice.current.screenType.rawValue == "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8" {
            print("iPhone 6, iPhone 6S, iPhone 7 or iPhone 8")
           viewDropBg = UIView(frame: CGRect(x: self.view.frame.size.width-275,  y: 5, width: 125, height: 30))
        }
        else if UIDevice.current.screenType.rawValue == "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus" {
          viewDropBg = UIView(frame: CGRect(x: self.view.frame.size.width-275,  y: 5, width: 125, height: 30))
        }
        else if UIDevice.current.screenType.rawValue == "iPhone XS Max or iPhone Pro Max" {
           viewDropBg = UIView(frame: CGRect(x: self.view.frame.size.width-275,  y: 5, width: 125, height: 30))
            
        }
        else if UIDevice.current.screenType.rawValue == "iPhone X or iPhone XS" {
            viewDropBg = UIView(frame: CGRect(x: self.view.frame.size.width-275,  y: 5, width: 125, height: 30))
        }
        else if UIDevice.current.screenType.rawValue == "iPhone XR or iPhone 11" {
           viewDropBg = UIView(frame: CGRect(x: self.view.frame.size.width-275,  y: 5, width: 125, height: 30))
        }
            
        else if UIDevice.current.screenType.rawValue == "iPhone 11 Pro" {
           viewDropBg = UIView(frame: CGRect(x: self.view.frame.size.width-275,  y: 5, width: 125, height: 30))
        }
        else {
            print("iPhone 11 Pro 11111111111111")
           viewDropBg = UIView(frame: CGRect(x: self.view.frame.size.width-275,  y: 5, width: 125, height: 30))
            
        }
        
        //viewDropBg = UIView(frame: CGRect(x: self.view.frame.size.width-275,  y: 5, width: 140, height: 30))
        viewDropBg!.layer.cornerRadius = 5.0
        viewDropBg!.backgroundColor = .white
        
        self.navigationController?.navigationBar.topItem?.titleView = viewDropBg
        
        self.imgFlag = UIImageView(frame: CGRect(x: 0,  y:3, width: 25, height: 25))
        //imgFlag.image = UIImage(named: "uae")!
        viewDropBg!.addSubview(imgFlag)
        
        //dropTextField =  iOSDropDown(frame: CGRect(x: self.view.frame.size.width-275, y: 5, width: 180, height: 30))
        
        dropTextField = DropDown(frame: CGRect(x: imgFlag.frame.size.width, y: 0, width: (viewDropBg?.frame.size.width)! - imgFlag.frame.size.width, height: 30)) // set frame
        
        
        
        
        
        dropTextField.borderColor = .clear
        dropTextField.textAlignment = .right
        dropTextField.placeholder = "Region"
        dropTextField.checkMarkEnabled = false
       
        //dropTextField.optionArray = ["Option 1", "Option 2", "Option 3"]
        for item in self.regionList {
            dropTextField.optionArray.append(item.countryCode!)
        }
        // Image Array its optional
        
        
        let customFont:UIFont = UIFont.init(name: (dropTextField.font?.fontName)!, size: 10.0)!
        
        
        dropTextField.font = customFont
        
        dropTextField.optionArray = self.itemsNames
        
        dropTextField.optionImageArray = self.itemsImages
        
        //var itemsImages = ["uae","qatar", "baharin" ,"saudi","india"]
        //dropTextField. = ["uae","qatar", "baharin" ,"saudi","india"]
        dropTextField.text = sharedData.getCountyName()
        imgFlag.image = UIImage(named: sharedData.getCountyImg())!
        /*
        let defaults = UserDefaults.standard
        // 2. Check if there is not an userDefaults object for theme
        if defaults.object(forKey: "country_code") == nil && defaults.object(forKey: "country_name") == nil {
            let countryLocale = NSLocale.current
            let countryCode = countryLocale.regionCode
            let country = (countryLocale as NSLocale).displayName(forKey: NSLocale.Key.countryCode, value: countryCode)!
            
            dropTextField.text = country as String
            
            
        } else {
            dropTextField.text = sharedData.getCountyName()
            imgFlag.image = UIImage(named: sharedData.getCountyImg())!
            
        }
       */
        
        dropTextField.font = UIFont.systemFont(ofSize: 15)
        dropTextField.borderStyle = UITextField.BorderStyle.roundedRect
//        dropTextField.autocorrectionType = UITextAutocorrectionType.no
//        dropTextField.keyboardType = UIKeyboardType.default
//        dropTextField.returnKeyType = UIReturnKeyType.done
//        dropTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        
        dropTextField.isSearchEnable = false
        
        
        dropTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        dropTextField.rowHeight = 30.0
        dropTextField.selectedRowColor = UIColor.clear
        dropTextField.textAlignment = .left
        //self.navigationController?.navigationBar.topItem?.titleView = dropTextField
        
        viewDropBg!.addSubview(dropTextField)
        
        //self.navigationController?.navigationBar .addSubview(dropTextField)
        dropTextField.layer.cornerRadius = 15
        let viewImg = UIView(frame: CGRect(x: 0, y: dropTextField.frame.size.height/2, width: 10, height: 10))
        dropTextField.rightViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: -5, y: 0, width: 10, height: 10))
        let image = UIImage(named: "DownArrow")
        imageView.image = image
        viewImg.addSubview(imageView)
        dropTextField.rightView = viewImg
        print(dropTextField.text)
        scountryName1 = dropTextField.text!
        
        dropTextField.didSelect{(selectedText , index ,id) in
            //self.valueLabel.text = "Selected String: \(selectedText) \n index: \(index)"
            print("selectedText ----- ",selectedText)
            self.view.endEditing(true)

           
            
            self.scountryName2 = selectedText
            
//            if self.sharedData.getLoginStatus()
//            {
            
            if self.cartList.count>0
            {
            if self.regionList.count>0
            {
                let alert = UIAlertController(title: nil, message: "If you change Region, Your cart items will be removed.", preferredStyle: .alert)

                    // yes action
                    let yesAction = UIAlertAction(title: "Ok", style: .default)
                    { _ in
                        // replace data variable with your own data array
                        
                        self.sharedData.setCountyImg(token: self.itemsImages[index])
                        self.sharedData.setCountyCode(token: self.itemsCode[index])
                        self.sharedData.setCountyName(token: self.itemsNames[index])
                 
                        self.imgFlag.image = UIImage(named: self.itemsImages[index])!
                        
                        if self.scountryName1 == self.scountryName2
                        {
                            UserDefaults.standard.setValue("No", forKey: "CartCleared")

                        }
                        else
                        {
                            UserDefaults.standard.setValue("Yes", forKey: "CartCleared")

                        }
                        
                            self.RemoveFromCart()

                                             
                        self.dropTextField.text = self.itemsNames[index]
//                        self.getHomeContent()
                    }

                    alert.addAction(yesAction)
                // Cancel action
                let cancelAction = UIAlertAction(title: "Cancel", style: .default)
                { _ in
                    // replace data variable with your own data array
                    
                    self.dropTextField.text = self.scountryName1
                }
                    // cancel action
//                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(cancelAction)

                self.present(alert, animated: true, completion: nil)
                
                
               
                /**
                 
                 var itemsNames = ["AE","QA","BH", "SA" ,"IN"]
                  var itemsImages = ["uae","qatar", "baharin" ,"saudi","india"]
                   var itemsCode = ["+971","+974","+973", "+966" ,"+91"]

                 */
            
            }
            }
            else
            
            {
                self.sharedData.setCountyImg(token: self.itemsImages[index])
                self.sharedData.setCountyCode(token: self.itemsCode[index])
                self.sharedData.setCountyName(token: self.itemsNames[index])
                self.imgFlag.image = UIImage(named: self.itemsImages[index])!
                self.dropTextField.text = self.itemsNames[index]

//                self.getHomeContent()

            }
            
            

            
            
            
            
            
            
            
//        }
//            else
//            {
//                let alert = UIAlertController(title: Constants.appName, message: Constants.cartClearInfo, preferredStyle: UIAlertController.Style.alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
//
//                let next = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
//
//                self.navigationController?.pushViewController(next, animated: true)
//
//            }))
//            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
//                print("Cancel")
//
//
//            }))
//            self.present(alert, animated: true, completion: nil)
//
//            }
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
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
//                        {
                            print("response ",response)
                            self.showToast(message: (self.addToCartModel?.message)!)
                            
                            let sharedData = SharedDefault()
                            sharedData.clearOperatorID()
                            sharedData.clearOperatorName()
                            self.cartList.removeAll()
                            
                            
                            self.view.activityStopAnimating()
                            self.tabBarController?.tabBar.items![2].badgeValue = nil

//                        }
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
    
    
    
    func getVersion() {
        let postDict = Dictionary<String,String>()
        
        
        print("PostData: ",postDict)
        let loginURL = Constants.baseURL+Constants.versionURL//"https://drssystem.co.uk/api/customer/version"
        print("loginURL: ",loginURL)
        AF.request(loginURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
            print("Response:***:",data.description)
            
            switch (data.result) {
            case .failure(let error) :
//                self.view.activityStopAnimating()
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
                        
                        
                        
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            let currentAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                            let serviceAppVersion = self.versionModel?.versionModelData?.version!
                            let iosInitial:String = (self.versionModel?.versionModelData?.iosInitialUpdate!)!
                            print("currentAppVersion === = ",NumberFormatter().number(from: currentAppVersion!)!.doubleValue)
                            print("serviceAppVersion === = ",NumberFormatter().number(from: serviceAppVersion!)!.doubleValue)
                            print("iosInitial === = ",iosInitial)
                            if Int(iosInitial) == 1
                            {
//                                let first_value = Double(currentAppVersion ?? "0.0")
//                                let second_value =  Double(serviceAppVersion ?? "0.0")
//
//                                if first_value! > second_value! {
//                                     print("first_value is greater than second_value")
//                                 }
//                                 else {
//                                     print("first_value is not greater than second_value ")
//                                 }
//
                                
                                if currentAppVersion == serviceAppVersion!
                                {
                                    print("alertWindow")

                                }
                                else
                                {
                                    print("first_value is not greater than second_value ")
                                    
                                    let alertController = UIAlertController (title: Constants.appName, message: "A new vesion of Vinner is available in App Store. Please update", preferredStyle: .alert)
                                    
                                    alertController.addAction(UIAlertAction(title: "Update", style: .default, handler: { action in
                                        if let url = URL(string: "https://apps.apple.com/us/app/id1534567568") {
                                            UIApplication.shared.open(url)
                                        }
                                    }))
                                    

                                    self.present(alertController, animated: true, completion: nil)
                                }
                                
//
//                                if NumberFormatter().number(from: serviceAppVersion!)!.doubleValue <
//                                    NumberFormatter().number(from: currentAppVersion!)!.doubleValue {
//
//
//
//
//
//
//
//                                }
//                                else {
//                                }
                            
                            }
                            
                          
                    
//                        }
                        
                    }
                    if statusCode == 400{
//                       self.view.activityStopAnimating()
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
    
    
    
    
    
}
