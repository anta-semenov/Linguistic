//
//  SettingsViewController.swift
//  Linguistic
//
//  Created by Anton on 02/10/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITableViewCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var languageSelectMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0: return tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.LoginCell.rawValue)!
        case 1: return getDefaultLanguageCell()
        case 2: return getLanguagePickerCell()
        default: return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch languageSelectMode {
        case true: return 3
        case false: return 2
        }
    }
    
    func getDefaultLanguageCell() -> UITableViewCell {
        if languageSelectMode {
            let langCell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.DefaultLanguageCell.rawValue)!
            if let defaultLanguage = NSUserDefaults.valueForKey("DefaultLanguage") as? String {
                langCell.detailTextLabel!.text = defaultLanguage
            } else {
                langCell.detailTextLabel!.text = ""
            }
            return langCell
        } else {
            let langCell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.DefaultLanguageConfirmSelectCell.rawValue)!
            return langCell
        }
    }
    
    func getLanguagePickerCell() -> UITableViewCell {
        let pickerCell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.LanguagePickerCell.rawValue) as! LanguagePickerCell
        pickerCell.delegate = self
        return pickerCell
    }
    
    func cellWasChanged<T : UITableViewCell>(cell: T) {
        
    }
    
    
    enum CellIdentifiers : String {
        case LoginCell = "LoginCell"
        case DefaultLanguageCell = "DefaultLanguageCell"
        case DefaultLanguageConfirmSelectCell = "DefaultLanguageConfirmSelectCell"
        case LanguagePickerCell = "LanguagePickerCell"
    }
    
}
