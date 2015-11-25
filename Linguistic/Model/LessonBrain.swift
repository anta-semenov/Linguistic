//
//  LessonBrain.swift
//  Linguistic
//
//  Created by Anton on 30/09/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

/*
Контроллер урока, выполняет следующие функции
- определяет слова для урока (на основании данных о языке и дате слов к добавлению в урок, и выбранных курсов в языке)
- определяет будет ли задание только по слову или будет использоваться упражнение (на основе данных о прогрессе слова)
- определяет будет ли использоваться задание на перевод или нет (на основании прогресса слова)
- определяет подходящие упражнения для слова (на основнании слов пользователя, уровне упражнения, доступных курсов, последней дате выполнения упражнения, и корректности выполнения упражнения, необходимости наличия перевода)
- определяет тип упражнения (выбор ответа/составление фразы/заполнение пропуска) (на основании прогресса слова, корректности выполнения упражнения и случайности/статистики по успехам пользователя)
- определяет тип ввода вывода для упражнения на основании прогресса слова, корректности выполнения упражнения и настроек языка
- выбирает/подгатавливает упражнение
- проверяет ответ
- обновляет прогессы слов (если упражнение на несколько слов) и упражнения, статистику. Устанавливает метки для слова (упражнения?) когда его нужно использовать в следующий раз
- фиксирует слова, участвовашие в упражнении, что бы не выбирать их 2 раз

Шкала прогресса слова:
 0 — 20%: Только слово, задание на перевод
20 — 40%: В первую очередь задание на перевод (может быть не доступно, по идее такие задания будут только в рамках предопределенных курсов появляться), тогда задание на слово до 30%
20 — 50%: Упражнение на одно слово
50 — 70%: Не более 2 слов
70 — 100%: на максимально возможно количество слов


Статистику по типам упражнений можно хранить в Языке (т.к. данные специфичны для каждого языка). Для каждого типа упражнения храним кол-во ответов всего и количество правильных ответов. Чем хуже процент тем больше вес упражнения при выборе типа. Для каждого типа получаем случайное число (0..<20) и умножаем его на процент. Берем наименьшее число.

Так же ведем статистику по аудио и текстовому вводу и выводу. Отдельно определяем тип вывода и тип ввода (для некоторых типов упражнений заданы жестко). Там где можем выбирать так же получаем случайное число (0..<20) и умножаем на процент. Берем наименьшее

Правило изменения прогресса слова:
За правильный ответ даем бонус (2), за неправильный штраф (1)
Умножаем бонус на коэффициент в зависимости от прогресса слова:
 0..<20 — 4
20..<50 — 3
50..<70 — 2
    >70 - 1

Время следующего появления слова (добавляем к текущей дате в зависимости от прогресса)
 0..<12 — 3 ч
12..<24 — 6 ч
24..<36 — 12 ч
36..<48 — 24 ч
48..<60 — 2 д
60..<72 — 5 д
72..<84 — 10 д
84..<100 — 20 д
> 100 — 80 д
*/


import UIKit
import CoreData

final class LessonBrain: NSObject {
    var questionOutputType: OutputType?
    var answerInputType: InputType?
    var language: Language
    var lessonWords: [Word]
    let statistic: StatisticHelper
    var currentExercise: LessonExercise?
    var pastExercises = [LessonExercise]()
    
    init(withLanguage language: Language) {
        self.language = language
        self.lessonWords = Word.wordsForLesson(forLanguage: language, inContext: language.managedObjectContext!)
        self.statistic = StatisticHelper(withLanguage: language.code)
        
        super.init()
    }
    
    //MARK: - State
    var questionType: QuestionType {
        get {
            return currentExercise!.questionType
        }
    }
    
    var questionText: String {
        get {
            return currentExercise!.question
        }
    }
    
    var variants: [String] {
        get {
            return currentExercise!.answerVariants[currentExercise!.mainWord]!
        }
    }
    
    
    //MARK: - New exercise
    
    func nextExercise() {
        //Получаем новое слово
        let nextWord = lessonWords.removeFirst()
        
        switch nextWord.learnProgress {
        case 0..<20:
            let questionType = getVariant(QuestionType.from0to20ProgressValues)
            switch questionType {
            case .QuestionTypeChooseTranslate:
                answerInputType = InputType.TextChoise
                questionOutputType = getVariant(OutputType.allValues)
            case .QuestionTypeChooseBackTranslate:
                answerInputType = getVariant(InputType.allValues)
                questionOutputType = OutputType.Text
            default: break
            }
            currentExercise = LessonExercise(withWord: nextWord, withQuestionType: questionType)
        case 20..<40:
            let questionType = QuestionType.QuestionTypeCompileTranslate
            questionOutputType = getVariant(OutputType.allValues)
            answerInputType = InputType.TextChoise
            currentExercise = LessonExercise(withWord: nextWord, withQuestionType: questionType)
        default: break
        }
    }
    
    func getVariant<T>(variants:[T]) -> T {
        var result = variants[0]
        var minRate = 9999999
        
        for variant in variants {
            let rate = statistic.getRatioForKey(variant) * Int(arc4random()%20)
            if rate < minRate {
                result = variant
                minRate = rate
            }
        }
        return result
    }
    
    //MARK: - Checking
    
    func checkAnswer(answer: String) -> Bool {
        return currentExercise!.checkAnswer(answer)
    }
    
    
    
    
    

    
}

enum QuestionType {
    case QuestionTypeChooseTranslate //выбираем перевод слова или фразы
    case QuestionTypeChooseBackTranslate //выбираем обратный перевод слова или фразы
    case QuestionTypeCompileTranslate //составить перевод фразы или слова по буквам, у упражнения должен быть перевод
    case QuestionTypeFillMissings //заполняем пропуски по аудированию, в аудировании слова есть
    case QuestionTypeInsertMissings //заполняем пропуски по аудированию или тексту, в задании слова пропущены
    case QuestionTypeCompilePhrase //составить осмысленную фразу из набора слов, на продвинутых могут быть дополнительные слова, но надо проверять грамматическую целостность
    case QuestionTypeCompletePhrase //выбрать правильный вариант окончания фразы (может быть ответ диалога)
    
    static let allValues = [QuestionTypeChooseTranslate,QuestionTypeCompileTranslate,QuestionTypeFillMissings,QuestionTypeInsertMissings,QuestionTypeCompilePhrase,QuestionTypeCompletePhrase]
    static let from0to20ProgressValues = [QuestionTypeChooseTranslate, QuestionTypeChooseBackTranslate]
}

enum InputType {
    case AudioChoise, AudioRecord, TextChoise
    
    static let allValues = [AudioChoise, AudioRecord, TextChoise]
}

enum OutputType {
    case Audio, Text
    
    static let allValues = [Audio, Text]
}

enum SpecialCharacters: String {
    case Missing = "<#>"
}

