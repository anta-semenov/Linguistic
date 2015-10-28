//
//  AddingWordsTableViewController.swift
//  Linguistic
//
//  Created by Anton on 21/10/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit
import CoreData

class AddingWordsTableViewController: UITableViewController, UISearchBarDelegate, AWTranslateCellDelegate {
    
    var language:Language!
    var context: NSManagedObjectContext!
    var sourceLanguage: String!
    var destinationLanguage: String!
    var newWords = [NewWord]()
    var yandexApiHelper: YandexApiHelper!
    var searchSpinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    var tempSearchFieldLeftView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sourceLanguage = "en"//language.code
        destinationLanguage = NSUserDefaults.standardUserDefaults().stringForKey(UserDefaultsKeys.MainLanguage.rawValue)!
        
        yandexApiHelper = YandexApiHelper(sourceLanguage: sourceLanguage, destinationLanguage: destinationLanguage)
        
        //tableView.rowHeight = UITableViewAutomaticDimension
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return newWords.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return newWords[section].pos
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if newWords.count == 1 && newWords[0].text == LStringConstants.YD_WordNotFound.rawValue {
            return 1
        }
        return newWords[section].uiItems.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if newWords.count == 1 && newWords[0].text == LStringConstants.YD_WordNotFound.rawValue {
            return tableView.dequeueReusableCellWithIdentifier(AWCellIdentifiers.notFoundCell, forIndexPath: indexPath)
        }
        
        let item = newWords[indexPath.section].uiItems[indexPath.row]
        
        if let translateItem = item as? Translate {
            let cell = tableView.dequeueReusableCellWithIdentifier(AWCellIdentifiers.translateCell, forIndexPath: indexPath) as! AWTranslateCell
            cell.translate = translateItem
            cell.delegate = self
            return cell
        }
        
        if let exampleItem = item as? YAExercise {
            let cell = tableView.dequeueReusableCellWithIdentifier(AWCellIdentifiers.exampleCell, forIndexPath: indexPath)
            cell.textLabel?.text = exampleItem.text
            cell.detailTextLabel?.text = exampleItem.translatesString
            cell.accessoryType = exampleItem.isSelected ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None
            return cell
        }
        
        return UITableViewCell()
    }
    
    enum AWCellIdentifiers: String {
        case translateCell = "translateCell"
        case exampleCell = "exampleCell"
        case notFoundCell = "notFoundCell"
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    //MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if let item = newWords[indexPath.section].uiItems[indexPath.row] as? YAExercise {
            item.isSelected = !item.isSelected
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
        }
        if let item = newWords[indexPath.section].uiItems[indexPath.row] as? Translate, let cell = tableView.cellForRowAtIndexPath(indexPath) as? AWTranslateCell {
            showExercise(cell, newStatus: !item.exercisesAreShowing)
        }
        
        return nil
    }

    //MARK: - Search bar delegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        clearWordsTable()
        if let searchWord = searchBar.text {
            insertSpinnerToSearchBar(searchBar)
            yandexApiHelper.performYandexDictionaryRequest(searchWord, callback: loadSearchResults)
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            clearWordsTable()
        }
    }
    
    func loadSearchResults(requestResult: [NewWord]) {
        dispatch_async(dispatch_get_main_queue(), {() -> Void in
            self.newWords = requestResult
            if self.newWords.count == 0 {
                let notFoundWord = NewWord(withText: LStringConstants.YD_WordNotFound.rawValue)
                self.newWords.append(notFoundWord)
            }
            var sectionsRange = NSRange()
            sectionsRange.location = 0
            sectionsRange.length = self.newWords.count
            self.tableView.insertSections(NSIndexSet(indexesInRange: sectionsRange), withRowAnimation: UITableViewRowAnimation.Top)
            self.deleteSpinnerFromSearchBar()
        })
        
    }
    
    func clearWordsTable() {
        let wordsCount = newWords.count
        if wordsCount <= 0 {
            return
        }
        
        newWords.removeAll()
        var sectionsRange = NSRange()
        sectionsRange.location = 0
        sectionsRange.length = wordsCount
        tableView.deleteSections(NSIndexSet(indexesInRange: sectionsRange), withRowAnimation: UITableViewRowAnimation.Top)
    }
    
    func insertSpinnerToSearchBar(searchBar: UISearchBar) {
        for subview: UIView in searchBar.subviews[0].subviews {
            if let searchTextField = subview as? UITextField {
                tempSearchFieldLeftView = searchTextField.leftView
                searchTextField.leftView = searchSpinner
                searchSpinner.startAnimating()
            }
        }
    }
    
    func deleteSpinnerFromSearchBar() {
        if let searchTextField = self.searchSpinner.superview as? UITextField  {
            if let leftView = self.tempSearchFieldLeftView {
                searchTextField.leftView = leftView
            }
        }
    }
    
    //MARK: - Translate->Exercises Hierarchy
    func addTranslate(cell: AWTranslateCell) {
        let indexPath = tableView.indexPathForCell(cell)
        guard let translate = newWords[indexPath!.section].uiItems[indexPath!.row] as? Translate else {
            fatalError("Desinhronization of UI in AddingNewWordVC")
        }
        
        let newWord = newWords[indexPath!.section]
        newWord.addTranslate(translate, toContext: context)
        CoreDataHelper.save(context)
        
        let startLocation = indexPath!.row
        let endLocation = translate.exercisesAreShowing ? startLocation + translate.exercisesCount : startLocation
        var indexPathes = [NSIndexPath]()
        for index in startLocation ... endLocation {
            indexPathes.append(NSIndexPath(forRow: index, inSection: indexPath!.section))
        }
        
        newWord.removeTranslateFromSelf(translate)
        tableView.deleteRowsAtIndexPaths(indexPathes, withRowAnimation: UITableViewRowAnimation.Right)
    }
    
    func showExercise(cell: AWTranslateCell, newStatus: Bool) {
        guard let indexPath = tableView.indexPathForCell(cell), let translateItem = newWords[indexPath.section].uiItems[indexPath.row] as? Translate else {
            return//fatalError("Desinhronization of UI in AddingNewWordVC")
        }
        
        newWords[indexPath.section].exerciseShowStatusChanged(translateItem, newStatus: newStatus)
        
        var tableRowsIndexes = [NSIndexPath]()
        
        for index in 0..<translateItem.exercisesCount {
            tableRowsIndexes.append(NSIndexPath(forRow: indexPath.row+1+index, inSection: indexPath.section))
        }
        switch newStatus {
        case true: tableView.insertRowsAtIndexPaths(tableRowsIndexes, withRowAnimation: UITableViewRowAnimation.Middle)
        case false: tableView.deleteRowsAtIndexPaths(tableRowsIndexes, withRowAnimation: UITableViewRowAnimation.Middle)
        }
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }

}
