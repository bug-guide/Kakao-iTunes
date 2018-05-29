//
//  ExpandableCell.swift
//  Kakao&iTunes
//
//  Created by NC0201024 on 2018. 5. 28..
//  Copyright © 2018년 wisewood. All rights reserved.
//

import UIKit
import ChameleonFramework

protocol ExpandableCellProtocol {
    func detailAction(indexPath:IndexPath)
}

class ExpandableCell: UITableViewCell {

    //셀 확장 전 크기값. xib와 일치시켜야한다. 계산값의 기본값으로 사용된다.
    public static let CellCloseH:CGFloat = 80
    var indexPath:IndexPath?
    var delegate:ExpandableCellProtocol?
    
    @IBOutlet weak var iconView: UrlTagImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var descriptionInnerView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var rankW: NSLayoutConstraint!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //셀 배경색이 없을경우 expand 에니메이션시 에니메이션 튀는 부분이 보인다.
        self.backgroundColor = UIColor.white
        
        iconView.layer.cornerRadius = 10
        iconView.clipsToBounds = true
        iconView.layer.borderWidth = 0.3
        iconView.layer.borderColor = UIColor.flatGray().cgColor
        
        descriptionInnerView.layer.cornerRadius = 5
        descriptionInnerView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellData(data:ApplicationData, indexPath:IndexPath) {
        
        self.indexPath = indexPath
        
        //재활용시 이미지가 복수 로딩되는것을 막아야한다.
        //마지막에 로딩을 주문한 녀석을 찾기위해 뷰 자체에 직접 태그를 건다.
        iconView.urlTag = data.appImageUrlStr ?? ""
        ImageCacheManager.shared.loadImage(data.appImageUrlStr ?? "") { (image, urlStr, error) in
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
        
        let rankLabelW = data.rank.width(withConstrainedHeight: rankLabel.frame.size.height, font: rankLabel.font)
        rankW.constant = rankLabelW
        rankLabel.text = data.rank
        
        nameLabel.text = data.appName
        subTitleLabel.text = data.appTitle
        
        descriptionLabel.text = data.appSummary
        if data.isExpandMode {
            descriptionInnerView.isHidden = false
        }
        else
        {
            descriptionInnerView.isHidden = true
        }
        
    }
    
    func calculateCellExpandH(descriptionStr:String) -> CGFloat {
        let descriptionLabelW =  (UIScreen.main.bounds.size.width - 40)
        let descriptionH = descriptionStr.height(withConstrainedWidth: descriptionLabelW, font: descriptionLabel.font)
        //cell 크기는 description H + 여백 ( [10 [10 [label] 10] 10]) + 기본 셀 크기() + 한글 보정값(한글의 경우 약간 더 길게 잡야야 ... 이 표기 안된다.)
        let cellH = descriptionH + 40 + ExpandableCell.CellCloseH + 10
        return cellH
    }
    
    @IBAction func detailAction(_ sender: Any) {
        if let delegate = delegate {
            delegate.detailAction(indexPath: self.indexPath!)
        }
    }
    
}
