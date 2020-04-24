//
//  GameDataSource.swift
//  ColorTrap
//
//  Created by SonHoang on 4/22/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol GameDataSource {
    
    var state: GameState { get }
    var score: Int { get }
    var lifeCount: Int { get }
    var level: Level { get }
    
    var stateChangeOutPut: Observable<GameState> { get }
    var questionOutPut: Observable<RPQuestion> { get }
    var scoreOutPut: Observable<Int> { get }
    var lifeCountOutPut: Observable<Int> { get }
    
    func startGame()
    func restart()
    func gameOver()
    func nextQuestion()
    func answer(isCorrect: Bool)
}

class RPGameDataSource: GameDataSource {
    
    var state: GameState = .initial {
        didSet {
            if state == .initial {
                score = 0
                lifeCount = 4
            }
            scoreRelay.accept(score)
            lifeCountRelay.accept(lifeCount)
        }
    }
    
    var lifeCount: Int = 4 {
        didSet {
            if lifeCount == 0 {
                gameOver()
            }
        }
    }

    var score: Int = 0
    var level: Level = .easy
    
    private let stateChangeRelay = PublishRelay<GameState>()
    private let questionRelay = PublishRelay<RPQuestion>()
    private let scoreRelay = PublishRelay<Int>()
    private let lifeCountRelay = PublishRelay<Int>()
    
    lazy var stateChangeOutPut: Observable<GameState> = { return stateChangeRelay.asObservable() }()
    lazy var questionOutPut: Observable<RPQuestion> = { return questionRelay.asObservable() }()
    lazy var scoreOutPut: Observable<Int> = { return scoreRelay.asObservable() }()
    lazy var lifeCountOutPut: Observable<Int> = { return lifeCountRelay.asObservable() }()
    
}

// MARK: - Functions
extension RPGameDataSource {

    func startGame() {
        change(toNewState: .playing)
        nextQuestion()
    }
    
    func restart() {
        change(toNewState: .initial)
        nextQuestion()
    }
    
    func gameOver() {
        change(toNewState: .gameOver)
    }

    func nextQuestion() {

        guard state != .gameOver, lifeCount != 0 else { return }
        
        let question = generateQuestion(level: level, score: score)
        questionRelay.accept(question)
    }
    
    func answer(isCorrect: Bool) {
        
        guard state != .gameOver, lifeCount != 0 else { return }

        lifeCount = isCorrect ? lifeCount : lifeCount - 1
        score = isCorrect ? score + 1 : score
        
        scoreRelay.accept(score)
        lifeCountRelay.accept(lifeCount)
        
        nextQuestion()
        
    }

}

extension RPGameDataSource {
    
    private func change(toNewState newState: GameState) {
        state = newState
        stateChangeRelay.accept(newState)
    }
    
    private func generateQuestion(level: Level, score: Int) -> RPQuestion {
        let question = RPQuestion(level: level, score: score)
        if question.answers.isEmpty {
            return generateQuestion(level: level, score: score)
        }
        return question
    }
    
}
