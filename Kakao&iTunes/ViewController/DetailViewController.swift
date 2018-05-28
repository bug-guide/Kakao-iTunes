//
//  DetailViewController.swift
//  Kakao&iTunes
//
//  Created by NC0201024 on 2018. 5. 27..
//  Copyright © 2018년 wisewood. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hCell = UINib.init(nibName: "HeadInfoCell", bundle: nil)
        tableView.register(hCell, forCellReuseIdentifier: "HeadInfoCell")
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HeadInfoCell") as? HeadInfoCell else {
            return DetailCell.init().getCellH()
        }
        
        return cell.getCellH()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HeadInfoCell") as? HeadInfoCell else {
            return UITableViewCell()
        }
        
        return cell
    }

}
