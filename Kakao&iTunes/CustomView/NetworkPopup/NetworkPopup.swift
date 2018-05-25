//
//  NetworkPopup.swift
//  Kakao&Getty
//
//  Created by NC0201024 on 2018. 4. 15..
//  Copyright © 2018년 wisewood. All rights reserved.
//

import UIKit
import ChameleonFramework

///네트워크 팝업이 뜨는 형태
enum NPopMode:String {
    ///재시도.
    case RETRY = "RETRY"
    ///단순 창닫기
    case RETRY_CLOSE = "RETRY_CLOSE"
    ///진행
    case TRY = "TRY"
}

protocol NetworkPopupDelegate {
    ///팝업을 닫을때 호출된다.(스스로를 지운다)
    func networkPopupClickAction(mode:NPopMode)
}

/**
 ## Class Info
 네트워크 경고를 담은 팝업클래스.
 
 ## Main future
 - 네트워크 끈김, lte, wifi 상태에 따라 다른 팝업을 보여준다.
 
 ## Usage
 ```
 let pop = NetworkPopup.instanceFromNib()
 pop.initSetting()
 pop.setCellularMode()
 pop.delegate = self
 self.view.addSubview(pop)
 pop.center = CGPoint.init(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
 ```
 */
class NetworkPopup: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var messageBox: UIView!
    @IBOutlet weak var iconBox: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var delegate:NetworkPopupDelegate?
    var mode:NPopMode = .RETRY
    
    // MARK: - method
    
    /**
     코드에서 생성할때 init(frame:) 대신 사용할것.
     - Returns: 생성된 NetworkPopup.
     */
    class func instanceFromNib() -> NetworkPopup {
        return UINib(nibName: "NetworkPopup", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! NetworkPopup
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initSetting()
    {
        self.backgroundColor = UIColor.clear
        
        iconBox.layer.cornerRadius = iconBox.frame.size.width/2
        iconBox.clipsToBounds = true
        iconBox.layer.borderColor = UIColor.white.cgColor
        iconBox.layer.borderWidth = 7.0
        
        button.layer.cornerRadius = 2.0
        button.clipsToBounds = true
        
        messageBox.layer.shadowColor = UIColor.flatGray().cgColor
        messageBox.layer.shadowOffset = CGSize.init(width: 1.0, height: 1.0)
        messageBox.layer.shadowRadius = 1.0
        messageBox.layer.shadowOpacity = 1.0
        messageBox.layer.masksToBounds = false
        messageBox.layer.shadowPath = UIBezierPath.init(roundedRect: messageBox.bounds, cornerRadius: messageBox.layer.cornerRadius).cgPath
    }
    
    ///네트워크가 안잡힐때
    func setNetworkConnectionMode(){
        messageLabel.text = "아무래도 네트워크 연결이 없는것 같습니다!\n단말의 네트워크 연결을 확인해주세요!"
        button.setTitle("Retry", for: UIControlState.normal)
        button.backgroundColor = UIColor.flatRed()
        iconBox.backgroundColor = UIColor.flatRed()
        iconImageView.image = UIImage.init(named: "ic_network")
        mode = .RETRY
    }
    
    ///네트워크가 안잡힌 상태에서 경고만 할떄.
    func setNetworkConnectionCloseMode(){
        messageLabel.text = "아무래도 네트워크 연결이 없는것 같습니다!\n단말의 네트워크 연결을 확인해주세요!"
        button.setTitle("Close", for: UIControlState.normal)
        button.backgroundColor = UIColor.flatRed()
        iconBox.backgroundColor = UIColor.flatRed()
        iconImageView.image = UIImage.init(named: "ic_network")
        mode = .RETRY_CLOSE
    }
    
    ///네트워크가 잡혔지만 셀룰러일때.
    func setCellularMode(){
        messageLabel.text = "아무래도 Wifi 연결이 없는것 같습니다\n그래도 계속 진행하실 건가요?"
        button.setTitle("Try!", for: UIControlState.normal)
        button.backgroundColor = UIColor.flatGreen()
        iconBox.backgroundColor = UIColor.flatGreen()
        iconImageView.image = UIImage.init(named: "ic_wifi")
        mode = .TRY
    }
    
    @IBAction func clickAction(_ sender: Any) {
        UIView.animate(withDuration: 0.1, animations: {
            self.removeFromSuperview()
        }) { (end) in
            if self.delegate != nil
            {
                self.delegate?.networkPopupClickAction(mode: self.mode)
            }
        }
        
    }
    
}
