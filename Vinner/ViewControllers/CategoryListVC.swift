//
//  CategoryListVC.swift
//  Vinner
//
//  Created by softnotions on 11/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import MobileCoreServices
import Alamofire
import SwiftyJSON

class CategoryListVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionCategory: UICollectionView!
    var catListModel: CategoryListModel?
    var categoryList = [CategoryListData]()
    let sharedData = SharedDefault()
    
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationController?.navigationBar.topItem?.title = "Browse By Category"
         self.addBackButton(title: "Browse By Category")
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let layouts = MyLeftCustomFlowLayout()
        layouts.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.collectionCategory.collectionViewLayout = layouts
        
        self.getCategoryList()
        
    }
    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var countVar:Int = 0
        if collectionView == collectionCategory {
            //countVar = categoryList.count
            countVar = self.categoryList.count
        }
        return countVar
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if collectionView == collectionCategory {
            let categoryCCell = collectionCategory.dequeueReusableCell(withReuseIdentifier: "CategoryCCell", for: indexPath as IndexPath) as! CategoryCCell
            categoryCCell.viewImgBG.layer.cornerRadius = 20
            categoryCCell.lblCatName.text = categoryList[indexPath.row].categoryName
            categoryCCell.imgCategory.sd_setImage(with: URL(string: categoryList[indexPath.row].categoryImage!), placeholderImage: UIImage(named: "Transparent"))
            
            categoryCCell.viewImgBG.clipsToBounds = true
            categoryCCell.imgCategory.clipsToBounds = true
            categoryCCell.viewImgBG.backgroundColor = UIColor.white
            
            if UIDevice.current.screenType.rawValue == "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8" {
                categoryCCell.viewHeight.constant = 70
                categoryCCell.viewWidth.constant = 70
            }
            else if UIDevice.current.screenType.rawValue == "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus" {
                //topupCell.widthViewBG.constant = 100
                categoryCCell.viewHeight.constant = 100
                categoryCCell.viewWidth.constant = 100
            }
            else if UIDevice.current.screenType.rawValue == "iPhone XS Max or iPhone Pro Max" {
                //topupCell.widthViewBG.constant = 370
                print("iPhone XS Max or iPhone Pro Max")
                
            }
            else if UIDevice.current.screenType.rawValue == "iPhone X or iPhone XS" {
                print("iPhone X or iPhone XS")
                categoryCCell.viewHeight.constant = 100
                categoryCCell.viewWidth.constant = 100
                
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
                categoryCCell.viewHeight.constant = 100
                categoryCCell.viewWidth.constant = 100
                
            }
            cell = categoryCCell
            
        }
       
        
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        if collectionView == collectionCategory {
            
            
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                          self.categoryList = (self.catListModel?.categoryListData)!
                          self.collectionCategory.reloadData()
                          self.view.activityStopAnimating()
                        }
                    }
                    if statusCode == 400{
                      self.view.activityStopAnimating()
                        self.showToast(message: (self.catListModel?.message)!)
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
