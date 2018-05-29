//
//  BaseViewController.swift
//  Kakao&iTunes
//
//  Created by NC0201024 on 2018. 5. 25..
//  Copyright © 2018년 wisewood. All rights reserved.
//

import UIKit
import SwiftSpinner


extension String {
    
    /**
     가로가 정해진 상태에서의 세로 높이.
     - Parameter width : 텍스트가 표기될 가로 크기
     - Parameter font : 사용된 폰트
     - Returns: 세로높이
     */
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    /**
     세로가 정해진 상태에서의 가로 길이
     - Parameter height : 텍스트가 표기될 세로 크기
     - Parameter font : 사용된 폰트
     - Returns: 가로 길이
     */
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}


class BaseViewController: UIViewController, NetworkPopupDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //네비게이션 바 하단라인 없애기
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
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
                        //셀룰러 경고.
                        self.showWifiWarningPopup()
                    }
                    else
                    {
                        //진입한다.
                        self.networkCheckComplete()
                    }
                }
                else
                {
                    //네트워크 연결안됨.
                    self.showNetworkNotAbleToConnectPopup()
                }
            })
        }
    }
    
    /**
     네트워크 연결체크 종료. checkNetwork 이후 와이파이 상태이거나, 셀룰러지만 사용자가 진입을 요청한 경우 호출된다.
     사용시, VC에서 override 하여 사용하는것을 권장한다.
     */
    func networkCheckComplete()
    {
        print("Base VC NetworkCheckComplete")
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
                    //사용자가 진입요청. 이때는 와이파이를 구분하지 않고 연결상태만 확인.
                    self.networkCheckComplete()
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
    func showNetworkNotAbleToConnectPopup()
    {
        let pop = NetworkPopup.instanceFromNib()
        pop.initSetting()
        pop.setNetworkConnectionMode()
        pop.delegate = self
        self.view.addSubview(pop)
        pop.center = CGPoint.init(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
    }

    
}
