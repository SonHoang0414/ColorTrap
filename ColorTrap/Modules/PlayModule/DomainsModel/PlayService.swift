//
//  PlayService.swift
//  ColorTrap
//
//  Created by SonHoang on 4/23/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol PlayService {
    
    var notification: PlayNotification { get }
    var timer: PlayTimer { get }
        
    func change(GameStateTo newState: GameState) -> Observable<Void>
    
    func state() -> Observable<GameState>

    func totalScore() -> Observable<Int>
    
    func lifeCount() -> Observable<Int>
        
    func timerValue() -> Observable<Double>
    
    func timeOut() -> Observable<Void>
    
    func startCount(from value: Double)
    
    func stopCountDown()
    
}

class RPPlayservice: PlayService {
    
    internal let notification: PlayNotification
    internal let timer: PlayTimer
    
    init(notification: PlayNotification, timer: PlayTimer) {
        self.notification = notification
        self.timer = timer
    }
    
    // MARK: - Notification
    
    func change(GameStateTo newState: GameState) -> Observable<Void> {
        return notification.change(GameStateTo: newState)
    }
    
    func state() -> Observable<GameState> {
        return notification.state()
    }
    
    func totalScore() -> Observable<Int> {
        return notification.totalScore()
    }
    
    func lifeCount() -> Observable<Int> {
        return notification.lifeCount()
    }
    
    // MARK: - Timer
    
    func timerValue() -> Observable<Double> {
        return timer.countDownProgress.asObservable().observeOn(MainScheduler.instance)
    }
    
    func timeOut() -> Observable<Void> {
        return timer.timeOut.asObservable().observeOn(MainScheduler.instance)
    }
    
    func startCount(from value: Double) {
        timer.startCountDown(from: value)
    }
    
    func stopCountDown() {
        timer.stopCountDown()
    }
}
