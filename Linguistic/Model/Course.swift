//
//  Course.swift
//  Linguistic
//
//  Created by Anton on 30/09/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import Foundation
import CoreData

class Course: InitialManagedObject {
    class func findDynamicCourseInContext(context:NSManagedObjectContext, forLanguage languageCode:String) ->Course {
        guard let language = Language.languageWithCode(languageCode, inContext: context) else {
            fatalError("There aren't dynamic course for \(languageCode)")
        }
        
        let request = NSFetchRequest(entityName: String(self))
        
        request.predicate = NSPredicate(format: "language == %@ AND type == 0", language)
        request.fetchLimit = 1
        
        guard let result = CoreDataHelper.executeFetchRequest(request, inContext: context) as? [Course] where result.count > 0 else {
            fatalError("There aren't dynamic course for \(languageCode)")
        }
        
        return result[0]
    }
    
    enum CourseType: Int16 {
        case Dynamic = 0
        case CreatedManually = 1
    }
}