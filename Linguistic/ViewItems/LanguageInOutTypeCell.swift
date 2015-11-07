//
//  LanguageInOutTypeCell.swift
//  Linguistic
//
//  Created by Anton on 07/11/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit

class LanguageInOutTypeCell: UITableViewCell {

    @IBOutlet weak var inOutTypeSwitch: UISegmentedControl!
    
    var delegate: UITableViewCellDelegate?

    @IBAction func inOutTypeChanged(sender: UISegmentedControl) {
        delegate?.cellWasChanged(self)
    }
    
}
