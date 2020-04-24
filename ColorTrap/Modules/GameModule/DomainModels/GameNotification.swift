//
//  GameNotification.swift
//  ColorTrap
//
//  Created by SonHoang on 4/22/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol GameNotification {

    func start() -> Observable<Void>

    func change(gameState state: GameState) -> Observable<Void>
    
    func generate(question: Question) -> Observable<Void>
    
    func send(lifeCount: Int) -> Observable<Void>
    
    func send(totalScore: Int) -> Observable<Void>
    
    func renewQuestion() -> Observable<Void>
    
    func didAnswer() -> Observable<Bool>
    
    func restart() -> Observable<Void>
    
}

class RPGameNotification: GameNotification {
    
    func start() -> Observable<Void> {
        return NotificationCenter.default.rx.notification(.PlayGame).map { _ in }
    }
    
    func change(gameState state: GameState) -> Observable<Void> {
        NotificationCenter.default.post(name: .GameState, object: self, userInfo: [kGameState: state])
        return .empty()
    }
    
    func didAnswer() -> Observable<Bool> {
        return NotificationCenter.default.rx.notification(.UserAnswer)
            .map { notification -> Bool in
                if let isCorrect = notification.userInfo?[kUserAnswer] as? Bool {
                    return isCorrect
                }
                return false
            }
    }
    
    func generate(question: Question) -> Observable<Void> {
        NotificationCenter.default.post(name: .Question, object: self, userInfo: [kQuestion: question])
        return .empty()
    }
    
    func send(lifeCount: Int) -> Observable<Void> {
        NotificationCenter.default.post(name: .LifeCount, object: self, userInfo: [kLifeCount: lifeCount])
        return .empty()
    }
    
    func send(totalScore: Int) -> Observable<Void> {
        NotificationCenter.default.post(name: .TotalScore, object: self, userInfo: [kGameScore: totalScore])
        return .empty()
    }
    
    func renewQuestion() -> Observable<Void> {
        return NotificationCenter.default.rx.notification(.RenewQuestion).map { _ in }
    }
    
    func restart() -> Observable<Void> {
        return NotificationCenter.default.rx.notification(.RestartGame).map { _ in }
    }
    
}
