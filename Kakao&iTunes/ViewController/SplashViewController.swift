//
//  SplashViewController.swift
//  Kakao&iTunes
//
//  Created by NC0201024 on 2018. 5. 25..
//  Copyright © 2018년 wisewood. All rights reserved.
//

import UIKit

class SplashViewController: BaseViewController {
    
//    @IBOutlet weak var testImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.checkNetwork()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func networkCheckComplete() {
        super.networkCheckComplete()
        print("override NetworkCheckComplete")
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.changeRootViewController(rootView: .Main)
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
