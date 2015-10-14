//
//  CoursesViewController.swift
//  Linguistic
//
//  Created by Anton on 23/09/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit
import CoreData

class CoursesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UITableViewCellDelegate {

    @IBOutlet var tableView: UITableView!
    var language: Language!
    var fetchedResultsController: NSFetchedResultsController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeFetchedResultsController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeFetchedResultsController() {
        let request = NSFetchRequest(entityName: "Course")
        request.predicate = NSPredicate(format: "language == %@", self.language)
        let typeSortDescriptor = NSSortDescriptor(key: "type", ascending: true)
        let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [typeSortDescriptor, nameSortDescriptor]
        
        let moc = CoreDataHelper.instance.context
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultsController!.delegate = self
        
        do {
            try self.fetchedResultsController!.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CourseCell") as! CourseItemCell
        
        configureCell(cell, indexPath: indexPath)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = self.fetchedResultsController!.sections!
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController!.sections!.count
    }
    
    func configureCell(cell: CourseItemCell, indexPath: NSIndexPath) {
        let item = self.fetchedResultsController!.objectAtIndexPath(indexPath) as! Course
        
        cell.courseName.text = item.name
        cell.activityStatus.setOn(item.isActive, animated: false)
    }
    
    func cellWasChanged<T : UITableViewCell>(cell: T) {
        if let cell_ = cell as? CourseItemCell, let indexPath = tableView.indexPathForCell(cell), let item = self.fetchedResultsController!.objectAtIndexPath(indexPath) as? Course  {
            item.isActive = cell_.activityStatus.on
        }
    }

}
