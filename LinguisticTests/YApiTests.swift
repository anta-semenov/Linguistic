//
//  YApiTests.swift
//  Linguistic
//
//  Created by Anton on 01/11/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import XCTest
import CoreData
import SwiftyJSON
@testable import Linguistic

class YApiTests: CoreDataTests {
    
    var jsonResult: NSData!
    var testWords: [NewWord]!
    
    override func setUp() {
        super.setUp()
        
        //get result json
        let bundle = NSBundle(forClass: self.dynamicType)
        let jsonURL = bundle.URLForResource("TestWord", withExtension: "json")
        jsonResult = NSData(contentsOfURL: jsonURL!)
        let yandexApiHelper = YandexApiHelper(sourceLanguage: "en", destinationLanguage: "ru")
        testWords = yandexApiHelper.getNewWordsFromJsonResult(JSON(data: jsonResult))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testYandexresultParse() {
        
        let json = JSON(data: jsonResult)
        let yandexApiHelper = YandexApiHelper(sourceLanguage: "en", destinationLanguage: "ru")
        
        var words = [NewWord]()
        
        self.measureBlock {
            words = yandexApiHelper.getNewWordsFromJsonResult(json)
        }
        
        XCTAssert(words.count == 2)
        XCTAssert(words[0].translatesCount == 2)
        XCTAssert(words[1].translatesCount == 1)
        XCTAssert(words[0].translates[0].exercises.count == 4)
        XCTAssert(words[1].translates[0].exercises.count == 2)
        
    }
    
    func testAddingObjectsWithoutLanguages() {
        //adding objects without languages
        do {
            try testWords[0].addTranslate(testWords[0].translates[0], toContext: context)
            XCTFail("Tested block did not throw error as expected.")
        } catch let error as NSError {
            XCTAssert(error.code == 1)
        }
    }
    
    func testAddingTwoTranslatesForOneWord() {
        initLanguages()
        
        
        for exercise in testWords[0].translates[0].exercises {
            exercise.isSelected = false
        }
        
        do {
            try testWords[0].addTranslate(testWords[0].translates[0], toContext: context)
        } catch let error as NSError {
            XCTFail((error as NSError).localizedDescription)
            return
        }
        
        for exercise in testWords[0].translates[1].exercises {
            exercise.isSelected = false
        }
        
        do {
            try testWords[0].addTranslate(testWords[0].translates[1], toContext: context)
        } catch let error as NSError {
            XCTFail((error as NSError).localizedDescription)
            return
        }
        
        //check for words
        let request = NSFetchRequest(entityName: "Word")
        request.predicate = NSPredicate(format: "word == %@", "time")
        
        let timeCount = context.countForFetchRequest(request, error: nil)
        
        XCTAssert(timeCount == 1)
        
        XCTAssertEqual(3, entitiesCount("Word"))
        XCTAssertEqual(4, entitiesCount("WordTranslates"))
        
    }
    
    func testAddingTwoTranslatesForTwoWords() {
        initLanguages()
        
        
        for exercise in testWords[0].translates[0].exercises {
            exercise.isSelected = false
        }
        
        do {
            try testWords[0].addTranslate(testWords[0].translates[0], toContext: context)
        } catch let error as NSError {
            XCTFail((error as NSError).localizedDescription)
            return
        }
        
        for exercise in testWords[1].translates[0].exercises {
            exercise.isSelected = false
        }
        
        do {
            try testWords[1].addTranslate(testWords[1].translates[0], toContext: context)
        } catch let error as NSError {
            XCTFail((error as NSError).localizedDescription)
            return
        }
        
        //check for words
        let request = NSFetchRequest(entityName: "Word")
        
        request.predicate = NSPredicate(format: "word == %@", "time")
        var timeCount = context.countForFetchRequest(request, error: nil)
        XCTAssert(timeCount == 2)
        
        request.predicate = NSPredicate(format: "word == %@ AND pos == %@", "time", "noun")
        timeCount = context.countForFetchRequest(request, error: nil)
        XCTAssert(timeCount == 1)
        
        request.predicate = NSPredicate(format: "word == %@ AND pos == %@", "time", "adjective")
        timeCount = context.countForFetchRequest(request, error: nil)
        XCTAssert(timeCount == 1)
        
        XCTAssertEqual(4, entitiesCount("Word"))
        XCTAssertEqual(4, entitiesCount("WordTranslates"))
        
    }
    func testAddTranslateTwice() {
        initLanguages()
        
        for exercise in testWords[0].translates[0].exercises {
            exercise.isSelected = false
        }
        
        do {
            try testWords[0].addTranslate(testWords[0].translates[0], toContext: context)
        } catch let error as NSError {
            XCTFail((error as NSError).localizedDescription)
            return
        }
        
        do {
            try testWords[0].addTranslate(testWords[0].translates[0], toContext: context)
        } catch let error as NSError {
            XCTFail((error as NSError).localizedDescription)
            return
        }
        
        let request = NSFetchRequest(entityName: "Word")
        
        request.predicate = NSPredicate(format: "word == %@", "time")
        let timeCount = context.countForFetchRequest(request, error: nil)
        XCTAssert(timeCount == 1)
        
        XCTAssertEqual(2, entitiesCount("Word"))
        XCTAssertEqual(2, entitiesCount("WordTranslates"))
    }
    
    func testConnectionsBeetweenWordAndTranslate() {
        initLanguages()
        
        for exercise in testWords[0].translates[0].exercises {
            exercise.isSelected = false
        }
        
        do {
            try testWords[0].addTranslate(testWords[0].translates[0], toContext: context)
        } catch let error as NSError {
            XCTFail((error as NSError).localizedDescription)
            return
        }
        
        guard let word = Word.findWord("time", withLanguage: "en", withPosition: "noun", inContext: context), let translate = word.translates!.anyObject() as? WordTranslates, let translateWord = Word.findWord("время", withLanguage: "ru", withPosition: "noun", inContext: context), let translateWordTranslate = translateWord.translates!.anyObject() as? WordTranslates else {
            XCTFail()
            return
        }
        
        XCTAssert(translate.translate == translateWord)
        XCTAssert(translateWordTranslate.translate == word)
        
    }
    
    func testAddingExercise() {
        initLanguages()
        
        for exercise in testWords[0].translates[0].exercises {
            exercise.isSelected = false
        }
        testWords[0].translates[0].exercises[0].isSelected = true
        do {
            try testWords[0].addTranslate(testWords[0].translates[0], toContext: context)
        } catch let error as NSError {
            XCTFail((error as NSError).localizedDescription)
            return
        }
        
        XCTAssert(entitiesCount("Exercise") == 2)
        
        let exRequest = NSFetchRequest(entityName: "Exercise")
        exRequest.predicate = NSPredicate(format: "lang == %@", "en")
        
        guard let enExResult = CoreDataHelper.executeFetchRequest(exRequest, inContext: context) as? [Exercise] else {
            XCTFail()
            return
        }
        XCTAssert(enExResult.count == 1)
        let exercise = enExResult[0]
        XCTAssert(exercise.text == testWords[0].translates[0].exercises[0].text)
        XCTAssert(exercise.usageCount == 0)
        XCTAssert(exercise.correctAnswerCount == 0)
        XCTAssert(exercise.course?.type == 0)
        XCTAssert(exercise.course?.language?.code == "en")
        
        guard let translateExercise = exercise.translate?.anyObject() as? Exercise where exercise.translate?.count == 1 else {
            XCTFail()
            return
        }
        
        exRequest.predicate = NSPredicate(format: "lang == %@", "ru")
        
        guard let ruExResult = CoreDataHelper.executeFetchRequest(exRequest, inContext: context) as? [Exercise] else {
            XCTFail()
            return
        }
        XCTAssert(ruExResult.count == 1)
        let exerciseRu = ruExResult[0]
        XCTAssert(exerciseRu.text == testWords[0].translates[0].exercises[0].translates[0])
        XCTAssert(exerciseRu.usageCount == 0)
        XCTAssert(exerciseRu.correctAnswerCount == 0)
        XCTAssert(exerciseRu.course?.type == 0)
        XCTAssert(exerciseRu.course?.language?.code == "ru")
        
        XCTAssert(translateExercise.objectID == exerciseRu.objectID)
        
        guard let ruTranslateExercise = exerciseRu.translate?.anyObject() as? Exercise where exerciseRu.translate?.count == 1 else {
            XCTFail()
            return
        }
        
        XCTAssert(ruTranslateExercise.objectID == exercise.objectID)
        
    }
    
    //MARK: - Staff
    func initLanguages() {
        let enLang = Language(withContext: context)
        enLang.code = "en"
        enLang.name = "en"
        
        let ruLang = Language(withContext: context)
        ruLang.code = "ru"
        ruLang.name = "ru"
        
        //CoreDataHelper.save(context)
    }
    
}
