//
//  DetailViewController.swift
//  Kakao&iTunes
//
//  Created by NC0201024 on 2018. 5. 27..
//  Copyright © 2018년 wisewood. All rights reserved.
//

import UIKit
import SwiftSpinner

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var applicationData:ApplicationData!
    var lookUpData:LookUpData?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hCell = UINib.init(nibName: "HeadInfoCell", bundle: nil)
        tableView.register(hCell, forCellReuseIdentifier: "HeadInfoCell")
        
        let rCell = UINib.init(nibName: "ReleaseNotesCell", bundle: nil)
        tableView.register(rCell, forCellReuseIdentifier: "ReleaseNotesCell")
        
        let pCell = UINib.init(nibName: "PreviewCell", bundle: nil)
        tableView.register(pCell, forCellReuseIdentifier: "PreviewCell")
        
        let dCell = UINib.init(nibName: "DescriptionCell", bundle: nil)
        tableView.register(dCell, forCellReuseIdentifier: "DescriptionCell")
        
        
        //데이터 가져오기.
        let appId = applicationData.appId ?? ""
        
        SwiftSpinner.show("get LookUpData")
        AppDataManager.shared.requestLookup(appId) { (isSuccess, result) in
            
            if isSuccess {
                self.lookUpData = LookUpData.createData(result: result!)
                self.lookUpData?.appImageUrlStr = self.applicationData.appImageUrlStr
                self.lookUpData?.rankingStr = "#\(self.applicationData.rank)"
                
                //스토리보드에서 dataSource, delegate 를 지정할경우 통신 완료 전 reload가 될 수 있다.
                self.tableView.dataSource = self
                self.tableView.delegate = self
                self.tableView.reloadData()
            }
            else {
                //
            }
            
            SwiftSpinner.hide()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let detailCell = getCell(indexPathRow: indexPath.row)
        if indexPath.row == 1
        {
            return (detailCell as! ReleaseNotesCell).getCellH(lookUpData?.releaseNotes ?? "")
        } else if indexPath.row == 3 {
            return (detailCell as! DescriptionCell).getCellH(lookUpData?.appDescription ?? "")
        }
        
        
        return detailCell.getCellH()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let detailCell = getCell(indexPathRow: indexPath.row)
        detailCell.setCellData(self.lookUpData!)
        return detailCell
    }
    
    func getCell(indexPathRow:Int) -> DetailCell
    {
        var detailCell:DetailCell = DetailCell.init()
        if indexPathRow == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HeadInfoCell") as? HeadInfoCell else {
                return detailCell
            }
            detailCell = cell
        } else if indexPathRow == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReleaseNotesCell") as? ReleaseNotesCell else {
                return detailCell
            }
            detailCell = cell
        } else if indexPathRow == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PreviewCell") as? PreviewCell else {
                return detailCell
            }
            detailCell = cell
        } else if indexPathRow == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell") as? DescriptionCell else {
                return detailCell
            }
            detailCell = cell
        }
        
        return detailCell
    }

}
