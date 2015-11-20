//
//  NSUserDefaultsKeys.swift
//  Linguistic
//
//  Created by Anton on 20/10/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit
import CoreData

enum UserDefaultsKeys: String {
    case MainLanguage = "MainLanguage"
    case LanguageStatistic = "LanguageStatistic"
}

func initialazeDefaultLanguage() {
    if NSUserDefaults.standardUserDefaults().stringForKey(UserDefaultsKeys.MainLanguage.rawValue) == nil {
        let currentLocaleID = NSLocale.currentLocale().localeIdentifier
        let language = NSLocale.componentsFromLocaleIdentifier(currentLocaleID)[NSLocaleLanguageCode]
        NSUserDefaults.standardUserDefaults().setValue(language, forKey: UserDefaultsKeys.MainLanguage.rawValue)
        NSUserDefaults.standardUserDefaults().synchronize()
        mainLanguageDidSetToCode(language!)
    }
}

func mainLanguageDidSetToCode(code:String) {
    if Language.languageWithCode(code, inContext: CoreDataHelper.instance.context) == nil {
        Language.addLanguage(withCode: code, withName: NSLocaleHelper.nameForLanguage(code)!)
    }
}