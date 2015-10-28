//
//  Exercise+CoreDataProperties.swift
//  Linguistic
//
//  Created by Anton on 05/10/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Exercise {

    @NSManaged var lang: String?
    @NSManaged var text: String?
    @NSManaged var lastUsageDateTime: NSDate?
    @NSManaged var usageCount: Int16
    @NSManaged var correctAnswerCount: Int16
    @NSManaged var course: Course?
    @NSManaged var translate: NSSet?
    @NSManaged var words: NSSet?

}
