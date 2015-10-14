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
    enum CourseType: Int16 {
        case Dynamic = 0
        case CreatedManually = 1
    }
}