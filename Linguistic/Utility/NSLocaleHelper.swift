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
        
        let currentLocale = NSLocale.currentLocale()
        
        for lanCode in unicLangCodes {
            let langName = currentLocale.displayNameForKey(NSLocaleLanguageCode, value: lanCode)
            tempLangDict[langName!] = (lanCode as! String)
        }
        
        self.langNamesWithCodes = tempLangDict
        
        self.langNamesSortedArray = tempLangDict.keys.sort()
        
        super.init()
    }
}
