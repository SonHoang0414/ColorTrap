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
    
    var state: BehaviorRelay<GameState> { get }
    var score: Int { get }
    var lifeCount: Int { get }
    var level: Level { get }
    
    var stateOutput: Observable<GameState> { get }
    var questionOutPut: Observable<RPQuestion> { get }
    var scoreOutPut: Observable<Int> { get }
    var lifeCountOutPut: Observable<Int> { get }
    
    func initialGame()
    
    func handle(GameState state: GameState)
}

class RPGameDataSource: GameDataSource {
    
    private let disposeBag = DisposeBag()
    
    var state = BehaviorRelay<GameState>(value: .initial)
    
    var lifeCount: Int = 4 {
        didSet {
            if lifeCount == 0 {
                stateOutputRelay.accept(.gameOver)
            }
        }
    }

    var score: Int = 0
    var level: Level = .easy
    
    private let stateOutputRelay = PublishRelay<GameState>()
    private let questionRelay = PublishRelay<RPQuestion>()
    private let scoreRelay = PublishRelay<Int>()
    private let lifeCountRelay = PublishRelay<Int>()
    
    lazy var stateOutput: Observable<GameState> = { return stateOutputRelay.asObservable() }()
    lazy var questionOutPut: Observable<RPQuestion> = { return questionRelay.asObservable() }()
    lazy var scoreOutPut: Observable<Int> = { return scoreRelay.asObservable() }()
    lazy var lifeCountOutPut: Observable<Int> = { return lifeCountRelay.asObservable() }()
    
    
    init() {
        state.subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                self.handle(GameState: state)
            }).disposed(by: disposeBag)
    }
    
}

// MARK: - Functions
extension RPGameDataSource {
    
    internal func handle(GameState state: GameState) {
        switch state {
        case .initial:
            initialGame()
        case .playing, .nextQuestion, .renewQuestion:
            initialGame()
            generateQuestion()
        case .didAnswer(isCorrect: let isCorrect):
            answer(isCorrect: isCorrect)
        case .restart:
            initialGame()
            generateQuestion()
        default: break
        }
    }
    
    internal func initialGame() {
        
        score = 0
        lifeCount = level.defaultLifeByLevel
        
        scoreRelay.accept(score)
        lifeCountRelay.accept(lifeCount)
        
    }
    
    internal func generateQuestion() {

        guard !state.value.isGameOver , lifeCount != 0 else { return }
        
        let question = generateQuestion(level: level, score: score)
        stateOutputRelay.accept(.generated(question: question))
    }
    
    internal func answer(isCorrect: Bool) {
        
        guard !state.value.isGameOver , lifeCount != 0 else { return }

        lifeCount = isCorrect ? lifeCount : lifeCount - 1
        score = isCorrect ? score + 1 : score
        
        scoreRelay.accept(score)
        lifeCountRelay.accept(lifeCount)
        
        generateQuestion()
        
    }

}

extension RPGameDataSource {
    
    private func generateQuestion(level: Level, score: Int) -> RPQuestion {
        let question = RPQuestion(level: level, score: score)
        if question.answers.isEmpty {
            return generateQuestion(level: level, score: score)
        }
        return question
    }
    
}
