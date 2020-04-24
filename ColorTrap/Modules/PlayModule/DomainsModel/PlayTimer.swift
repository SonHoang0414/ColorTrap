//
//  PlayTimer.swift
//  ColorTrap
//
//  Created by SonHoang on 4/23/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol PlayTimer {
    
    var countDownProgress: PublishRelay<Double> { get }
    var timeOut: PublishRelay<Void> { get }
    
    func startCountDown(from second: TimeInterval)
    func stopCountDown()
    
}

class RPPlayTimer: PlayTimer {
    
    private var timerDisposable: Disposable?
    
    var countDownProgress = PublishRelay<Double>()
    var timeOut = PublishRelay<Void>()
    
    func startCountDown(from second: Double) {
        
        stopCountDown()
        
        let milliseconds = Int(second * 1000)
        
        timerDisposable = Observable<Int>
            .timer(.seconds(0), period: .milliseconds(1), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .take(milliseconds)
            .map { milliseconds - $0 }
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                let timer: Double = Double(value - 1)
                self.countDownProgress.accept(timer / Double(milliseconds))
                
                // Cause the value is runing to 1 second and it's end
                if timer == 0 {
                    self.timeOut.accept(())
                }
        })

    }
    
    func stopCountDown() {
        timerDisposable?.dispose()
    }
    
}
