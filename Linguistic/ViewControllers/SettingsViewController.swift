//
//  SettingsViewController.swift
//  Linguistic
//
//  Created by Anton on 02/10/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0: return tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.LoginCell.rawValue)!
        default: return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    enum CellIdentifiers : String {
        case LoginCell = "LoginCell"
    }
    
}
