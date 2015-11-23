//
//  LessonViewController.swift
//  Linguistic
//
//  Created by Anton on 23/09/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit

class LessonViewController: UIViewController, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var questionTypeLabel: UILabel!
    @IBOutlet weak var questionTextLabel: UILabel!
    @IBOutlet weak var questionMissingNumber: UISegmentedControl!
    @IBOutlet weak var nextCheckButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playAudioQuestion(sender: UIButton) {
    }
    
    
    @IBAction func checkAnswer(sender: UIButton) {
    }
    
    @IBAction func recordAnswer(sender: UIButton) {
        //write and then play recorded audio
    }
    
    @IBAction func tapAnswer(sender: UITapGestureRecognizer) {
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
