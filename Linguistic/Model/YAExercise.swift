//
//  YAExercise.swift
//  Linguistic
//
//  Created by Anton on 24/10/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

class YAExercise: YAModel {
    let text:String
    var translates:[String] = [String]()
    var translatesString:String
    var isSelected:Bool = true
    
    required init(withJSON jsonData:JSON, sourceLanguage:String, destinationLanguage:String) {
        self.text = jsonData["text"].stringValue
        
        for(_,subJson):(String,JSON) in jsonData["tr"] {
            if let translate = subJson["text"].string {
                self.translates.append(translate)
            }
        }
        
        self.translatesString = self.translates.joinWithSeparator("; ")
            
        super.init(sourceLanguage: sourceLanguage, destinationLanguage: destinationLanguage)
    }
    
    func addToContext(context:NSManagedObjectContext, withWords words:[Word], withTranslateWords translateWords: [Word]? = nil) {
        
        let exercise = getExerciseInContext(context, withLanguage: sourceLanguage, withText: text, withWords: words)
        
        var exerciseTranslates = [Exercise]()
        
        if translateWords != nil {
            //Adding translate exercise
            for translate in translates {
                let translateExercise = getExerciseInContext(context, withLanguage: destinationLanguage, withText: translate, withWords: translateWords!)
                
                //adding connections beetween exercises
                exerciseTranslates.append(translateExercise)
            }
            
            if exerciseTranslates.count > 0 {
                if let currentExerciseTranslates = exercise.translate {
                    exerciseTranslates.appendContentsOf(currentExerciseTranslates.allObjects as! [Exercise])
                }
                exercise.translate = NSSet(array: exerciseTranslates)
            }
        }
    }
    
    func getExerciseInContext(context:NSManagedObjectContext, withLanguage language:String, withText text:String, var withWords words: [Word]) ->Exercise {
        let courseLanguage = Course.findDynamicCourseInContext(context, forLanguage: language)
        
        var exercise = Exercise.findExerciseInContext(context, withText: text, withLanguage: language, inCourse: courseLanguage)
        if exercise == nil {
            exercise = Exercise.createExerciseInContext(context, withText: text, withLanguage: language, inCourse: courseLanguage)
        }
        
        if let exerciseWords = exercise!.words {
            words.appendContentsOf(exerciseWords.allObjects as! Array<Word>)
        }
        
        exercise!.words = NSSet(array: words)
        
        return exercise!
    }
}
