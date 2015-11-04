//
//  SettingsViewController.swift
//  Linguistic
//
//  Created by Anton on 02/10/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var languageSelectMode: Bool = false
    var selectedLanguageCode: String?
    var selectedLanguageName: String?
    var localeHelper: NSLocaleHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localeHelper = NSLocaleHelper()
        if let defaultLanguage = NSUserDefaults.standardUserDefaults().stringForKey(UserDefaultsKeys.MainLanguage.rawValue) {
            selectedLanguageCode = defaultLanguage
            selectedLanguageName = localeHelper.langCodesWithNames[selectedLanguageCode!]
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: - TableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, 0): return tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.LoginCell.rawValue)!
        case (1, 0): return getDefaultLanguageCell()
        case (1, 1): return getLanguagePickerCell()
        default: return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: if languageSelectMode {return 2} else {return 1}
        default: return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func getDefaultLanguageCell() -> UITableViewCell {
        var langCell: UITableViewCell
        if !languageSelectMode {
            langCell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.DefaultLanguageCell)!
            if let defaultLanguage = selectedLanguageName {
                langCell.detailTextLabel!.text = defaultLanguage
            } else {
                langCell.detailTextLabel!.text = ""
            }
        } else {
            langCell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.DefaultLanguageConfirmSelectCell)!
            if let defaultLanguage = selectedLanguageName {
                langCell.textLabel!.text = defaultLanguage
            } else {
                langCell.textLabel!.text = ""
            }
        }
        
        return langCell
    }
    
    func getLanguagePickerCell() -> UITableViewCell {
        let pickerCell = tableView.dequeueReusableCellWithIdentifier(CellIdentifiers.LanguagePickerCell) as! LanguagePickerCell
        pickerCell.langPickerView.dataSource = self
        pickerCell.langPickerView.delegate = self
        if let defaultLanguage = NSUserDefaults.standardUserDefaults().stringForKey(UserDefaultsKeys.MainLanguage.rawValue) {
            let langIndex = localeHelper.langNamesSortedArray.indexOf(localeHelper.langCodesWithNames[defaultLanguage]!)!
            pickerCell.langPickerView.selectRow(langIndex, inComponent: 0, animated: false)
        }
        return pickerCell
    }
    
    
    //MARK: - TableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            switch languageSelectMode {
            case true: languageSelectMode = false
                       NSUserDefaults.standardUserDefaults().setObject(selectedLanguageCode, forKey: UserDefaultsKeys.MainLanguage.rawValue)
                       NSUserDefaults.standardUserDefaults().synchronize()
                       mainLanguageDidSetToCode(selectedLanguageCode!)
                       tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Middle)
            case false: languageSelectMode = true
                        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Middle)
                
            }
            tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 1)], withRowAnimation: UITableViewRowAnimation.Fade)
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if languageSelectMode && indexPath.row == 1 && indexPath.section == 1 {
            return CGFloat(210)
        }
        return tableView.rowHeight
    }
    
    //MARK: - LangPicker
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return localeHelper.langNamesSortedArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return localeHelper.langNamesSortedArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedLanguageCode = localeHelper.langNamesWithCodes[localeHelper.langNamesSortedArray[row]]!
        selectedLanguageName = localeHelper.langCodesWithNames[selectedLanguageCode!]
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 1)], withRowAnimation: UITableViewRowAnimation.None)
    }
    
    
    //MARK: - Enums
    
    enum CellIdentifiers : String {
        case LoginCell = "LoginCell"
        case DefaultLanguageCell = "DefaultLanguageCell"
        case DefaultLanguageConfirmSelectCell = "DefaultLanguageConfirmSelectCell"
        case LanguagePickerCell = "LanguagePickerCell"
    }
    
}
