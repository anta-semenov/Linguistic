//
//  LanguagePickerCell.swift
//  Linguistic
//
//  Created by Anton on 19/10/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit

class LanguagePickerCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var langPickerView: UIPickerView!
    var choosenLanguage: String
    var delegate: UITableViewCellDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        self.choosenLanguage = ""
        super.init(coder: aDecoder)
        
        self.langPickerView.delegate = self
        self.langPickerView.dataSource = self
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
}
