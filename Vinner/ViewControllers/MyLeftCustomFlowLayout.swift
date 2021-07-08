//
//  MyLeftCustomFlowLayout.swift
//  DRS
//
//  Created by softnotions on 28/06/20.
//  Copyright © 2020 Softnotions Technologies Pvt Ltd. All rights reserved.
//

import UIKit

class MyLeftCustomFlowLayout: UICollectionViewFlowLayout {
    var horizontalSpacing:CGFloat?
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

           let attributes = super.layoutAttributesForElements(in: rect)

           var leftMargin = sectionInset.left
           var maxY: CGFloat = 2.0
        
        
        if UIDevice.current.screenType.rawValue == "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8" {
            print("iPhone 6, iPhone 6S, iPhone 7 or iPhone 8")
            horizontalSpacing = 10.0
        }
        else if UIDevice.current.screenType.rawValue == "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus" {
            print("iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus" )
            horizontalSpacing = 30.0
        }
        else if UIDevice.current.screenType.rawValue == "iPhone XS Max or iPhone Pro Max" {
           print("iPhone XS Max or iPhone Pro Max" )
            horizontalSpacing = 30.0
        }
        else if UIDevice.current.screenType.rawValue == "iPhone X or iPhone XS" {
           print("iPhone X or iPhone XS" )
            horizontalSpacing = 15.0
        }
        else if UIDevice.current.screenType.rawValue == "iPhone XR or iPhone 11" {
            print("iPhone XR or iPhone 11" )
            horizontalSpacing = 30.0
        }
        
        else {
           
             horizontalSpacing = 30.0
        }
   

           attributes?.forEach { layoutAttribute in
               if layoutAttribute.frame.origin.y >= maxY
                   || layoutAttribute.frame.origin.x == sectionInset.left {
                   leftMargin = sectionInset.left
               }

               if layoutAttribute.frame.origin.x == sectionInset.left {
                   leftMargin = sectionInset.left
               }
               else {
                   layoutAttribute.frame.origin.x = leftMargin
               }

            leftMargin += layoutAttribute.frame.width + horizontalSpacing!
               maxY = max(layoutAttribute.frame.maxY, maxY)
           }

           return attributes
       }
}
