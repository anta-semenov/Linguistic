//
//  LessonExercise.swift
//  Linguistic
//
//  Created by Anton on 07/11/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

/*
Переносим часть функционала из LessonBrain сюда

- определяет упражнение на одно слово или несколько (на соснове случайности и статистики)
- здесь же обновляем прогрессы слов и упражнений
*/

import UIKit
import CoreData

class LessonExercise: NSObject {
    var question: String = ""
    let questionType: QuestionType
    var answerVariants: [Word:[String]] = [Word:[String]]()
    var correctAnswer: String = ""
    let mainWord: Word
    var words = [Word]()
    var exercise: Exercise?
    let context: NSManagedObjectContext
    var answerIsCorrect: Bool?
    let languageForTranslate: String
    
    func checkAnswer(answer: String) ->Bool {
        if answer.isEqual(correctAnswer) {
            answerIsCorrect = true
        } else {
            answerIsCorrect = false
        }
        updateWordProgress(mainWord)
        
        CoreDataHelper.save(context)
        
        return answerIsCorrect!
    }
    
    init(withWord word: Word, withQuestionType questionType: QuestionType) {
        self.mainWord = word
        self.context = word.managedObjectContext!
        self.questionType = questionType
        self.languageForTranslate = NSUserDefaults.standardUserDefaults().stringForKey(UserDefaultsKeys.MainLanguage.rawValue)!
        
        
        super.init()
        
        switch questionType {
        case .QuestionTypeChooseTranslate: self.initForTranslate()
        case .QuestionTypeChooseBackTranslate: self.initForTranslate()
        default: break
        }
    }
    
    func initForTranslate() {
        
        let request = NSFetchRequest(entityName: "WordTranslates")
        request.predicate = NSPredicate(format: "selfWord == %@ AND language == %@", mainWord, languageForTranslate)
        let translates = CoreDataHelper.executeFetchRequest(request, inContext: context) as! [WordTranslates]
        
        //firstly we should determine direction of translate that we'll use
        var variants = [String]()
        switch (questionType == QuestionType.QuestionTypeChooseTranslate) {
        case true:
            question = mainWord.word!
            correctAnswer = getTranslateAccidently(translates).translate!.word!
            variants.append(correctAnswer)
            variants.appendContentsOf(getTranslateVariantsForWord(mainWord))
        case false:
            question = getTranslateAccidently(translates).translate!.word!
            correctAnswer = mainWord.word!
            variants.append(correctAnswer)
            variants.appendContentsOf(getVariantsForWord(mainWord))
        }
        
        variants.sortInPlace({(left:String, right:String) -> Bool in return arc4random()%2 == 0})
        answerVariants[mainWord] = variants
        words.append(mainWord)
    }
    
    func getVariantsForWord(word:Word) -> [String] {
        let variantsRequest = NSFetchRequest(entityName: "Word")
        variantsRequest.predicate = NSPredicate(format: "lang == %@ AND pos == %@ AND SUBQUERY(isTranslateFor.selfWord, $x, ANY $x.isTranslateFor.selfWord == %@).@count == 0", mainWord.lang!, mainWord.pos!, mainWord)
        variantsRequest.fetchLimit = 3
        variantsRequest.sortDescriptors = [NSSortDescriptor(key: "randomOrder", ascending: true)]
        
        let requestResult = CoreDataHelper.executeFetchRequest(variantsRequest, inContext: context) as! [Word]
        var result = [String]()
        for i in requestResult {
            result.append(i.word!)
        }
        
        return result
    }
    
    func getTranslateVariantsForWord(word:Word) -> [String] {
        
        let variantsRequest = NSFetchRequest(entityName: "Word")
        variantsRequest.predicate = NSPredicate(format: "lang == %@ AND pos == %@ AND NONE isTranslateFor.selfWord == %@", languageForTranslate, mainWord.pos!, mainWord)
        variantsRequest.fetchLimit = 3
        variantsRequest.sortDescriptors = [NSSortDescriptor(key: "randomOrder", ascending: true)]
        
        let requestResult = CoreDataHelper.executeFetchRequest(variantsRequest, inContext: context) as! [Word]
        var result = [String]()
        for i in requestResult {
            result.append(i.word!)
        }
        
        return result
    }
    
    func updateWordProgress(word:Word) {
        var point = 0
        switch answerIsCorrect! {
        case true: point = 2
        case false: point = -1
        }
        
        word.learnProgress += Int16(point * bonusPenaltyCoefficientForProgressLevel(Int(word.learnProgress)))
        word.lastUsageTime = NSDate()
        word.nextUsageTime = word.lastUsageTime!.dateByAddingTimeInterval(timeIntervalForProgressLevel(Int(word.learnProgress)))
        word.randomOrder = Int16(arc4random()%200)
    }
    
    func getTranslateAccidently(translates:[WordTranslates]) -> WordTranslates {
        var result = translates[0]
        var maxRating = 0
        
        for translate in translates {
            let rating = Int(translate.rating) * Int(arc4random()%20)
            if rating > maxRating {
                result = translate
                maxRating = rating
            }
        }
        
        return result
    }
    
    
    //MARK: - Constant's Staff
    
    func timeIntervalForProgressLevel(progresLevel: Int) -> NSTimeInterval {
        var interval: NSTimeInterval = 0
        
        switch progresLevel {
        case 0..<12: interval = 3*60*60
        case 12..<24: interval = 6*60*60
        case 24..<36: interval = 12*60*60
        case 36..<48: interval = 24*60*60
        case 48..<60: interval = 2*24*60*60
        case 60..<72: interval = 5*24*60*60
        case 72..<84: interval = 10*24*60*60
        case 84..<100: interval = 20*24*60*60
        default: interval = 80*24*60*60
        }
        
        return interval
    }
    
    func bonusPenaltyCoefficientForProgressLevel(progresLevel: Int) -> Int {
        switch progresLevel {
        case 0..<20: return 4
        case 20..<50: return 3
        case 50..<70: return 2
        default: return 1
        }
    }
}


