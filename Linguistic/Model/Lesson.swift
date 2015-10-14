//
//  File.swift
//  Linguistic
//
//  Created by Anton on 13/09/15.
//  Copyright © 2015 Anton Semenov. All rights reserved.
//

import Foundation
import CoreData

class Lesson: InitialManagedObject {
    var exercisesCount: Int = 20
    var points: Double = 0.0
    var statistic: LessonStatistic = LessonStatistic()
    var exercises: [Exercise] = []
    
    /*func nextEcercise () ->Exercise {
        
    }*/
    
    func preveousExercise () -> Exercise? {
        if exercises.count >= 2 {
            return (exercises[exercises.count-2])
        } else {
            return nil
        }
    }
    
    func currentExercise() ->Exercise? {
        if exercises.count >= 1 {
            return (exercises[exercises.count-1])
        } else {
            return nil
        }
    }
    
    func checkCurrentAnswer(answer: String) -> Bool {
        guard let currentExercise = self.currentExercise() else {
            return false
        }
        return currentExercise.checkAnswer(answer)
    }
    
    
    
    
    
    
    
}

struct LessonStatistic {
    
}