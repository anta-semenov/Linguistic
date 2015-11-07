//
//  LanguagesViewController.swift
//  Linguistic
//
//  Created by Anton on 23/09/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit

class LanguagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SegueHandlerType {

    @IBOutlet weak var languagesItems: UITableView!
    
    var languages: [Language]!
    let rootContext = CoreDataHelper.instance.context
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        languagesItems.dataSource = self
        languagesItems.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        languages = Language.languagesWithoutCodes([NSUserDefaults.standardUserDefaults().stringForKey(UserDefaultsKeys.MainLanguage.rawValue)!], inContext: rootContext)
        languagesItems.reloadData()
    }

    
    //MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segueIdentifierForSegue(segue) {
        case .AddLanguage:
            guard let destinationVC = segue.destinationViewController as? AddLanguageViewController else {
                    fatalError("Cant't perfom segue with destination controller")
            }
            destinationVC.context = rootContext
        case .ShowLanguage:
            guard let destinationVC = segue.destinationViewController as? LearningLanguageViewController,
                let itemCell = sender as? UITableViewCell else {
                fatalError("Cant't perfom segue with destination controller")
            }
            let language = languages[(languagesItems.indexPathForCell(itemCell)?.row)!]
            destinationVC.language = language
        case .ShowSettings:
            break
        }
        
    }
    
    enum SegueIdentifier: String {
        case AddLanguage = "addLanguage"
        case ShowLanguage = "showLanguage"
        case ShowSettings = "showSettings"
    }
    
    //MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("language")!
        let item = languages[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //Ask user for confirmation
        self.showOkCancelQuestion("Confirm deletion", message: "Deleting the language will delete all your progress in words and exercises. This action is undo", okHandler: {() -> Void in let deletingLanguage = self.languages[indexPath.row]
                                         self.languages.removeAtIndex(indexPath.row)
                                         self.rootContext.deleteObject(deletingLanguage)
                                         CoreDataHelper.save(self.rootContext)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)}, cancelHandler: {tableView.setEditing(false, animated: true)})
    }
    
    

}
