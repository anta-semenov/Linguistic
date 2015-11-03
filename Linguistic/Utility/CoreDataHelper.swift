//
//  CoreDataHelper.swift
//  Linguistic
//
//  Created by Anton on 29/09/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHelper: NSObject {
    //singleton
    class var instance: CoreDataHelper {
        struct Singleton {
            static let instance = CoreDataHelper()
        }
        return Singleton.instance
    }
    
    let coordinator: NSPersistentStoreCoordinator
    let model: NSManagedObjectModel
    let context: NSManagedObjectContext
    
    init(withDbName dbName:String) {
        let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd")!
        model = NSManagedObjectModel(contentsOfURL: modelURL)!
        
        let fileManager = NSFileManager.defaultManager()
        let docsURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last! as NSURL
        let storeURL = docsURL.URLByAppendingPathComponent("\(dbName).sqlite")
        
        coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
        } catch {
            fatalError("Can't create persistent store. Error: \((error as NSError).localizedDescription)")
        }
        
        context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        
        context.persistentStoreCoordinator = coordinator
        
        super.init()
    }
    
    private convenience override init() {
        self.init(withDbName: "base")
    }
    
    func save() {
        if !context.hasChanges {
            return
        }
        
        do {
            try context.save()
        } catch {
            print((error as NSError).localizedDescription)
        }
    }
    
    class func save(context: NSManagedObjectContext) {
        if !context.hasChanges {
            return
        }
        
        do {
            try context.save()
        } catch {
            print((error as NSError).localizedDescription)
        }
    }
    
    func executeFetchRequest(fetchRequest: NSFetchRequest) -> [AnyObject] {
        do {
            let results = try self.context.executeFetchRequest(fetchRequest)
            return results
        } catch {
            print((error as NSError).localizedDescription)
            return []
        }
    }
    class func executeFetchRequest(fetchRequest: NSFetchRequest, inContext currentContext: NSManagedObjectContext) -> [AnyObject] {
        do {
            let results = try currentContext.executeFetchRequest(fetchRequest)
            return results
        } catch {
            print((error as NSError).localizedDescription)
            return []
        }
    }
}
