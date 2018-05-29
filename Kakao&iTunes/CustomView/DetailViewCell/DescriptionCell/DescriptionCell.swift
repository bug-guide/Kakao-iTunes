//
//  DescriptionCell.swift
//  Kakao&iTunes
//
//  Created by NC0201024 on 2018. 5. 29..
//  Copyright © 2018년 wisewood. All rights reserved.
//

import UIKit

class DescriptionCell: DetailCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.xibSizeH = 60
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setCellData(_ lookupData: LookUpData) {
        super.setCellData(lookupData)
        descriptionLabel.text = lookupData.appDescription
    }
    
    func getCellH(_ text:String) -> CGFloat {
        
        let w = UIScreen.main.bounds.width - 40
        let textSizeH = text.height(withConstrainedWidth: w, font: descriptionLabel.font)
        return xibSizeH + textSizeH - 30
    }
    
}
