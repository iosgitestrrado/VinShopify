//
//  ReviewProductVC.swift
//  Vinner
//
//  Created by softnotions on 29/07/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import Cosmos
import MobileCoreServices
import Alamofire
import SwiftyJSON

class ReviewProductVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var txtViewComments: UITextView!
    @IBOutlet weak var txtReviewTitle: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    var orderID:String?
    var sProductIdToReview:String?
    var sTitle:String?

    var reviewId:String?

    var iRating = Int()
    var sProductID:String?
    var sReviewId:String?

    @IBOutlet weak var scrollPage: UIScrollView!

    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var ratingExcellent: CosmosView!
    @IBOutlet weak var ratingGood: CosmosView!
    @IBOutlet weak var ratingAverage: CosmosView!
    @IBOutlet weak var ratingBad: CosmosView!
    @IBOutlet weak var ratingHorrible: CosmosView!
    @IBOutlet weak var imgProduct: UIImageView!
    let sharedData = SharedDefault()
    var orderDetailModel:OrderDetailModel?
    
    var viewReviewResponseModel:ViewReviewResponseModel?
    var reviewlist :Review?

    
    var pdtList = [ProductDetail]()
    var shipAddr = [ShippingAddress]()
    var billAddr = [BillingAddress]()
    @IBOutlet weak var viewHorrible: UIView!
    
    @IBOutlet weak var viewBad: UIView!
    
    @IBOutlet weak var viewExcellent: UIView!
    @IBOutlet weak var viewAverage: UIView!
    
    @IBOutlet weak var viewGood: UIView!
    
    var paymentStat = [PaymentStatus]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        print("Selected Product Id :::",self.sProductIdToReview!)
        btnSubmit.layer.cornerRadius = 5
        
        txtReviewTitle.layer.borderColor = Constants.borderColor.cgColor
        txtReviewTitle.layer.borderWidth = 1
        txtReviewTitle.layer.cornerRadius = 5
        
        txtViewComments.layer.borderColor = Constants.borderColor.cgColor
        txtViewComments.layer.borderWidth = 1
        txtViewComments.layer.cornerRadius = 5
        txtViewComments.text = "Tell us what you like or dislike about this product."
        txtViewComments.textColor = UIColor.lightGray
        txtViewComments.delegate = self
        self.addBackButton(title: sTitle!)

        ratingExcellent.rating = 0
        ratingGood.rating = 0
        ratingAverage.rating = 0
        ratingBad.rating = 0
        ratingHorrible.rating = 0
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.ViewHorribleAction (_:)))
        self.viewHorrible.addGestureRecognizer(gesture)

        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector (self.viewBadAction (_:)))
        self.viewBad.addGestureRecognizer(gesture1)
        
        
        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector (self.viewAverageAction (_:)))
        self.viewAverage.addGestureRecognizer(gesture2)
        
        
        
        let gesture3 = UITapGestureRecognizer(target: self, action:  #selector (self.viewGoodAction (_:)))
        self.viewGood.addGestureRecognizer(gesture3)
        
        
        
        let gesture4 = UITapGestureRecognizer(target: self, action:  #selector (self.viewExcellentAction (_:)))
        self.viewExcellent.addGestureRecognizer(gesture4)
        
        
        self.getOrderDetail()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker))]
        numberToolbar.sizeToFit()
        txtReviewTitle.inputAccessoryView = numberToolbar
        
        txtViewComments.inputAccessoryView = numberToolbar

        
    }
    
    
    @objc func cancelPicker() {
           //Cancel with number pad
        view.endEditing(true)
       }
       @objc func donePicker() {
           //Done with number pad
        view.endEditing(true)
       }
    
    // MARK: keyboard notification
    @objc func keyboardWillShow(notification:NSNotification){
        //give room at the bottom of the scroll view, so it doesn't cover up anything the user needs to tap
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollPage.contentInset
        contentInset.bottom = keyboardFrame.size.height
        self.scrollPage.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        self.scrollPage.contentInset = contentInset
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray
        {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    

    @objc func viewBadAction(_ sender:UITapGestureRecognizer)
    {
        print("viewBadAction was clicked")
        ratingExcellent.rating = 0
        ratingGood.rating = 0
        ratingAverage.rating = 0
        ratingBad.rating = 1
        ratingHorrible.rating = 1
        iRating = 2
    }
    @objc func ViewHorribleAction(_ sender:UITapGestureRecognizer)
    {
        print("viewHorrible was clicked")
        ratingExcellent.rating = 0
        ratingGood.rating = 0
        ratingAverage.rating = 0
        ratingBad.rating = 0
        ratingHorrible.rating = 1
        iRating = 1
    }
    
    
    @objc func viewAverageAction(_ sender:UITapGestureRecognizer)
    {
        print("viewAverageAction was clicked")
        ratingExcellent.rating = 0
        ratingGood.rating = 0
        ratingAverage.rating = 1
        ratingBad.rating = 1
        ratingHorrible.rating = 1
        iRating = 3
    }
    @objc func viewExcellentAction(_ sender:UITapGestureRecognizer)
    {
        print("viewExcellentAction was clicked")
        ratingExcellent.rating = 1
        ratingGood.rating = 1
        ratingAverage.rating = 1
        ratingBad.rating = 1
        ratingHorrible.rating = 1
        iRating = 5
    }
    
    @objc func viewGoodAction(_ sender:UITapGestureRecognizer)
    {
        print("viewGoodAction was clicked")
        ratingExcellent.rating = 0
        ratingGood.rating = 1
        ratingAverage.rating = 1
        ratingBad.rating = 1
        ratingHorrible.rating = 1
        iRating = 4
    }
    
    
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if textView.text.isEmpty {
            textView.text = "Tell us what you like or dislike about this product."
            textView.textColor = UIColor.lightGray
        }
    }
    @IBAction func btnSubmitAction(_ sender: Any)
    {
        
        if Reachability.isConnectedToNetwork()
        {
//            if txtViewComments.text!.count<=0 {
//                self.showToast(message:Constants.saveReviewEmtyMessage)
//            }
//            else
            
            if txtReviewTitle.text!.count<=0 {
                self.showToast(message:Constants.saveReviewTitleEmtyMessage)
            }
            else  if iRating == 0
            {
                self.showToast(message:Constants.saveRatingEmptyMessage)
            }
            
            
            else
            {
                
                submitProductReview()
                    
            }
                
            
            
        }
        else
        {
            self.showToast(message:Constants.connectivityErrorMsg)
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
    
    // MARK: - get order detail
    func getOrderDetail()
    {
        self.view.activityStartAnimating()
        
        let loginURL = Constants.baseURL+Constants.orderDetailURL
        print("loginURL",loginURL)
        
        var postDict = Dictionary<String,String>()
        postDict = ["access_token":sharedData.getAccessToken(),
                    "order_id":orderID!
  
        ]
       
        
        
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
                    self.orderDetailModel = OrderDetailModel(response)
                    let statusCode = Int((self.orderDetailModel?.httpcode)!)
                    if statusCode == 200{
                        
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            
                            self.paymentStat.removeAll()
                          self.paymentStat = (self.orderDetailModel?.orderDetailModelData?.paymentStatus!)!
                            print("123123123====== ",(self.orderDetailModel?.orderDetailModelData?.paymentStatus!)!)
                            //self.paymentStat.append((self.orderDetailModel?.orderDetailModelData?.paymentMethod!)!)
                            
                        
                            
                            self.pdtList = (self.orderDetailModel?.orderDetailModelData?.productDetails!)!
                            print(self.pdtList)
                            
                            for item in self.pdtList
                            {
                                if item.id == self.sProductIdToReview
                                {

                                    self.imgProduct.sd_setImage(with: URL(string: item.image!), placeholderImage: UIImage(named: "Transparent"))
                                    self.lblProductName.text = item.name
                                    self.sReviewId = item.review_id
                                    self.sProductID = item.id
                                }
                                
                                
                            }
                            if self.sReviewId != "0"
                            {
                                self.getReviewDetails()

                            }
                           
                            
                            self.view.activityStopAnimating()

//                        }
                    }
                    if statusCode == 400{
                        self.view.activityStopAnimating()
                        self.showToast(message: (self.orderDetailModel?.message)!)
                    }
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    // MARK: - get order detail
    func getReviewDetails()
    {
        self.view.activityStartAnimating()

        let loginURL = Constants.baseURL+Constants.viewReviewUrl
        print("loginURL",loginURL)
        
        var postDict = Dictionary<String,String>()
        postDict = ["access_token":sharedData.getAccessToken(),
                    "review_id":self.sReviewId!
  
        ]
       
        
        
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
                    self.viewReviewResponseModel = ViewReviewResponseModel(response)
                    let statusCode = Int((self.viewReviewResponseModel?.httpcode)!)
                    if statusCode == 200{
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {

                           
                            
                        
                            
                            self.reviewlist = (self.viewReviewResponseModel?.viewReviewData?.review!)!
                            self.ratingBad.endEditing(true)
                            
                                self.txtReviewTitle.isEnabled = false
                                self.txtViewComments.isEditable = false
                            self.txtReviewTitle.text = self.reviewlist?.review_title
                            self.txtViewComments.text = self.reviewlist?.review
                            if self.reviewlist?.rating == "1"
                                {
                                    self.ratingExcellent.rating = 0
                                    self.ratingGood.rating = 0
                                    self.ratingAverage.rating = 0
                                    self.ratingBad.rating = 0
                                    self.ratingHorrible.rating = 1
                                }
                            else if self.reviewlist?.rating == "2"
                                {
                                    self.ratingExcellent.rating = 0
                                    self.ratingGood.rating = 0
                                    self.ratingAverage.rating = 0
                                    self.ratingBad.rating = 1
                                    self.ratingHorrible.rating = 1
                                }
                            else if self.reviewlist?.rating == "3"
                                {
                                    self.ratingExcellent.rating = 0
                                    self.ratingGood.rating = 0
                                    self.ratingAverage.rating = 1
                                    self.ratingBad.rating = 1
                                    self.ratingHorrible.rating = 1
                                }
                            else if self.reviewlist?.rating == "4"
                                {
                                    self.ratingExcellent.rating = 0
                                    self.ratingGood.rating = 1
                                    self.ratingAverage.rating = 1
                                    self.ratingBad.rating = 1
                                    self.ratingHorrible.rating = 1
                                }
                            else if self.reviewlist?.rating == "5"
                                {
                                    self.ratingExcellent.rating = 1
                                    self.ratingGood.rating = 1
                                    self.ratingAverage.rating = 1
                                    self.ratingBad.rating = 1
                                    self.ratingHorrible.rating = 1
                                }
                            self.btnSubmit.isHidden = true
                           
                            self.view.activityStopAnimating()
                           
//                        }
                    }
                    if statusCode == 400{
                        self.view.activityStopAnimating()
//                        self.showToast(message: (self.orderDetailModel?.message)!)
                    }
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    func submitProductReview()
    {
        self.view.activityStartAnimating()
        
        let loginURL = Constants.baseURL+Constants.saveReviewUrl
        print("loginURL",loginURL)
        
        if txtViewComments.text == "Tell us what you like or dislike about this product."
        {
            txtViewComments.text = ""
        }
        
        
        var postDict = Dictionary<String,String>()
        postDict = ["access_token":sharedData.getAccessToken(),
//                    "product_id":sProductID!,
                    "product_id":sProductIdToReview!,
                    "rating":String(iRating),
                    "title":txtReviewTitle.text!,
                    "review":txtViewComments.text!

  
        ]
       
        
        
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
                    self.orderDetailModel = OrderDetailModel(response)
                    let statusCode = Int((self.orderDetailModel?.httpcode)!)
                    if statusCode == 200{
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
                        {
                            self.showToast(message: (self.orderDetailModel?.message)!)

                            self.navigationController?.popViewController(animated: true)
                        }

                            self.view.activityStopAnimating()
                           
                        
                    }
                    if statusCode == 400{
                        self.view.activityStopAnimating()
                        self.showToast(message: (self.orderDetailModel?.message)!)
                    }
                    
                }
                catch let err {
                    print("Error::",err.localizedDescription)
                }
            }
        }
    }
    
    
    
    
    
}
