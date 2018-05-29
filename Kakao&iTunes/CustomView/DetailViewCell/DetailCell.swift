//
//  DetailCell.swift
//  Kakao&iTunes
//
//  Created by NC0201024 on 2018. 5. 28..
//  Copyright © 2018년 wisewood. All rights reserved.
//

import UIKit

/**
 ## Class Info
 부모셀. detailViewController에서 사용하는 셀들이 워낙 많아서
 부모셀을 만들면 좋겠다고 생각. 공통기능을 몰아두자.
 
 ## Main future
 - 모든셀의 부모. 공통기능 부여.
 
 ## Usage
 - 상속해서 세부 셀을 적용하자.
 */
class DetailCell: UITableViewCell {

    var xibSizeH:CGFloat = 50
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCellData(_ lookupData:LookUpData) {
        //print("setCellData")
    }
    
    ///디테일뷰의 세로 셀 크기를 가로폭에 맞춰 조정한다.
    ///좀 더 비율에 맞춰 느슨~ 하게 보이도록.
    func getCellH() -> CGFloat {
        let screenW = UIScreen.main.bounds.width
        var rate:CGFloat = 1.0
        if screenW == 320 {
            rate = 1.0
        }
        else if screenW == 375 {
            rate = 1.1
        }
        
        let cellH = self.frame.size.height * rate
        return cellH
    }

}
