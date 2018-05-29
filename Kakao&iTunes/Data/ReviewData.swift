//
//  ReviewData.swift
//  Kakao&iTunes
//
//  Created by NC0201024 on 2018. 5. 29..
//  Copyright © 2018년 wisewood. All rights reserved.
//

import UIKit

class ReviewData: NSObject {
    
    var userName:String? = ""
    
    var title:String? = ""
    var content:String? = ""
    
    var rating:String? = "0"
    
    class func createReviewData(reviewDic:NSDictionary) -> ReviewData {
        let data = ReviewData.init()
        
        if let author = reviewDic["author"] as? NSDictionary {
            if let name = author["name"] as? NSDictionary {
                data.userName = name["label"] as? String
            }
        }
        
        if let title = reviewDic["title"] as? NSDictionary {
            data.title = title["label"] as? String
        }
        
        if let content = reviewDic["content"] as? NSDictionary {
            data.content = content["label"] as? String
        }
        
        if let rating = reviewDic["im:rating"] as? NSDictionary {
            data.rating = rating["label"] as? String
        }
        
        
        
        return data
    }
    
}
