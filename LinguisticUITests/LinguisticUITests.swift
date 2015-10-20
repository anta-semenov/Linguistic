//
//  LinguisticUITests.swift
//  LinguisticUITests
//
//  Created by Anton on 13/09/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import XCTest

class LinguisticUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEmptyLoginData() {
        
        let app = XCUIApplication()
        app.navigationBars["Linguistic.LanguagesView"].childrenMatchingType(.Button).elementBoundByIndex(0).tap()
        app.tables.staticTexts["Login"].tap()
        app.buttons["Log In"].tap()
        
        let okButton = app.alerts["Empty requirements fields"].collectionViews.buttons["Ok"]
        okButton.tap()
        app.buttons["Sign Up"].tap()
        okButton.tap()
        
    }
    
    func testAddnewDictionary() {
        
        let app = XCUIApplication()
        let count = app.tables.elementBoundByIndex(0).cells.count
        app.navigationBars["Linguistic.LanguagesView"].buttons["Plus"].tap()
        
        
        let nameTextField = app.textFields["Name"]
        nameTextField.tap()
        nameTextField.typeText("test1")
        app.navigationBars["Title"].buttons["Save"].tap()
        XCTAssertEqual(app.tables.elementBoundByIndex(0).cells.count, count+1)
    }
    
    func testDontAddnewDictionary() {
        
        let app = XCUIApplication()
        let count = app.tables.elementBoundByIndex(0).cells.count
        app.navigationBars["Linguistic.LanguagesView"].buttons["Plus"].tap()
        
        
        let nameTextField = app.textFields["Name"]
        nameTextField.tap()
        nameTextField.typeText("test1")
        app.navigationBars["Title"].childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(0).tap()
        XCTAssertEqual(app.tables.elementBoundByIndex(0).cells.count, count)
        
    }
    
    
    func testChangeSwitchInCell () {
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.staticTexts.elementBoundByIndex(0).tap()
        
        let coursesButton = app.buttons["Courses"]
        coursesButton.tap()
        let firstSwitchButtonState = tablesQuery.switches["Words added by you"].value as! String
        tablesQuery.switches["Words added by you"].tap()
        let secondSwitchButtonState = tablesQuery.switches["Words added by you"].value as! String
        XCTAssert(firstSwitchButtonState != secondSwitchButtonState)
        app.navigationBars["Courses"].buttons["Title"].tap()
        coursesButton.tap()
        XCTAssert(secondSwitchButtonState == (tablesQuery.switches["Words added by you"].value as! String))
    }
    
}
