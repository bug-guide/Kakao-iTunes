//
//  MainViewController.swift
//  Kakao&iTunes
//
//  Created by NC0201024 on 2018. 5. 25..
//  Copyright © 2018년 wisewood. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController {
    
    var arrApplicationData:Array<ApplicationData>? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        AppDataManager.shared.requestTopFreeApp { (isSuccess, entryData) in
            if isSuccess {
                
                if entryData?.count != 0 {
                    for entry in entryData! {
                        let data = ApplicationData.createApplicationData(entryDic: entry as! NSDictionary)
                        self.arrApplicationData?.append(data)
                    }
                    
                    print("end")
                }
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

