//
//  LearningLanguageViewController.swift
//  Linguistic
//
//  Created by Anton on 23/09/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit

class LearningLanguageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITableViewCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var language: Language! {
        didSet {
            initializeCoursesArray()
        }
    }
    var courses: [Course]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = language.name
    }
    
    override func viewWillDisappear(animated: Bool) {
        CoreDataHelper.save(language.managedObjectContext!)
    }
    
    func initializeCoursesArray() {
        courses = language.courses.sortedArrayUsingDescriptors([NSSortDescriptor(key: "type", ascending: true)]) as! [Course]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let segueIdentifier = SegueIdentifier(rawValue: segue.identifier!) else {
            fatalError("Can't perfom segue with identifier \(segue.identifier)")
        }
        
        switch segueIdentifier {
        case .StartLesson: break
        case .AddNewWords: if let destVC = segue.destinationViewController as? AddingWordsTableViewController {
                destVC.language = self.language
                destVC.context = language.managedObjectContext!
            }
        }
        
    }
    
    enum SegueIdentifier: String {
        case  StartLesson = "StartLesson"
        case  AddNewWords = "AddNewWords"
    }
    
    //MARK: - CellDelegate
    func cellWasChanged<T : UITableViewCell>(cell: T) {
        if let courseCell = cell as? CourseItemCell, let indexPath = tableView.indexPathForCell(courseCell) {
            let item = courses[indexPath.row]
            item.isActive = courseCell.activityStatus.on
        }
        
        if let languageInOutCell = cell as? LanguageInOutTypeCell {
            language.typeOfExerciseInputOutput = Int16(languageInOutCell.inOutTypeSwitch.selectedSegmentIndex)
        }
    }
    
    //MARK: - TableViewDatasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 2 {
            return "Courses"
        }
        return nil
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2: return courses.count
        default: return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: return tableView.dequeueReusableCellWithIdentifier(LLCellIdentifiers.buttonsCell, forIndexPath: indexPath)
        case 1: return configureLanguageInOutTypeCell(indexPath)
        case 2: return configureCourseCell(indexPath)
        default: return UITableViewCell()
        }
    }
    
    func configureLanguageInOutTypeCell(indexPath: NSIndexPath) -> LanguageInOutTypeCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(LLCellIdentifiers.languageInOutTypeCell, forIndexPath: indexPath) as! LanguageInOutTypeCell
        
        cell.inOutTypeSwitch.selectedSegmentIndex = Int(language.typeOfExerciseInputOutput)
        cell.delegate = self
        
        return cell
    }
    
    func configureCourseCell(indexPath: NSIndexPath) -> CourseItemCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(LLCellIdentifiers.courseCell, forIndexPath: indexPath) as! CourseItemCell
        
        let item = courses[indexPath.row]
        
        cell.courseName.text = item.name
        cell.activityStatus.setOn(item.isActive, animated: false)
        cell.delegate = self
        
        return cell
    }
    
    enum LLCellIdentifiers: String {
        case buttonsCell = "buttonsCell"
        case languageInOutTypeCell = "languageInOutTypeCell"
        case courseCell = "courseCell"
    }
    
    //MARK: - TableViewDelegate
}
