//
//  WordTranslates+CoreDataProperties.swift
//  Linguistic
//
//  Created by Anton on 06/10/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension WordTranslates {

    @NSManaged var language: String?
    @NSManaged var rating: Int16
    @NSManaged var selfWord: Word?
    @NSManaged var translate: Word?

}
