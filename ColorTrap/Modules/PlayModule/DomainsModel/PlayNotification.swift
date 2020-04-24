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
        
    func change(GameStateTo newState: GameState) -> Observable<Void>
    
    func state() -> Observable<GameState>
    
    func totalScore() -> Observable<Int>
    
    func lifeCount() -> Observable<Int>
        
}

class RPPlayNotification: PlayNotification {
    
    func change(GameStateTo newState: GameState) -> Observable<Void> {
        NotificationCenter.default.post(name: .HomeModuleState, object: self, userInfo: [kHomeModuleState: newState])
        return .empty()
    }
    
    func state() -> Observable<GameState> {
        return NotificationCenter.default.rx.notification(.GameModuleState)
            .map { notification -> GameState in
                if let state = notification.userInfo?[kGameModuleState] as? GameState {
                    return state
                }
                return .initial
        }
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
    
}
