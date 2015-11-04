//
//  NSLocaleHelper.swift
//  Linguistic
//
//  Created by Anton on 19/10/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit

class NSLocaleHelper: NSObject {
    let langNamesWithCodes: [String: String]
    let langCodesWithNames: [String: String]
    let langNamesSortedArray: [String]
    
    override init() {
        //getting list of avialable locales
        let localesList = NSLocale.availableLocaleIdentifiers()
        
        let unicLangCodes = NSMutableSet()
        
        for locale in localesList {
            let localeProperties = NSLocale.componentsFromLocaleIdentifier(locale)
            unicLangCodes.addObject(localeProperties[NSLocaleLanguageCode]!)
        }
        
        var tempLangDict = [String:String]()
        var tempLangDictForNames = [String:String]()
        
        let currentLocale = NSLocale.currentLocale()
        
        for lanCode in unicLangCodes {
            let langName = currentLocale.displayNameForKey(NSLocaleLanguageCode, value: lanCode)
            tempLangDict[langName!] = (lanCode as! String)
            tempLangDictForNames[lanCode as! String] = langName!
        }
        
        self.langNamesWithCodes = tempLangDict
        self.langCodesWithNames = tempLangDictForNames
        
        self.langNamesSortedArray = tempLangDict.keys.sort()
        
        super.init()
    }
    
    class func nameForLanguage(code:String) -> String? {
        return NSLocale.currentLocale().displayNameForKey(NSLocaleLanguageCode, value: code)
    }
    
}
