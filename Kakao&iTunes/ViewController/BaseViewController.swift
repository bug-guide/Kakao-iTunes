//
//  BaseViewController.swift
//  Kakao&iTunes
//
//  Created by NC0201024 on 2018. 5. 25..
//  Copyright © 2018년 wisewood. All rights reserved.
//

import UIKit
import SwiftSpinner

class BaseViewController: UIViewController, NetworkPopupDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     네트워크 체크. 연결상태, cellular, wifi를 가를 수 있다.
     상태에 따라서 재검사, 진입, 권고의 상태로 변경한다.
     */
    func checkNetwork()
    {
        SwiftSpinner.show("Check Network", animated: true)
        AppDataManager.shared.connectedToNetwork { (isConnect, isCellular) in
            
            SwiftSpinner.hide({
                if isConnect
                {
                    if isCellular
                    {
                        self.showWifiWarningPopup()
                    }
                    else
                    {
                        SwiftSpinner.show("Getty Page\nParsing", animated: true)
                        //AppDataManager.shared.startAppDataLoding()
                    }
                }
                else
                {
                    self.showNetworkConnectPopup()
                }
            })
        }
    }
    
    // MARK: - network popup
    func networkPopupClickAction(mode: NPopMode) {
        if mode == .RETRY
        {
            //네트워크 다시 체크.
            self.checkNetwork()
        }
        else if mode == .TRY
        {
            //그냥 진입.
            //헌데 그때 네트워크가 나갈 수 있다. 다시한번 보고 connect 일때만 통과.
            AppDataManager.shared.connectedToNetwork { (isConnect, isCellular) in
                if isConnect
                {
                    SwiftSpinner.show("Getty Page\nParsing", animated: true)
                    //AppDataManager.shared.startAppDataLoding()
                }
                else
                {
                    self.checkNetwork()
                }
            }
        }
    }
    
    /**
     와이파이상태로 전환해야할때 사용자에게 알림
     */
    func showWifiWarningPopup()
    {
        let pop = NetworkPopup.instanceFromNib()
        pop.initSetting()
        pop.setCellularMode()
        pop.delegate = self
        self.view.addSubview(pop)
        pop.center = CGPoint.init(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
    }
    
    /**
     네트워크가 연결되어있지 않을때 사용자 알림
     */
    func showNetworkConnectPopup()
    {
        let pop = NetworkPopup.instanceFromNib()
        pop.initSetting()
        pop.setNetworkConnectionMode()
        pop.delegate = self
        self.view.addSubview(pop)
        pop.center = CGPoint.init(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
    }

    
}
