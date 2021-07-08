//
//  ShowAllReviewVC.swift
//  Vinner
//
//  Created by softnotions on 26/08/20.
//  Copyright © 2020 softnotions. All rights reserved.
//

import UIKit
import Cosmos
class ShowAllReviewVC: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    var reviewList = [Reviews]()
    @IBOutlet weak var lblTotalRating: UILabel!
    
    @IBOutlet weak var lblNoRating: UILabel!
    var iRating = Double()
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var tableReview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = ""
        // Do any additional setup after loading the view.
        self.addBackButton(title: "Customer Reviews")
        var totalRating:Int? = 0
        for item in self.reviewList{
            let temp = item.rating
            
            totalRating = totalRating! + (temp! as NSString).integerValue
            
        }
        
        self.ratingView.rating = iRating

        
        
        
        if self.reviewList.count>0 {
//            self.lblTotalRating.text = String(totalRating!/self.reviewList.count) + " out of 5"
//            self.ratingView.rating = Double(totalRating!/self.reviewList.count)
            self.lblNoRating.text = String(self.reviewList.count)
            self.lblNoRating .sizeToFit()
        }
        else
        {
            self.lblTotalRating.text = "0"
            self.ratingView.rating = 0.0
            self.lblNoRating.text = "0"
            self.ratingView.isHidden = true
            
            self.showToast(message: "No reviews found")

        }
        

        self.lblTotalRating.text = ""
        self.tableReview.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if tableView == tableReview {
            let reviewTCell = tableReview.dequeueReusableCell(withIdentifier: "ReviewTCell", for: indexPath) as! ReviewTCell
            reviewTCell.imgProfile.layer.cornerRadius = reviewTCell.imgProfile.frame.size.height/2
            
            reviewTCell.lblName.text = self.reviewList[indexPath.row].user
            reviewTCell.lblReviewDate.text = self.reviewList[indexPath.row].reviewDate
            reviewTCell.lblTitle.text = self.reviewList[indexPath.row].reviewTitle
            reviewTCell.lblReviewContent.text = self.reviewList[indexPath.row].review
            
            if self.reviewList[indexPath.row].rating == ""
            {
                
                let strRating:String = "0"
                reviewTCell.reviewRating.rating = Double(strRating)!
                
            }
            else
            {
            let strRating:String = self.reviewList[indexPath.row].rating!
            reviewTCell.reviewRating.rating = Double(strRating)!
            }
            cell = reviewTCell
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tableNotification ",indexPath.row)
        print("tableNotification section ",indexPath.section)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewList.count
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
