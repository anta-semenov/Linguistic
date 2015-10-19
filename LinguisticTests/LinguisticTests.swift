//
//  LinguisticTests.swift
//  LinguisticTests
//
//  Created by Anton on 13/09/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import XCTest
@testable import Linguistic

class LinguisticTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testLocaleHelper() {
        var localeHelper: NSLocaleHelper?
        self.measureBlock {
            localeHelper = NSLocaleHelper()
        }
        
        XCTAssertEqual(localeHelper!.langNamesWithCodes["Russian"], "ru")
        XCTAssertEqual(localeHelper!.langNamesWithCodes["English"], "en")
        let ruIndex = localeHelper!.langNamesSortedArray.indexOf("Russian")!
        let enIndex = localeHelper!.langNamesSortedArray.indexOf("English")!
        XCTAssert(ruIndex > enIndex)
    }
    
}
