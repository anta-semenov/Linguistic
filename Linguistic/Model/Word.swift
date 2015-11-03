//
//  Word.swift
//  Linguistic
//
//  Created by Anton on 13/09/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import Foundation
import CoreData

class Word: InitialManagedObject {
    class func wordsForLesson(forLanguage language: Language, inContext context: NSManagedObjectContext) -> [Word] {
        let request: NSFetchRequest = NSFetchRequest(entityName: String(self))
        
        let predicateLangAndTime = NSPredicate(format: "lang == %@ AND nextUsageTime <= %@", language.code, NSDate())
        
        var coursesPredicate = [NSPredicate]()
        
        for activeCourse in language.activeCourses() {
            if let course = activeCourse as? Course {
                coursesPredicate.append(NSPredicate(format: "%@ IN includeInCourses", course))
            }
        }
        
        let coursePredicate = NSCompoundPredicate(orPredicateWithSubpredicates: coursesPredicate)
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateLangAndTime, coursePredicate])
        request.fetchLimit = 60
        
        let result = CoreDataHelper.executeFetchRequest(request, inContext: context)
        
        return result as! [Word]
    }
    
    class func findWord(word: String, withLanguage language: String, withPosition position: String, inContext context: NSManagedObjectContext) -> Word? {
        let request = NSFetchRequest(entityName: String(self))
        //request.entity = NSEntityDescription.entityForName(String(self), inManagedObjectContext: context)
        
        let languagePredicate = NSPredicate(format: "lang == %@", language)
        let positionPredicate = NSPredicate(format: "pos == %@", position)
        let wordPredicate = NSPredicate(format: "word == %@", word)
        
        let predicates = NSCompoundPredicate(andPredicateWithSubpredicates: [wordPredicate, languagePredicate, positionPredicate])
        
        request.predicate = predicates
        request.fetchLimit = 1
        
        guard let result = CoreDataHelper.executeFetchRequest(request, inContext: context) as? [Word] where result.count > 0 else {
            return nil
        }
        return result[0]
    }
    
    class func createWord(word: String, withLanguage language: String, withPosition position: String, inContext context: NSManagedObjectContext) -> Word {
        let newWord = Word(withContext: context)
        newWord.word = word
        newWord.lang = language
        newWord.pos = position
        newWord.nextUsageTime = NSDate()
        newWord.lastUsageTime = NSDate()
        newWord.learnProgress = 0
        
        return newWord
    }
}