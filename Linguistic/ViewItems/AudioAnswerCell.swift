//
//  AudioAnswerCell.swift
//  Linguistic
//
//  Created by Anton on 24/09/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit

class AudioAnswerCell: UICollectionViewCell {
    var delegate: UICollectionViewCellDelegate?
    
    @IBAction func playAudio(sender: UIButton) {
        delegate?.cellPerformAction(self)
    }
    
}
