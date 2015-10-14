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
    class func wordsForLesson(forLanguage language: Language) -> [Word] {
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
        
        let result = CoreDataHelper.instance.executeFetchRequest(request)
        
        return result as! [Word]
    }
}