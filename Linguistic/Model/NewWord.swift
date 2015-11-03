//
//  NewWord.swift
//  Linguistic
//
//  Created by Anton on 21/10/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//
//  Use this class for present results from online dictionaries

import UIKit
import SwiftyJSON
import CoreData

class NewWord: YAModel {
    let text: String
    var translates = [Translate]()
    var translatesCount: Int {
        return translates.count
    }
    var translatesRating: [NewWord: Int]?
    let pos: String
    var uiItems:[YAModel] = [YAModel]()
    
    //MARK: - Initialization
    init(jsonData: JSON, sourceLanguage:String, destinationLanguage:String) {
        self.text = jsonData["text"].stringValue
        self.pos = jsonData["pos"].stringValue
        
        let translateRateWeight = 100/jsonData["tr"].count
        var translaeIndex = 0
        
        for (_,subJson):(String,JSON) in jsonData["tr"] {
            self.translates.append(Translate(withJSON: subJson, sourceLanguage: sourceLanguage, destinationLanguage: destinationLanguage, rating: 100-translaeIndex*translateRateWeight))
            self.uiItems.append(self.translates.last!)
            translaeIndex++
        }
        
        super.init(sourceLanguage: sourceLanguage, destinationLanguage: destinationLanguage)
    }
    
    convenience init(withText text: String) {
        let jsonData = JSON(["text":text])
        
        self.init(jsonData: jsonData, sourceLanguage:"", destinationLanguage:"")
        
    }
    
    //MARK: - Adding words functions
    func exerciseShowStatusChanged(translate:Translate, newStatus:Bool) {
        guard let location = uiItems.indexOf(translate)?.value else {
            fatalError("Desinhronization of UI in AddingNewWordVC")
        }
        translate.exercisesAreShowing = newStatus
        switch newStatus {
        case false: uiItems.removeRange(Range(start:Int(location)+1, end:Int(location)+translate.exercisesCount+1))
        case true: for (index, exercise) in translate.exercises.enumerate() {
            uiItems.insert(exercise, atIndex: Int(location)+index+1)
            }
        }
    }
    
    func addTranslate(translate: Translate, toContext context: NSManagedObjectContext) throws {
        //find word in context
        var word = Word.findWord(text, withLanguage: sourceLanguage, withPosition: pos, inContext: context)
        
        if word == nil {
            word = Word.createWord(text, withLanguage: sourceLanguage, withPosition: pos, inContext: context)
        }
        
        //add translate
        try translate.addToContext(context, withWord: word!)
        
        //add connection beetween word course
        let course = try Course.findDynamicCourseInContext(context, forLanguage: sourceLanguage)
        
        var wordCourses = [Course]()
        if word!.includeInCourses != nil {
            wordCourses.appendContentsOf(word!.includeInCourses!.allObjects as! [Course])
        }
        wordCourses.append(course)
        word!.includeInCourses = NSSet(array: wordCourses)   
    }
    
    func removeTranslateFromSelf(translate: Translate) {
        translates.removeAtIndex(translates.indexOf(translate)!)
        if translate.exercisesAreShowing {
            exerciseShowStatusChanged(translate, newStatus: false)
        }
        uiItems.removeAtIndex(uiItems.indexOf(translate)!)
    }
    
}
