//
//  AWTranslateCell.swift
//  Linguistic
//
//  Created by Anton on 25/10/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit

class AWTranslateCell: UITableViewCell {

    @IBOutlet weak var translateLabel: UILabel!
    @IBOutlet weak var exerciseButton: UIButton!
    var showExerciseStatus:Bool?
    var translate:Translate? {
        didSet {
            translateLabel.text = translate!.text
            switch translate!.exercisesAreShowing {
            case true: exerciseButton.setTitle("(show less)", forState: UIControlState.Normal)
            case false: exerciseButton.setTitle("\(translate!.exercisesCount) exercises (show more)", forState: UIControlState.Normal)
            }
            showExerciseStatus = translate!.exercisesAreShowing
            switch translate!.exercisesCount {
            case 0: exerciseButton.hidden = true
            default: exerciseButton.hidden = false
            }
        }
    }
    
    var delegate: AWTranslateCellDelegate?

    @IBAction func add(sender: UIButton) {
        delegate?.addTranslate(self)
    }
    @IBAction func showExamples() {
        delegate?.showExercise(self, newStatus: !showExerciseStatus!)
    }
    
}

protocol AWTranslateCellDelegate {
    func addTranslate(cell:AWTranslateCell)
    func showExercise(cell:AWTranslateCell, newStatus:Bool)
}
