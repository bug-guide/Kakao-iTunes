//
//  HeadInfoCell.swift
//  Kakao&iTunes
//
//  Created by NC0201024 on 2018. 5. 28..
//  Copyright © 2018년 wisewood. All rights reserved.
//

import UIKit
import Cosmos

class HeadInfoCell: DetailCell {

    @IBOutlet weak var iconView: UrlTagImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingStar: CosmosView!
    @IBOutlet weak var ratingTextLabel: UILabel!
    
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var caRatingLabel: UILabel!
    
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
        
        iconView.urlTag = lookupData.appImageUrlStr ?? ""
        ImageCacheManager.shared.loadImage(lookupData.appImageUrlStr ?? "") { (image, urlStr, error) in
            if urlStr == self.iconView.urlTag
            {
                //두개가 일치하면 로딩요청된 뷰로 인식한다.
                self.iconView.image = image
            }
            else
            {
                //로딩 요청되었을때와 다른 뷰. 재활용된 상태.
            }
        }
        
        titleLabel.text = lookupData.trackName
        
        companyLabel.text = lookupData.sellerName
        ratingLabel.text = "\(lookupData.averageUserRating)"
        ratingStar.rating = Double(lookupData.averageUserRating)
        
        rankingLabel.text = lookupData.rankingStr
        caRatingLabel.text = lookupData.contentAdvisoryRating
        
    }
}
