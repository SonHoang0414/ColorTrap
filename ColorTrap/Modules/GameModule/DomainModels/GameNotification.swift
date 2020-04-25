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

    func change(gameState state: GameState) -> Observable<Void>
    
    func state() -> Observable<GameState>
        
    func send(lifeCount: Int) -> Observable<Void>
    
    func send(totalScore: Int) -> Observable<Void>
    
}

class RPGameNotification: GameNotification {
    
    func change(gameState state: GameState) -> Observable<Void> {
        NotificationCenter.default.post(name: .GameModuleState, object: self, userInfo: [kGameModuleState: state])
        return .empty()
    }
    
    func state() -> Observable<GameState> {
        return NotificationCenter.default.rx.notification(.HomeModuleState)
        .map { notification -> GameState in
            if let state = notification.userInfo?[kHomeModuleState] as? GameState {
                return state
            }
            return .initial
        }
    }

    func send(lifeCount: Int) -> Observable<Void> {
        NotificationCenter.default.post(name: .LifeCount, object: self, userInfo: [kLifeCount: lifeCount])
        return .empty()
    }
    
    func send(totalScore: Int) -> Observable<Void> {
        NotificationCenter.default.post(name: .TotalScore, object: self, userInfo: [kGameScore: totalScore])
        return .empty()
    }
}
