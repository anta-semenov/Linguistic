//
//  CoreDataTests.swift
//  Linguistic
//
//  Created by Anton on 31/10/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import XCTest
import CoreData
@testable import Linguistic

class CoreDataTests: XCTestCase {
    var context: NSManagedObjectContext!
    override func setUp() {
        super.setUp()
        
        context = CoreDataHelper(withDbName: "test").context
    }
    
    override func tearDown() {
        let fileManager = NSFileManager.defaultManager()
        let docsURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last! as NSURL
        let storeURL = docsURL.URLByAppendingPathComponent("test.sqlite")
        
        do {
            try fileManager.removeItemAtURL(storeURL)
        } catch {
            print((error as NSError).localizedDescription)
        }
        
        super.tearDown()
    }
    
    //MARK: - Word tests
    
    func testSearchWordEmptyBase() {
        let word = Word.findWord("test", withLanguage: "en", withPosition: "noun", inContext: context)
        XCTAssert(word == nil)
    }
    
    func testCreateWordEmptyBase() {
        _ = Word.createWord("test", withLanguage: "en", withPosition: "noun", inContext: context)
        let wordsCount = entitiesCount("Word")
        XCTAssert(wordsCount == 1)
        
        let word = Word.findWord("test", withLanguage: "en", withPosition: "noun", inContext: context)
        XCTAssert(word != nil)
        XCTAssert(word!.word == "test")
    }
    
    func testCorrectWordFinding() {
        _ = Word.createWord("test", withLanguage: "en", withPosition: "noun", inContext: context)
        _ = Word.createWord("test1", withLanguage: "en", withPosition: "noun", inContext: context)
        _ = Word.createWord("test2", withLanguage: "en", withPosition: "noun", inContext: context)
        
        let wordsCount = entitiesCount("Word")
        XCTAssert(wordsCount == 3)
        
        let word = Word.findWord("test", withLanguage: "en", withPosition: "noun", inContext: context)
        XCTAssert(word != nil)
        XCTAssert(word!.word == "test" && word!.word != "test1" && word!.word != "test2")
    }
    
    
    //MARK: - 
    
    //MARK: - Staff
    
    func entitiesCount(entityName:String) -> Int {
        let request = NSFetchRequest(entityName: entityName)
        
        let result = context.countForFetchRequest(request, error: nil)
        
        return result
    }

}
