//
//  CourseItemCell.swift
//  Linguistic
//
//  Created by Anton on 10/10/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit

class CourseItemCell: UITableViewCell {
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet weak var activityStatus: UISwitch!
    
    var delegate: UITableViewCellDelegate?

    @IBAction func changeActivity(sender: UISwitch) {
        delegate?.cellWasChanged(self)
    }
}

