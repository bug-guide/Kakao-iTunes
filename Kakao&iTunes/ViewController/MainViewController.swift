//
//  MainViewController.swift
//  Kakao&iTunes
//
//  Created by NC0201024 on 2018. 5. 25..
//  Copyright © 2018년 wisewood. All rights reserved.
//

import UIKit
import SwiftSpinner

class MainViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    

    var arrApplicationData:Array<ApplicationData>? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //expandablecell load
        let eCell = UINib.init(nibName: "ExpandableCell", bundle: nil)
        tableView.register(eCell, forCellReuseIdentifier: "ExpandableCell")
        
        SwiftSpinner.show("TopFreeApp")
        AppDataManager.shared.requestTopFreeApp { (isSuccess, entryData) in
            if isSuccess {
                
                if entryData?.count != 0 {
                    for entry in entryData! {
                        let data = ApplicationData.createApplicationData(entryDic: entry as! NSDictionary)
                        self.arrApplicationData?.append(data)
                    }
                    SwiftSpinner.hide()
                    self.tableView.reloadData()
                    print("end")
                }
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (arrApplicationData?.count)!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let data:ApplicationData = arrApplicationData![indexPath.row]
        if data.isExpandMode {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandableCell") as? ExpandableCell else {
                return ExpandableCell.CellCloseH
            }
            
            return cell.calculateCellExpandH(descriptionStr: data.appSummary!)
        }
        else
        {
            return ExpandableCell.CellCloseH
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandableCell") as? ExpandableCell else {
            return UITableViewCell()
        }
        
        let data:ApplicationData = arrApplicationData![indexPath.row]
        data.rank = String(indexPath.row + 1)
        cell.setCellData(data: data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data:ApplicationData = arrApplicationData![indexPath.row]
        data.isExpandMode = !data.isExpandMode
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

}

