//
//  SplashViewController.swift
//  Kakao&iTunes
//
//  Created by NC0201024 on 2018. 5. 25..
//  Copyright © 2018년 wisewood. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    @IBOutlet weak var testImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppDataManager.shared.requestLookup("839333328")
        // Do any additional setup after loading the view.
        
//        ImageCacheManager.shared.loadImage("https://is2-ssl.mzstatic.com/image/thumb/Purple128/v4/88/fa/aa/88faaa32-178a-f204-a53b-11957097c2fc/source/392x696bb.jpg") { (image, urlStr, error) in
//            
//            self.testImageView.image = image
//            
//        }
//        
//        ImageCacheManager.shared.loadImage("https://is2-ssl.mzstatic.com/image/thumb/Purple128/v4/88/fa/aa/88faaa32-178a-f204-a53b-11957097c2fc/source/392x696bb.jpg") { (image, urlStr, error) in
//            
//            self.testImageView.image = image
//            
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
