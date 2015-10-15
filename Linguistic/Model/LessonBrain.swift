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
- определяет упражнение на одно слово или несколько (на соснове пслучайности и статистики)
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


Статистику по типам упражнений можно хранить в UserDefaults. Для каждого типа упражнения храним кол-во ответов всего и количество правильных ответов. Чем хуже процент тем больше вес упражнения при выборе типа. Для каждого типа получаем случайное число (0..<20) и умножаем его на процент. Берем наименьшее число.

Так же ведем статистику по аудио и текстовому вводу и выводу. Отдельно определяем тип вывода и тип ввода (для некоторых типов упражнений заданы жестко). Там где можем выбирать так же получаем случайное число (0..<20) и умножаем на процент. Берем наименьшее

Правило изменения прогресса слова:
За правильный ответ даем бонус (2), за неправильный штраф (1)
Умножаем бонус на мультипликатор в зависимости от прогресса слова:
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

class LessonBrain: NSObject {
    var questionOutputType: InputOutputType?
    var answerInputType: InputOutputType?
    var language: Language
    var lessonWords: [Word]
    
    init(withLanguage language: Language) {
        self.language = language
        self.lessonWords = Word.wordsForLesson(forLanguage: language, inContext: language.managedObjectContext!)
        
        super.init()
    }
    
    func timeIntervalForProgresLevel(progresLevel: Int) -> NSTimeInterval {
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

}

enum InputOutputType: Int {
    case Audio = 0
    case Text = 1
}

