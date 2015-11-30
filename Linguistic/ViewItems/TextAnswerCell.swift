//
//  TextAnswerCell.swift
//  Linguistic
//
//  Created by Anton on 24/09/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit

final class TextAnswerCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    override var selected: Bool {
        didSet {
            self.backgroundColor = selected ? UIColor.lgLessonSelectItemColor(): UIColor.lgLessonItemColor()
        }
    }
}
