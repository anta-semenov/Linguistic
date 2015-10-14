//
//  Language+CoreDataProperties.swift
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

extension Language {

    @NSManaged var name: String
    @NSManaged var code: String
    @NSManaged var typeOfExerciseInputOutput: Int16
    @NSManaged var courses: NSSet

}
