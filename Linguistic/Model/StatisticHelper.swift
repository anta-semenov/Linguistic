//
//  StatisticHelper.swift
//  Linguistic
//
//  Created by Anton on 08/11/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit

final class StatisticHelper: NSObject {
    var statistic: [String:Int]
    let languageCode: String
    
    init(withLanguage language:String) {
        self.languageCode = language
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        guard let langStats = userDefaults.valueForKey(UserDefaultsKeys.LanguageStatistic.rawValue) as? [String:[String:Int]], let _ = langStats[language] else {
            self.statistic = [String:Int]()
            super.init()
            return
        }
        
        self.statistic = langStats[language]!
        super.init()
    }
    
    deinit {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        guard var langStats = userDefaults.valueForKey(UserDefaultsKeys.LanguageStatistic.rawValue) as? [String:[String:Int]] else {
            userDefaults.setObject([languageCode:statistic], forKey: UserDefaultsKeys.LanguageStatistic.rawValue)
            userDefaults.synchronize()
            return
        }
        
        langStats[languageCode] = statistic
        userDefaults.setObject(langStats, forKey: UserDefaultsKeys.LanguageStatistic.rawValue)
        userDefaults.synchronize()
    }
    
    func getRatioForKey<T>(key: T) -> Int {
        guard let allCount = statistic["\(key)\(StatisticKeys.AllAnswersCount)"] where allCount != 0, let correctCount = statistic["\(key)\(StatisticKeys.CorrectAnswersCount)"] else {
            return 80
        }
        
        return correctCount*100/allCount
    }
    
    func incrementKey<T>(key: T, correct: Bool) {
        let correctKey: String = "\(key)\(StatisticKeys.CorrectAnswersCount)"
        let allKey: String = "\(key)\(StatisticKeys.AllAnswersCount)"
        if statistic[allKey] == nil {
            statistic[correctKey] = 0
            statistic[allKey] = 0
        }
        if correct {
            statistic[correctKey]!++
        }
        statistic[allKey]!++
    }
    
}

enum StatisticKeys {
    case CorrectAnswersCount
    case AllAnswersCount
}


