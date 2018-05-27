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
    var URL_LOOKUP_APPID:String = ""
    var URL_LOOKUP_APP:String {
        get {
            return "/lookup?id=\(URL_LOOKUP_APPID)&country=kr"
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
    
    func requestLookup(_ appId:String)
    {
        URL_LOOKUP_APPID = appId
        let urlStr = SCHMA + HOST + URL_LOOKUP_APP
        guard let url = URL.init(string: urlStr) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let httpRes = response as? HTTPURLResponse, httpRes.statusCode == 200 else {
                return
            }
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            do {
                if let jsonDic = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: AnyObject] {
                    print(jsonDic)
                    
                }
            } catch {
                print("JSON 파상 에러")
            }
            
            print("JSON 파싱 완료")
            
            // 메일 쓰레드에서 화면 갱신
            DispatchQueue.main.async {
                
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
