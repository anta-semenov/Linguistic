//
//  InitialManagedObject.swift
//  Linguistic
//
//  Created by Anton on 30/09/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit
import CoreData

class InitialManagedObject: NSManagedObject {
    convenience init(withContext context: NSManagedObjectContext) {
        self.init(entity: NSEntityDescription.entityForName(String(self.dynamicType), inManagedObjectContext: context)!, insertIntoManagedObjectContext: context)
    }
}
