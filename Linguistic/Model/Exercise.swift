//
//  Exercise.swift
//  Linguistic
//
//  Created by Anton on 13/09/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import Foundation
import CoreData

class Exercise: InitialManagedObject {
    
    
    override func awakeFromInsert() {
        /*self.word = word
        self.learning<#T##NSManagedObjectContext?#>Language = learningLanguage
        self.questionType = questionType*/
    }
    
    //MARK: - Creating and finding
    class func findExerciseInContext(context:NSManagedObjectContext, withText text:String, withLanguage language:String, inCourse course:Course) -> Exercise? {
        let request = NSFetchRequest(entityName: String(self))
        
        request.predicate = NSPredicate(format: "lang == %@ AND text == %@ AND course == %@", language, text, course)
        request.fetchLimit = 1
        
        guard let result = CoreDataHelper.executeFetchRequest(request, inContext: context) as? [Exercise] where result.count > 0 else {
            return nil
        }
        
        return result[0]
    }
    
    class func createExerciseInContext(context:NSManagedObjectContext, withText text:String, withLanguage language:String, inCourse course:Course) -> Exercise {
        let exercise = Exercise(withContext: context)
        exercise.lang = language
        exercise.text = text
        exercise.course = course
        exercise.lastUsageDateTime = NSDate()
        exercise.usageCount = 0
        exercise.correctAnswerCount = 0
        
        return exercise
    }
    
}