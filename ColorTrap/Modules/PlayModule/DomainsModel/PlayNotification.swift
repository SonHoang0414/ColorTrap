//
//  PlayNotification.swift
//  ColorTrap
//
//  Created by SonHoang on 4/22/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol PlayNotification {
    
    func start() -> Observable<Void>
    
    func state() -> Observable<GameState>
    
    func question() -> Observable<Question?>
    
    func renewQuestion() -> Observable<Void>
    
    func didAnswer(isCorrect: Bool) -> Observable<Void>
    
    func totalScore() -> Observable<Int>
    
    func lifeCount() -> Observable<Int>
    
    func restart() -> Observable<Void>
        
}

class RPPlayNotification: PlayNotification {
    
    func start() -> Observable<Void> {
        NotificationCenter.default.post(name: .PlayGame, object: self)
        return .empty()
    }
    
    func state() -> Observable<GameState> {
        return NotificationCenter.default.rx.notification(.GameState)
            .map { notification -> GameState in
                if let state = notification.userInfo?[kGameState] as? GameState {
                    return state
                }
                return .initial
        }.debug("ReceiveNotification", trimOutput: true)
    }
    
    func renewQuestion() -> Observable<Void> {
        NotificationCenter.default.post(name: .RenewQuestion, object: self)
        return .empty()
    }
    
    func question() -> Observable<Question?> {
        return NotificationCenter.default.rx.notification(.Question).map { notification -> Question? in
            return notification.userInfo?[kQuestion] as? RPQuestion
        }
    }
    
    func didAnswer(isCorrect: Bool) -> Observable<Void> {
        NotificationCenter.default.post(name: .UserAnswer, object: self, userInfo: [kUserAnswer: isCorrect])
        return .empty()
    }
    
    func totalScore() -> Observable<Int> {
        return NotificationCenter.default.rx.notification(.TotalScore)
            .map { notification -> Int in
            if let point = notification.userInfo?[kGameScore] as? Int {
                return point
            }
            return 0
        }
    }
    
    func lifeCount() -> Observable<Int> {
        return NotificationCenter.default.rx.notification(.LifeCount)
            .map { notification -> Int in
            if let point = notification.userInfo?[kLifeCount] as? Int {
                return point
            }
            return 0
        }
    }
    
    func restart() -> Observable<Void> {
        NotificationCenter.default.post(name: .RestartGame, object: self)
        return .empty()
    }
    
}
