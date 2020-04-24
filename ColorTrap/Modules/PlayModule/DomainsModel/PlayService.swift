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
    
    func start() -> Observable<Void>
    
    func state() -> Observable<GameState>
    
    func question() -> Observable<Question?>
    
    func renewQuestion() -> Observable<Void>
    
    func didAnswer(isCorrect: Bool) -> Observable<Void>
    
    func totalScore() -> Observable<Int>
    
    func lifeCount() -> Observable<Int>
    
    func restart() -> Observable<Void>
        
    func timerValue() -> Observable<Double>
    
    func timeOut() -> Observable<Void>
    
    func startCount(from value: Double)
    
    func stopCountDown()
    
}

class RPPlayservice: PlayService {
    
    let notification: PlayNotification
    let timer: PlayTimer
    
    init(notification: PlayNotification, timer: PlayTimer) {
        self.notification = notification
        self.timer = timer
    }
    
    // MARK: - Notification
    
    func start() -> Observable<Void> {
        return notification.start()
    }
    
    func state() -> Observable<GameState> {
        return notification.state()
    }
    
    func question() -> Observable<Question?> {
        return notification.question()
    }
    
    func renewQuestion() -> Observable<Void> {
        return notification.renewQuestion()
    }
    
    func didAnswer(isCorrect: Bool) -> Observable<Void> {
        return notification.didAnswer(isCorrect: isCorrect)
    }
    
    func totalScore() -> Observable<Int> {
        return notification.totalScore()
    }
    
    func lifeCount() -> Observable<Int> {
        return notification.lifeCount()
    }
    
    func restart() -> Observable<Void> {
        return notification.restart()
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
