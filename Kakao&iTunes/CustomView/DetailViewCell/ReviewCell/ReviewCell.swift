//
//  ReviewCell.swift
//  Kakao&iTunes
//
//  Created by NC0201024 on 2018. 5. 29..
//  Copyright © 2018년 wisewood. All rights reserved.
//

import UIKit
import SnapKit

class ReviewCell: DetailCell {

    @IBOutlet weak var scrollView: UIScrollView!
    var childLinear:UIView?
    let reviewViewCount = 5
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellData(reviewDatas: Array<ReviewData>) {
        
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
        
        var index = 0
        for reviewData in reviewDatas {

            let reviewView = ReviewView.instanceFromNib()
            reviewView.frame = CGRect.init(x: lastX, y: 0, width: ivW, height: ivH)
            childLinear?.addSubview(reviewView)
            reviewView.setViewData(reviewData: reviewData)
            
            lastX = lastX + ivW + padding
            index = index + 1
            
            if index >= reviewViewCount
            {
                break
            }
        }
        
        scrollView.contentSize = CGSize.init(width: lastX, height: scrollView.frame.size.height)
    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        var pageNum = scrollView.contentOffset.x / scrollView.frame.size.width
//
//    }
}
