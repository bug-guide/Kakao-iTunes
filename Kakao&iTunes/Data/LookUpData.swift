//
//  LookUpData.swift
//  Kakao&iTunes
//
//  Created by NC0201024 on 2018. 5. 29..
//  Copyright © 2018년 wisewood. All rights reserved.
//

import UIKit

class LookUpData: NSObject {
    // MARK: - use HeadInfoCell
    var trackName:String? = ""
    var sellerName:String? = ""
    var averageUserRating:CGFloat = 0
    var contentAdvisoryRating:String? = "0+"
    
    //application data 에서 가져다가 세팅한다.
    var appImageUrlStr:String? = ""
    var rankingStr:String = "#0"
    
    // MARK: - use HeadInfoCell
    var version:String? = ""
    var releaseNotes:String? = ""
    
    // MARK: - use PreviewCell
    var screenshotUrls:[String]? = []
    
    // MARK: - use DescriptionCell
    var appDescription:String? = ""
    
    class func createData(result:NSDictionary) -> LookUpData {
        let data = LookUpData.init()
        if let trackName = result["trackName"] as? String {
            data.trackName = trackName
        }
        
        if let sellerName = result["sellerName"] as? String {
            data.sellerName = sellerName
        }
        
        if let averageUserRating = result["averageUserRating"] as? CGFloat {
            data.averageUserRating = averageUserRating
        }
        
        if let contentAdvisoryRating = result["contentAdvisoryRating"] as? String {
            data.contentAdvisoryRating = contentAdvisoryRating
        }
        
        if let version = result["version"] as? String {
            data.version = version
        }
        
        if let releaseNotes = result["releaseNotes"] as? String {
            data.releaseNotes = releaseNotes
        }
        
        if let screenshotUrls = result["screenshotUrls"] as? Array<String> {
            data.screenshotUrls = screenshotUrls
        }
        
        if let description = result["description"] as? String {
            data.appDescription = description
        }
        
        
        return data
    }
}
