//
//  Question.swift
//  ColorTrap
//
//  Created by SonHoang on 4/22/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import UIKit

protocol Question {
    
    var sample: Answer { get }
    var answers: [Answer] { get }
    var limitTime: TimeInterval { get }
    
    func generateLimitTime(by score: Int, and level: Level) -> TimeInterval
    func generateCorrectAnswer() -> Answer
    func generateAnswers(by score: Int, and level: Level) -> [Answer]

}

class RPQuestion: Question {

    var sample: Answer = RPAnswer(colorName: Color.red.name, color: Color.red.value, isCorrect: true)
    var answers: [Answer] = []
    var limitTime: TimeInterval = 0.0
    
    init(level: Level, score: Int) {
        limitTime = generateLimitTime(by: score, and: level)
        sample = generateCorrectAnswer()
        answers = generateAnswers(by: score, and: level)
    }
    
    func generateLimitTime(by score: Int, and level: Level) -> TimeInterval {
        let limitTime = (1 - (Double(score) / level.scoreToDecreaseTimeByLevel)) * level.limitTimeByLevel
        return limitTime < level.minLimitTimeByLevel ? level.minLimitTimeByLevel : limitTime
    }
    
    func generateCorrectAnswer() -> Answer {
        let color =  Color.allCase.shuffled().first!.value
        let colorName =  Color.allCase.shuffled().first!.name
        return RPAnswer(colorName: colorName, color: color, isCorrect: true)
    }
    
    func generateAnswers(by score: Int, and level: Level) -> [Answer] {
        
        guard let correctColor = Color.color(byUIColor: sample.color) else { return [] }
        
        var answersCount = level.totalAnswerByLevel + Int(score / level.scoreToInscreaseQuestionByLevel)
        if answersCount > level.maxAnswerByLevel {
            answersCount = level.maxAnswerByLevel
        }
        
        var colors = Array(Color.allCase.shuffled().map { $0.value }
            .filter { !$0.isEqual(correctColor.value) }
            .shuffled()
            .prefix(answersCount - 1))
        colors.append(correctColor.value)

        var colorNames = Array(Color.allCase
            .map { $0.name }
            .filter { !$0.elementsEqual(correctColor.name) }
            .shuffled()
            .prefix(answersCount - 1))
        colorNames.append(correctColor.name)
        
        let answers = zip(colors.shuffled(), colorNames.shuffled()).map { (color, name) -> RPAnswer in
            return RPAnswer(colorName: name, color: color, isCorrect: name.elementsEqual(correctColor.name))
        }
        
        return answers.shuffled()
    }

}
