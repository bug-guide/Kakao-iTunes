//
//  SplashViewController.swift
//  Kakao&iTunes
//
//  Created by NC0201024 on 2018. 5. 25..
//  Copyright © 2018년 wisewood. All rights reserved.
//

import UIKit
import SnapKit

class SplashViewController: BaseViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControll: UIPageControl!
    
    var childLinear:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: {
            self.backImageView.alpha = 0.6
        }) { (isComplete) in }
        
        self.setGuideImageView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
    @IBAction func startAction(_ sender: Any) {
        self.checkNetwork()
    }
    
    func setGuideImageView() {
        
        scrollView.delegate = self
        
        if childLinear != nil{
            childLinear?.removeFromSuperview()
            childLinear = nil
        }
        
        childLinear = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: scrollView.frame.size.width))
        scrollView.addSubview(self.childLinear!)
        //        scrollView.delegate = self
        //childLinear!.backgroundColor = UIColor.flatRed()
        
        var lastX:CGFloat = 0.0
        let padding:CGFloat = 0
        let ivH = scrollView!.frame.size.height
        let ivW = scrollView!.frame.size.width
        
        for index in 1..<5 {
            
            let imageView = UIImageView.init(frame: CGRect.init(x: lastX, y: 0, width: ivW, height: ivH))
            imageView.contentMode = .scaleAspectFit
            let imageName = "guide_0\(index)"
            imageView.image = UIImage.init(named: imageName)
            
            childLinear?.addSubview(imageView)
            imageView.snp.makeConstraints { (make) in
                
                let centerStart = self.scrollView.frame.size.width/2
                let centerX = centerStart+(self.scrollView.frame.size.width*CGFloat(index-1))
                
                make.height.equalTo(self.scrollView)
                make.centerY.equalTo(self.scrollView)
                make.centerX.equalTo(centerX)
            }
            lastX = lastX + ivW + padding
        }
        
        scrollView.contentSize = CGSize.init(width: lastX, height: 300)
        pageControll.numberOfPages = 4
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNum = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControll.currentPage = Int(pageNum)
    }

}
