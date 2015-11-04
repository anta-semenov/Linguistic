//
//  AddLanguageViewController.swift
//  Linguistic
//
//  Created by Anton on 04/11/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit
import CoreData

class AddLanguageViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var languagePicker: UIPickerView!
    var localeHelper: NSLocaleHelper!
    var selectedLanguageCode: String?
    var langCodes = [String]()
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localeHelper = NSLocaleHelper()
        languagePicker.dataSource = self
        languagePicker.delegate = self
        
        let languages = Language.allLanguages(inContext: context)
        for language in languages {
            langCodes.append(language.code)
        }
        
        self.pickerView(languagePicker, didSelectRow: 0, inComponent: 0)
    }

    @IBAction func addLanguage(sender: UIBarButtonItem) {
        let languageName = localeHelper.langCodesWithNames[selectedLanguageCode!]
        Language.addLanguage(withCode: selectedLanguageCode!, withName: languageName!, inContext: context)
        CoreDataHelper.save(context)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
        if (langCodes.indexOf(selectedLanguageCode!) != nil) {
            addButton.enabled = false
        } else {
            addButton.enabled = true
        }
    }
}
