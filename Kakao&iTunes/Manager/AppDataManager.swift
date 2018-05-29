//
//  AppDataManager.swift
//  Kakao&iTunes
//
//  Created by NC0201024 on 2018. 5. 25..
//  Copyright © 2018년 wisewood. All rights reserved.
//

import UIKit
import SystemConfiguration

@objc protocol AppDataManagerDelegate {
    @objc optional func appDataManagerHtmlParserEnd()
}

/**
 ## Class Info
 앱에서 사용하는 데이터를 모두 관리한다.
 파서와 뷰의 중간다리 역할을 한다.
 */
class AppDataManager: NSObject {
    
    enum SEG_NAME: String {
        case Main = "Main"
        case Detail = "Detail"
    }
    
    static let shared:AppDataManager = AppDataManager()
    var delegate:AppDataManagerDelegate?
    
    let SCHMA:String = "https://"
    let HOST:String = "itunes.apple.com"
    let URL_TOP_FREE:String = "/kr/rss/topfreeapplications/limit=50/genre=6015/json"
    var URL_APPID:String = ""
    var URL_LOOKUP_APP:String {
        get {
            return "/lookup?id=\(URL_APPID)&country=kr"
        }
    }
    var URL_REVIEW_APP:String {
        get {
            return "/kr/rss/customerreviews/id=\(URL_APPID)/sortBy=mostRecent/json"
        }
    }
    
    
    func requestTopFreeApp(complete:@escaping (_ isSuccess:Bool, _ entryData:Array<Any>?)->Void)
    {
        let urlStr = SCHMA + HOST + URL_TOP_FREE
        guard let url = URL.init(string: urlStr) else {
            complete(false, nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            var isSuccess:Bool = false
            var entryData:Array<Any>? = nil
            
            guard let httpRes = response as? HTTPURLResponse, httpRes.statusCode == 200 else {
                DispatchQueue.main.async {
                    complete(false, nil)
                }
                return
            }
            
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    complete(false, nil)
                }
                return
            }
            
            do {
                if let jsonDic = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: AnyObject] {
                    //print(jsonDic)
                    
                    isSuccess = true
                    if let feed = jsonDic["feed"] {
                        if let entry = feed["entry"] as? Array<Any> {
                            entryData = entry
                        }
                    }
                }
            } catch {
                print("JSON 파상 에러")
                isSuccess = false
            }
            
            print("JSON 파싱 완료")
            
            // 메일 쓰레드에서 화면 갱신
            DispatchQueue.main.async {
                complete(isSuccess, entryData)
                return
            }
        }
        
        task.resume()
    }
    
    func requestLookup(_ appId:String, complete:@escaping (_ isSuccess:Bool, _ result:NSDictionary?)->Void)
    {
        URL_APPID = appId
        let urlStr = SCHMA + HOST + URL_LOOKUP_APP
        guard let url = URL.init(string: urlStr) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            var isSuccess:Bool = false
            var result:NSDictionary? = nil
            
            guard let httpRes = response as? HTTPURLResponse, httpRes.statusCode == 200 else {
                DispatchQueue.main.async {
                    complete(false, nil)
                }
                return
            }
            
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    complete(false, nil)
                }
                return
            }
            
            do {
                if let jsonDic = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: AnyObject] {
                    //print(jsonDic)
                    if let results = jsonDic["results"] as? Array<Any>, results.count != 0 {
                        isSuccess = true
                        result = results.last as? NSDictionary
                    }
                    
                }
            } catch {
                print("JSON 파상 에러")
            }
            
            print("JSON 파싱 완료")
            
            // 메일 쓰레드에서 화면 갱신
            DispatchQueue.main.async {
                complete(isSuccess, result)
                return
            }
        }
        
        task.resume()
    }
    
    func requestReviews(_ appId:String, complete:@escaping (_ isSuccess:Bool, _ reviewDatas:Array<ReviewData>?)->Void) {
        
        let urlStr = SCHMA + HOST + URL_REVIEW_APP
        guard let url = URL.init(string: urlStr) else {
            complete(false, nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            var isSuccess:Bool = false
            var reviewDatas:Array<ReviewData>? = nil
            
            guard let httpRes = response as? HTTPURLResponse, httpRes.statusCode == 200 else {
                DispatchQueue.main.async {
                    complete(false, nil)
                }
                return
            }
            
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    complete(false, nil)
                }
                return
            }
            
            do {
                if let jsonDic = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: AnyObject] {
                    //print(jsonDic)
                    isSuccess = true
                    
                    
                    if let feed = jsonDic["feed"] {
                        if var entry = feed["entry"] as? Array<Any> {
                            //0번은 앱정보. 중복.
                            //1~n개 까지가 리뷰정보.
                            entry.remove(at: 0)
                            reviewDatas = []
                            for eData in entry {
                                let reviewData = ReviewData.createReviewData(reviewDic: eData as! NSDictionary)
                                reviewDatas?.append(reviewData)
                            }
                        }
                    }
                }
            } catch {
                print("JSON 파상 에러")
                isSuccess = false
            }
            
            print("JSON 파싱 완료")
            
            // 메일 쓰레드에서 화면 갱신
            DispatchQueue.main.async {
                complete(isSuccess, reviewDatas)
                return
            }
        }
        
        task.resume()
    }
    
    
    // MARK: - etc
    
    /**
     네트워크 상태체그.
     - Parameter connected : 연결상태
     - Parameter cellular : cellular 상태 ? wifi 상태
     */
    func connectedToNetwork(complete:(_ connected:Bool, _ cellular:Bool)->Void){
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            complete(false, false)
            return
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            complete(false, false)
            return
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let cellular = flags.contains(.isWWAN)
        
        complete((isReachable && !needsConnection), cellular)
        return
    }
}
