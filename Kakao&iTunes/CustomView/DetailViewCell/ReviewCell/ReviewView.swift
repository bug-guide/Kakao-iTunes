//
//  ReviewView.swift
//  Kakao&iTunes
//
//  Created by NC0201024 on 2018. 5. 29..
//  Copyright © 2018년 wisewood. All rights reserved.
//

import UIKit
import Cosmos

class ReviewView: UIView {

    @IBOutlet weak var innerView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var contentLabelH: NSLayoutConstraint!
    @IBOutlet weak var contentLabelW: NSLayoutConstraint!
    class func instanceFromNib() -> ReviewView {
        return UINib(nibName: "ReviewView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ReviewView
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setViewData(reviewData:ReviewData) {
        
        innerView.layer.cornerRadius = 5
        innerView.clipsToBounds = true
        
        titleLabel.text = reviewData.title
        userNameLabel.text = reviewData.userName
        contentLabel.text = reviewData.content
        ratingView.rating = Double(reviewData.rating!)!
        
        let w = UIScreen.main.bounds.width - 60
        let contentTextH = reviewData.content?.height(withConstrainedWidth: w, font: contentLabel.font)
        let maxH = self.contentViewMaxSizeH()
        if contentTextH! < maxH {
            contentLabelH.constant = contentTextH! + 20
//            contentLabel.frame = CGRect.init(x: contentLabel.frame.origin.x, y: contentLabel.frame.origin.y, width: contentLabel.frame.size.width, height: contentTextH!)
        } else {
            contentLabelH.constant = maxH
//            contentLabel.frame = CGRect.init(x: contentLabel.frame.origin.x, y: contentLabel.frame.origin.y, width: contentLabel.frame.size.width, height: maxH)
        }
 
    }
    
    func contentViewMaxSizeH() -> CGFloat {
        let maxSizeH = self.frame.size.height - contentLabel.frame.origin.y - 10
        return maxSizeH
    }
}
