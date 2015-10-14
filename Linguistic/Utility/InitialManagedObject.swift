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
    class var entity: NSEntityDescription {
        return NSEntityDescription.entityForName(String(self), inManagedObjectContext: CoreDataHelper.instance.context)!
    }
    
    convenience init () {
        self.init(entity: self.dynamicType.entity, insertIntoManagedObjectContext: CoreDataHelper.instance.context)
    }
}
