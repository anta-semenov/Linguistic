//
//  LessonViewController.swift
//  Linguistic
//
//  Created by Anton on 23/09/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit
import CoreData

class LessonViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewCellDelegate {

    @IBOutlet weak var questionTypeLabel: UILabel!
    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var questionMissingNumber: UISegmentedControl!
    @IBOutlet weak var nextCheckButton: UIBarButtonItem!
    @IBOutlet weak var audioQuestionButton: UIButton!
    @IBOutlet weak var answersItems: UICollectionView!
    
    var lessonBrain: LessonBrain!
    var checkNextState = 0
    var language: Language!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lessonBrain = LessonBrain(withLanguage: language)
        
        answersItems.delegate = self
        answersItems.dataSource = self
        answersItems.allowsSelection = true
        
        questionMissingNumber.hidden = true
        
        next()
    }
    
    @IBAction func playAudioQuestion(sender: UIButton) {
    }
    
    
    @IBAction func checkNextAction(sender: UIBarButtonItem) {
        
    }
    
    @IBAction func recordAnswer(sender: UIButton) {
        //write and then play recorded audio
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Lesson controls staff
    func next() {
        checkNextState = 0
        nextCheckButton.title = "Check"
        
        lessonBrain.nextExercise()
        
        
        questionTextLabel.text = lessonBrain.questionText
        
        
        switch lessonBrain.questionOutputType! {
        case .Audio:
            questionTextLabel.hidden = true
            audioQuestionButton.hidden = false
        case .Text:
            questionTextLabel.hidden = false
            audioQuestionButton.hidden = true
        }
        
        answersItems.reloadData()
    }
    
    func check() {
        
    }
    
    
    //MARK: - CollectionView Data Source
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch lessonBrain.answerInputType! {
        case .AudioRecord: return 1
        default: return lessonBrain.variants.count
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        switch lessonBrain.answerInputType! {
        case .TextChoise:
            let cell = collectionView.dequeueReusableCellWithIdentifier(LSCellIdentifiers.textAnswer, forIndexPath: indexPath) as! TextAnswerCell
            cell.label.text = lessonBrain.variants[indexPath.row]
            return cell
        case .AudioChoise:
            let cell = collectionView.dequeueReusableCellWithIdentifier(LSCellIdentifiers.audioAnswer, forIndexPath: indexPath) as! AudioAnswerCell
            cell.delegate = self
            return cell
        case .AudioRecord:
            let cell = collectionView.dequeueReusableCellWithIdentifier(LSCellIdentifiers.recordAudio, forIndexPath: indexPath) as! RecordAudioCell
            cell.delegate = self
            return cell
        }
    }
    
    enum LSCellIdentifiers: String {
        case audioAnswer = "audioAnswer"
        case textAnswer = "textAnswer"
        case recordAudio = "recordAudio"
    }
    
    //MARK: - CollectionView Delegate
    
    
    //MARK: - CollectionViewItem Delegate
    
    
    //MARK: - CollectionViewCell Delegate
    func cellPerformAction<T : UICollectionViewCell>(cell: T) {
        /*switch lessonBrain.answerInputType! {
        case .AudioChoise:
            let indexPath =
        case .AudioRecord:
            
        default: break
        }*/
    }
    
    //MARK: - UICollectionView Layout Delegate
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        switch lessonBrain.answerInputType! {
        case .TextChoise:
            return collectionView.frame.width/2
        case .AudioRecord:
            return 0.0
        case .AudioChoise:
            return collectionView.frame.width/6
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        switch lessonBrain.answerInputType! {
        case .AudioRecord:
            let cvWidth = collectionView.frame.width
            let cvHeight = collectionView.frame.height
            let cellWidth = CGFloat(90.0)
            let cellHeight = CGFloat(80.0)
            let horizontalMargin = (cvWidth - cellWidth)/2
            let verticalMargin = (cvHeight - cellHeight)/2
            return UIEdgeInsets(top: verticalMargin, left: horizontalMargin, bottom: verticalMargin, right: horizontalMargin)
        default:
            let cvWidth = collectionView.frame.width
            let cvHeight = collectionView.frame.height
            return UIEdgeInsets(top: cvHeight*0.05, left: cvWidth*0.05, bottom: cvHeight*0.05, right: cvWidth*0.05)
        }
    }
    
}


