//
//  LearningLanguageViewController.swift
//  Linguistic
//
//  Created by Anton on 23/09/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit

class LearningLanguageViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var inputOutputTypeSegmentController: UISegmentedControl!
    var language: Language!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        nameTextField.text = language.name
        inputOutputTypeSegmentController.selectedSegmentIndex = Int(language.typeOfExerciseInputOutput)
        print(inputOutputTypeSegmentController.selectedSegmentIndex)
    }
    
    @IBAction func save(sender: UIBarButtonItem) {
        language.name = nameTextField.text!
        language.typeOfExerciseInputOutput = Int16(inputOutputTypeSegmentController.selectedSegmentIndex)
        
        CoreDataHelper.save(language.managedObjectContext!)
        
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let segueIdentifier = SegueIdentifier(rawValue: segue.identifier!) else {
            fatalError("Can't perfom segue with identifier \(segue.identifier)")
        }
        
        switch segueIdentifier {
        case .ShowCourses: if let destVC = segue.destinationViewController as? CoursesViewController {
            destVC.language = self.language
            destVC.context = language.managedObjectContext!
            }
        }
        
    }
    
    enum SegueIdentifier: String {
        case  ShowCourses = "showCourses"
    }
}
