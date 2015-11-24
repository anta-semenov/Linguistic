//
//  RecordAudioCell.swift
//  Linguistic
//
//  Created by Anton on 24/11/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit

class RecordAudioCell: UICollectionViewCell {
    var delegate: UICollectionViewCellDelegate?
    @IBAction func recordAudio(sender: UIButton) {
        delegate?.cellPerformAction(self)
    }
}
