//
//  Translate.swift
//  Linguistic
//
//  Created by Anton on 24/10/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

class Translate: YAModel {
    let text:String
    let pos:String
    var exercises = [YAExercise]()
    var exercisesCount: Int {
        return exercises.count
    }
    let rating:Int
    var exercisesAreShowing:Bool = false
    
    required init(withJSON jsonData:JSON, sourceLanguage:String, destinationLanguage:String, rating:Int = 80) {
        self.text = jsonData["text"].stringValue
        self.pos = jsonData["pos"].stringValue
        self.rating = rating
        
        for (_,subJson):(String,JSON) in jsonData["ex"] {
            self.exercises.append(YAExercise(withJSON: subJson, sourceLanguage: sourceLanguage, destinationLanguage: destinationLanguage))
        }
        
        super.init(sourceLanguage: sourceLanguage, destinationLanguage: destinationLanguage)
    }
    
    func addToContext(context: NSManagedObjectContext, withWord word: Word) {
        var translateWord = Word.findWord(text, withLanguage: destinationLanguage, withPosition: pos, inContext: context)
        
        if translateWord == nil {
            translateWord = Word.createWord(text, withLanguage: destinationLanguage, withPosition: pos, inContext: context)
        }
        //Adding translates
        if WordTranslates.findTranslateInContext(context, fowWord: word, withTranslateWord: translateWord!) == nil {
            
            WordTranslates.createTranslateInContext(context, fowWord: word, withTranslateWord: translateWord!, withRating: rating)
        }
        let course = Course.findDynamicCourseInContext(context, forLanguage: destinationLanguage)
        var wordCourses = [Course]()
        if translateWord!.includeInCourses != nil {
            wordCourses.appendContentsOf(translateWord!.includeInCourses!.allObjects as! [Course])
        }
        wordCourses.append(course)
        translateWord!.includeInCourses = NSSet(array: wordCourses)
        
        //Adding examples
        for example in exercises {
            if example.isSelected {
                example.addToContext(context, withWords: [word], withTranslateWords: [translateWord!])
            }
        }
    }
    
    
}
