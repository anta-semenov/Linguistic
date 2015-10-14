//
//  Exercise.swift
//  Linguistic
//
//  Created by Anton on 13/09/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import Foundation
import CoreData

class Exercise: InitialManagedObject {
    var question: NSString = ""
    var questionType: QuestionType?
    var answers: [NSString] = []
    var correctAnswer: String = ""
    
    override func awakeFromInsert() {
        /*self.word = word
        self.learning<#T##NSManagedObjectContext?#>Language = learningLanguage
        self.questionType = questionType*/
    }
    
    func checkAnswer(answer: String) ->Bool {
        return answer.isEqual(correctAnswer)
    }
    
    func prepareExercise(forQuestionType questionType: QuestionType) {
        let words = [Word]()
        self.prepareExercise(forQuestionType: questionType, withWords: words)
    }
    
    func prepareExercise(forQuestionType questionType: QuestionType, withWord word: Word) {
        var words = [Word]()
        words.append(word)
        self.prepareExercise(forQuestionType: questionType, withWords: words)
    }
    
    func prepareExercise(forQuestionType questionType: QuestionType, withWords _words: [Word]) {
        
    }
    
}

enum QuestionType {
    case QuestionTypeChooseTranslate //выбираем перевод слова или фразы
    case QuestionTypeCompileTranslate //составить перевод фразы или слова по буквам, у упражнения должен быть перевод
    case QuestionTypeFillMissings //заполняем пропуски по аудированию, в аудировании слова есть
    case QuestionTypeInsertMissings //заполняем пропуски по аудированию или тексту, в задании слова пропущены
    //? case QuestionTypeCompilePhrase //составить осмысленную фразу из набора слов, на продвинутых могут быть дополнительные слова, но надо проверять грамматическую целостность
    case QuestionTypeCompletePhrase //выбрать правильный вариант окончания фразы (может быть ответ диалога)
}