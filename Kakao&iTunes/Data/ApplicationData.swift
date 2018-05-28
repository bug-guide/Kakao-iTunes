//
//  ApplicationData.swift
//  Kakao&iTunes
//
//  Created by NC0201024 on 2018. 5. 27..
//  Copyright © 2018년 wisewood. All rights reserved.
//

import UIKit

class ApplicationData: NSObject {
    var appName:String? = ""
    var appTitle:String? = ""
    var appRights:String? = ""
    var appSummary:String? = ""
    var appLink:String? = ""
    var appImageUrlStr:String? = ""
    
    ///셀 확장표기시 기억값.
    var isExpandMode = false
    ///랭크. 받아온 순서대로.
    var rank:String = "0"
    
    class func createApplicationData(entryDic:NSDictionary) -> ApplicationData
    {
        let data:ApplicationData = ApplicationData.init()
        
        if let imName = entryDic["im:name"] as? NSDictionary {
            data.appName = imName["label"] as? String
        }
        
        if let title = entryDic["title"] as? NSDictionary {
            data.appTitle = title["label"] as? String
        }
        
        if let rights = entryDic["rights"] as? NSDictionary {
            data.appRights = rights["label"] as? String
        }
        
        if let summary = entryDic["summary"] as? NSDictionary {
            data.appSummary = summary["label"] as? String
        }
        
        if let link = entryDic["link"] as? NSDictionary {
            if let attributes = link["attributes"] as? NSDictionary {
                data.appLink = attributes["href"] as? String
            }
        }
        
        if let imImages = entryDic["im:image"] as? Array<Any> {
            //마지막 이미지가 가장 고화질.
            if let last = imImages.last as? NSDictionary {
                data.appImageUrlStr = last["label"] as? String
            }
        }
        
        
        
        
        return data
    }
    
}
