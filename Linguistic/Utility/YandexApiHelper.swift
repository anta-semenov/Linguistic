//
//  YandexApiHelper.swift
//  Linguistic
//
//  Created by Anton on 22/10/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class YandexApiHelper: NSObject {
    let sourceLanguage: String
    let destinationLanguage: String
    let translateDirection: String
    
    init(sourceLanguage:String, destinationLanguage: String) {
        self.sourceLanguage = sourceLanguage
        self.destinationLanguage = destinationLanguage
        self.translateDirection = "\(sourceLanguage)-\(destinationLanguage)"
        
        super.init()
    }
    
    func performYandexDictionaryRequest(text: String, callback:([NewWord]) -> Void) {
        
        let url = "https://dictionary.yandex.net/api/v1/dicservice.json/lookup"
        let parameters = ["key":"dict.1.1.20151020T074524Z.1dbab20e76010710.87698222e6dd2a9fa2b1d1f60b34411371def891",
                          "lang":translateDirection,
                          "text":text,
                          "ui":"en"]
        
        let request = Alamofire.request(.GET, url, parameters: parameters)
            
        request.responseJSON {response in
                if let json = response.result.value {
                    var words = [NewWord]()
                    for (_,subJson):(String,JSON) in JSON(json)["def"] {
                        let word = NewWord(jsonData: subJson, sourceLanguage: self.sourceLanguage, destinationLanguage: self.destinationLanguage)
                        words.append(word)
                    }
                    callback(words)
                }            
        }
        
    }
    
    func performYandexTranslateRequest(text: String, callback:([NewWord]) -> Void) {
        
    }
}
