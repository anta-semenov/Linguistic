//
//  Course+CoreDataProperties.swift
//  Linguistic
//
//  Created by Anton on 30/09/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Course {

    @NSManaged var name: String?
    @NSManaged var isActive: Bool
    @NSManaged var type: Int16
    @NSManaged var desc: String?
    @NSManaged var exercises: NSSet?
    @NSManaged var words: NSSet?
    @NSManaged var language: Language?

}
