//
//  WordTranslates.swift
//  Linguistic
//
//  Created by Anton on 30/09/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import Foundation
import CoreData

class WordTranslates: InitialManagedObject {
    class func findTranslateInContext(context: NSManagedObjectContext, fowWord word:Word, withTranslateWord translateWord:Word) -> WordTranslates? {
        let request = NSFetchRequest(entityName: String(self))
        request.predicate = NSPredicate(format: "selfWord == %@ AND translate == %@", word, translateWord)
        request.fetchLimit = 1
        
        guard let result = CoreDataHelper.executeFetchRequest(request, inContext: context) as? [WordTranslates] where result.count > 0 else {
            return nil
        }
        
        return result[0]
    }
    
    class func createTranslateInContext(context: NSManagedObjectContext, fowWord word:Word, withTranslateWord translateWord:Word, withRating rating: Int = 80) -> WordTranslates {
        let translate = WordTranslates(withContext: context)
        
        translate.selfWord = word
        translate.translate = translateWord
        translate.rating = Int16(rating)
        translate.language = translateWord.lang
        
        return translate
    }
}
