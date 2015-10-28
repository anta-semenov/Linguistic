//
//  Word+CoreDataProperties.swift
//  Linguistic
//
//  Created by Anton on 08/10/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Word {

    @NSManaged var lang: String?
    @NSManaged var lastUsageTime: NSDate?
    @NSManaged var learnProgress: Int16
    @NSManaged var nextUsageTime: NSDate?
    @NSManaged var pos: String?
    @NSManaged var transcription: String?
    @NSManaged var word: String?
    @NSManaged var antonyms: NSSet?
    @NSManaged var childrens: NSSet?
    @NSManaged var exercises: NSSet?
    @NSManaged var isTranslateFor: NSSet?
    @NSManaged var parent: Word?
    @NSManaged var translates: NSSet?
    @NSManaged var includeInCourses: NSSet?

}
