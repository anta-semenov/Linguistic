//
//  LanguagePickerCell.swift
//  Linguistic
//
//  Created by Anton on 19/10/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit

class LanguagePickerCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var pickerView: UIPickerView!
    var choosenLanguage: String
    var delegate: UITableViewCellDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.choosenLanguage = ""
        super.init(coder: aDecoder)
    }
}
