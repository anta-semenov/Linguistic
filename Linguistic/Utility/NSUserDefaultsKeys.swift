//
//  NSUserDefaultsKeys.swift
//  Linguistic
//
//  Created by Anton on 20/10/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit

enum UserDefaultsKeys: String {
    case MainLanguage = "MainLanguage"
}

func initialazeDefaultLanguage() {
    if NSUserDefaults.standardUserDefaults().stringForKey(UserDefaultsKeys.MainLanguage.rawValue) == nil {
        let currentLocaleID = NSLocale.currentLocale().localeIdentifier
        let language = NSLocale.componentsFromLocaleIdentifier(currentLocaleID)[NSLocaleLanguageCode]
        NSUserDefaults.standardUserDefaults().setValue(language, forKey: UserDefaultsKeys.MainLanguage.rawValue)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}