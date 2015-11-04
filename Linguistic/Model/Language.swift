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
    
    class func allLanguages(inContext context: NSManagedObjectContext) -> [Language] {
        let fetchRequest = NSFetchRequest(entityName: String(self))
        
        let results = CoreDataHelper.executeFetchRequest(fetchRequest, inContext: context)
        
        return results as! [Language]
    }
    
    class func languageWithCode(code:String, inContext context:NSManagedObjectContext) -> Language? {
        let request = NSFetchRequest(entityName: String(self))
        
        request.predicate = NSPredicate(format: "code == %@", code)
        request.fetchLimit = 1
        
        guard let result = CoreDataHelper.executeFetchRequest(request, inContext: context) as? [Language] where result.count > 0 else {
            return nil
        }
        
        return result[0]
    }
    
    class func languagesWithoutCodes(codes:[String], inContext context:NSManagedObjectContext) -> [Language] {
        let request = NSFetchRequest(entityName: String(self))
        
        request.predicate = NSPredicate(format: "NOT(code IN %@)", codes)
        
        guard let result = CoreDataHelper.executeFetchRequest(request, inContext: context) as? [Language] where result.count > 0 else {
            return [Language]()
        }
        
        return result
    }
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        let dynamicCourse = Course(withContext: self.managedObjectContext!)
        dynamicCourse.type = Course.CourseType.Dynamic.rawValue
        dynamicCourse.name = "Words added by you"
        dynamicCourse.isActive = true
        dynamicCourse.language = self
    }
    
    func activeCourses() -> NSSet {
        return self.courses.filteredSetUsingPredicate(NSPredicate(format: "isActive == YES"))
    }
    
    class func addLanguage(withCode code:String, withName name:String, var inContext context: NSManagedObjectContext? = nil, var contextShouldBeSaved:Bool = false) {
        if context == nil {
            context = CoreDataHelper.instance.context
            contextShouldBeSaved = true
        }
        
        let language = Language(withContext: context!)
        
        language.name = name
        language.code = code
        language.typeOfExerciseInputOutput = 2
        
        if contextShouldBeSaved {
            CoreDataHelper.save(context!)
        }
    }

}

enum ExerciseTypeInputOutput : Int16 {
    case Audio = 0
    case Writing = 1
    case AudioAndWriting = 2
}
