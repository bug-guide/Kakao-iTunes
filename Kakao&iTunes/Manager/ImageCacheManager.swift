//
//  ImageCacheManager.swift
//  Kakao&iTunes
//
//  Created by NC0201024 on 2018. 5. 25..
//  Copyright © 2018년 wisewood. All rights reserved.
//

import UIKit

/**
 ## Class Info
 이미지 캐시에 사용할 매니저. 작업처리 순서는 다음과같다.
 1.url을 받아와서 메모리에 있는지 확인.
 2.디스크에 있는지 확인.
 3.url 기반으로 데이터 로딩.
 4.저장
 
 ## Main future
 - 이미지를 메모리와 디스크에 각각 저장한다. 불러올때 메모리-디스크-다운로드 순서대로 확인한다.
 - 데이터 사용량을 줄일 수 있다.
 
 ## Usage
 - 간단하게 get 함수만 호출하도록 짜보자.
 - loadImage 함수만 접근을 허용한다.
 - 내부의 저장, 불러오기는 클래스 내부에서 알아서 처리함.
 */
class ImageCacheManager: NSObject {
    
    static let shared:ImageCacheManager = ImageCacheManager()
    
    /// 메모리캐시는 밖에선 직접접근 못하도록 막아두자.
    private var memoryCache:NSCache<NSString, UIImage>
    
    // MARK: - method
    
    /// 초기화. 캐시 사이즈가 셋팅된다.
    override init(){
        //print("ImageCacheManager init")
        memoryCache = NSCache.init()
    }
    
    /**
     이미지 불러오기. 메모리조회 -> 디스크조회 -> 다운로드의 순서대로 구현되어있다.
     중간에 하나 걸리면 메모리로 올려서 다음 조회시 딜레이를 최소화한다.
     - Parameter urlString : 이미지 url주소. 해당 주소는 이미지의 이름으로도 쓰인다.
     - Parameter complete : 완료 클로저. 이미지나 에러를 반환한다. 둘다 nil일수도 있다.
     - Returns: 없음. 클로저에서 모두 해결해야한다.
     */
    func loadImage(_ urlString:String, complete:@escaping (UIImage?, String?, Error?) -> Void)
    {
        var image:UIImage? = nil
        
        guard !urlString.isEmpty else {
            complete(nil, urlString, nil)
            return
        }
        
        //print("loadImage" + urlString)
        let filename = self.getFileName(urlString)
        if filename.isEmpty
        {
            complete(nil, urlString, nil)
            return
        }
        
        //print("file name : " + filename)
        
        // 캐시매모리 검사하기
        let memoryImage = loadMemoryCacheImage(filename)
        //print(memoryImage ?? "xxx")
        if memoryImage != nil {
            image = memoryImage
            complete(image, urlString, nil)
            return
        }
        
        let diskImage = loadDiskCacheImage(filename)
        if diskImage != nil {
            image = diskImage
            //가저온 디스크 이미지는 메모리에 저장.
            saveMemoryCacheImage(image!, key: filename)
            complete(image, urlString, nil)
            return
        }
        
        self.downloadImage(urlString, complete: complete)
    }
    
    // MARK: - Memory Cache
    
    /**
     메모리에서 이미지를 불러본다.
     - Parameter fileName : 저장할때 사용한 key값.
     - Returns: 이미지.
     */
    private func loadMemoryCacheImage(_ fileName:String) -> UIImage?
    {
        guard let image = memoryCache.object(forKey: fileName as NSString) else {
            return nil
        }
        return image
    }
    
    /**
     메모리에 이미지 저장. 성공여부가 반환되지 않는다.
     - Parameter image : 저장할 이미지
     - Parameter key : 키값. 저장될 이름.
     */
    private func saveMemoryCacheImage(_ image:UIImage, key:String)
    {
        //성공여부가 안나오네...? 잘 들어가겠다만. 음...
        memoryCache.setObject(image, forKey: key as NSString)
    }
    
    
    /**
     디스크에서 이미지 가져오기
     - Parameter fileName : 저장할때 사용한 key값.
     - Returns: 이미지.
     */
    private func loadDiskCacheImage(_ fileName:String) -> UIImage?
    {
        let directoryPath =  NSHomeDirectory().appending("/Documents/")
        if !FileManager.default.fileExists(atPath: directoryPath) {
            do {
                try FileManager.default.createDirectory(at: NSURL.fileURL(withPath: directoryPath), withIntermediateDirectories: true, attributes: nil)
            } catch {
                //print(error)
            }
        }
        
        let fileName = fileName.appending(".png")
        let filepath = directoryPath.appending(fileName)
        
        guard let image = UIImage.init(contentsOfFile: filepath) else {
            return nil
        }
        
        return image;
    }
    
    /**
     디스크에 이미지 저장. 성공여부가 반환되지 않는다. png형식으로 저장한다.
     - Parameter image : 저장할 이미지
     - Parameter key : 키값. 저장될 이름.
     */
    private func saveDiskCacheImage(_ image:UIImage, key:String)
    {
        let directoryPath =  NSHomeDirectory().appending("/Documents/")
        if !FileManager.default.fileExists(atPath: directoryPath) {
            do {
                try FileManager.default.createDirectory(at: NSURL.fileURL(withPath: directoryPath), withIntermediateDirectories: true, attributes: nil)
            } catch {
                //print(error)
            }
        }
        
        let fileName = key.appending(".png")
        let filepath = directoryPath.appending(fileName)
        
        guard let data = UIImagePNGRepresentation(image) else {
            return
        }
        
        let fileUrl = URL.init(fileURLWithPath: filepath)
        try? data.write(to: fileUrl)
    }
    
    // MARK: - etc
    
    /**
     이미지 다운로드. 바동기로 실행되며, load시에 던진 클로저를 그대로 들고온다.
     이미지가 저장되면 해당클로저로 동일하게 완료신호를 보낸다.
     메모리와 디스크에 모두 저장한다.
     - Parameter urlStr : 이미지 url
     - Parameter complete : 완료 클로저. load시에 들어온 녀석을 계속 사용한다.
     */
    private func downloadImage(_ urlStr:String, complete:@escaping (UIImage?, String?, Error?) -> Void)
    {
        guard let url:URL = URL.init(string: urlStr) else {
            complete(nil, urlStr, nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            //print("dataTask")
            if error != nil {
                complete(nil, urlStr, error)
                return
            }
            
            guard let data = data else {
                complete(nil, urlStr, error)
                return
            }
            
            DispatchQueue.main.async(execute: {
                let filename = self.getFileName(urlStr)
                guard let image = UIImage.init(data: data) else {
                    complete(nil, urlStr, nil)
                    return
                }
                
                //메모리 저장
                self.saveMemoryCacheImage(image, key: filename)
                //디스크 저장
                self.saveDiskCacheImage(image, key: filename)
                complete(image, urlStr, nil)
            })
            }.resume()
    }
    
    /**
     파일네임만들기
     - Parameter urlStr : 이미지 url을 percentEncoding을 통해 일반 스트링으로변경. 파일 저장의 이름으로 쓴다. 차후 다른 방식으로 변경할 경우 이곳을 수정할 수 있다.
     - Returns: 파일이름
     */
    private func getFileName(_ urlStr:String) -> String {
        guard let filename = urlStr.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else{
            return "tempimage"
        }
        
        return filename
    }
}
