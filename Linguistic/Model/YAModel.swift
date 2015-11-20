//
//  YAModelProtocols.swift
//  Linguistic
//
//  Created by Anton on 24/10/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import UIKit
import SwiftyJSON


class YAModel:NSObject {
    final let sourceLanguage:String
    final let destinationLanguage:String

    init(sourceLanguage:String, destinationLanguage:String) {
        self.sourceLanguage = sourceLanguage
        self.destinationLanguage = destinationLanguage
        
        super.init()
    }
}