//
//  Language.swift
//  Linguistic
//
//  Created by Anton on 30/09/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import Foundation
import CoreData

class Language: InitialManagedObject {
    
    class func allLanguages() -> [Language] {
        let fetchRequest = NSFetchRequest(entityName: String(self))
        
        let results = CoreDataHelper.instance.executeFetchRequest(fetchRequest)
        
        return results as! [Language]
    }
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        let dynamicCourse = Course()
        dynamicCourse.type = Course.CourseType.Dynamic.rawValue
        dynamicCourse.name = "Words added by you"
        dynamicCourse.isActive = true
        dynamicCourse.language = self
    }
    
    func activeCourses() -> NSSet {
        return self.courses.filteredSetUsingPredicate(NSPredicate(format: "isActive == YES"))
    }

}

enum ExerciseTypeInputOutput : Int16 {
    case Audio = 0
    case Writing = 1
    case AudioAndWriting = 2
}
