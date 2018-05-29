//
//  ReleaseNotesCell.swift
//  Kakao&iTunes
//
//  Created by NC0201024 on 2018. 5. 29..
//  Copyright © 2018년 wisewood. All rights reserved.
//

import UIKit

class ReleaseNotesCell: DetailCell {

    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var releaseNoteLabel: UILabel!
    
    var releaseNoteStr = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.xibSizeH = 140
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func setCellData(_ lookupData: LookUpData) {
        super.setCellData(lookupData)
        
        versionLabel.text = "버전 \(lookupData.version ?? "0")"
        releaseNoteStr = lookupData.releaseNotes ?? ""
        releaseNoteLabel.text = releaseNoteStr
    }
    
    func getCellH(_ text:String) -> CGFloat {
        
        let w = UIScreen.main.bounds.width - 40
        let textSizeH = text.height(withConstrainedWidth: w, font: releaseNoteLabel.font)
        return xibSizeH + textSizeH - 30
    }
}
