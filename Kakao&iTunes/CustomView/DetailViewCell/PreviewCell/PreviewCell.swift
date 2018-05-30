//
//  PreviewCell.swift
//  Kakao&iTunes
//
//  Created by NC0201024 on 2018. 5. 29..
//  Copyright © 2018년 wisewood. All rights reserved.
//

import UIKit
import SnapKit
import ChameleonFramework

class PreviewCell: DetailCell {

    @IBOutlet weak var previewScroll: UIScrollView!
    @IBOutlet weak var previewScrollH: NSLayoutConstraint!

    var childLinear:UIView?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setCellData(_ lookupData: LookUpData) {
        super.setCellData(lookupData)
        
        if childLinear != nil{
            childLinear?.removeFromSuperview()
            childLinear = nil
        }

        childLinear = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: previewScroll.frame.size.width))
        previewScroll.addSubview(self.childLinear!)
        childLinear!.backgroundColor = UIColor.flatRed()
        
        var lastX:CGFloat = 0.0
        let padding:CGFloat = 10
        let ivH = previewScroll!.frame.size.height
        let ivW = ivH/1.77
        for urlStr in lookupData.screenshotUrls! {
            
            let imageView = UIImageView.init(frame: CGRect.init(x: lastX, y: 0, width: ivW, height: ivH))
            imageView.backgroundColor = UIColor.flatLime()
            ImageCacheManager.shared.loadImage(urlStr) { (image, url, error) in
                imageView.image = image
            }
            
            childLinear?.addSubview(imageView)
            lastX = lastX + ivW + padding
        }
        
        previewScroll.contentSize = CGSize.init(width: lastX, height: previewScroll.frame.size.height)
    }
    
}
