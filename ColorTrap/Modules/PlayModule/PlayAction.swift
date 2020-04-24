//
//  PlayAction.swift
//  ColorTrap
//
//  Created by SonHoang on 4/22/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Action

protocol PlayAction {
    
    var store: PlayStore { get }
    var service: PlayService { get }
    
    var onWillAppear: CocoaAction { get }
    var didAnswer: Action<Bool, Void> { get }
    var didRestart: CocoaAction { get }
    
    func showAnswer(isCorrect: Bool) -> Observable<Bool>
    
    func handle(GameState state: GameState)
    
}

class RPPlayAction: PlayAction {
    
    private let disposeBag = DisposeBag()
    
    let store: PlayStore
    let service: PlayService
    
    init(store: PlayStore, service: PlayService) {
        self.store = store
        self.service = service
        
        service.state()
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                self.handle(GameState: state)
            }).disposed(by: disposeBag)
        
        service.totalScore()
            .bind(to: store.totalScore)
            .disposed(by: disposeBag)
        
        service.lifeCount()
            .bind(to: store.lifeCount)
            .disposed(by: disposeBag)
        
        service.timeOut()
            .flatMap({ [weak self] _ -> Observable<Bool> in
                guard let self = self else { return .empty() }
                return self.showAnswer(isCorrect: false)
            }).subscribe(onNext: { [weak self] isCorrect in
                guard let self = self else { return }
                self.didAnswer.execute(isCorrect)
            })
            .disposed(by: disposeBag)
        
        service.timerValue()
            .map { Float($0) }
            .bind(to: store.progress)
            .disposed(by: disposeBag)
                
    }
    
    lazy var onWillAppear: CocoaAction = {
        return CocoaAction { [weak self] in
            guard let self = self else { return .empty() }
            return self.service.change(GameStateTo: .playing)
        }
    }()
    
    lazy var didAnswer: Action<Bool, Void> = {
        return Action { [weak self] isCorrect in
            guard let self = self else { return .empty() }
            return self.service.change(GameStateTo: .didAnswer(isCorrect: isCorrect))
        }
    }()
    
    lazy var didRestart: CocoaAction = {
        return CocoaAction { [weak self] in
            guard let self = self else { return .empty() }
            self.service.stopCountDown()
            return self.service.change(GameStateTo: .restart)
        }
    }()
    
}

extension RPPlayAction {
    
    func handle(GameState state: GameState) {
        
        service.stopCountDown()
        
        switch state {
        case .generated(question: let question):
            store.stored(question: question)
            service.startCount(from: question.limitTime)
        case .gameOver:
            store.gameOver.accept(())
        default: break
        }
    }
    
    func showAnswer(isCorrect: Bool) -> Observable<Bool> {
        // Stop count down then show correct answer
        service.stopCountDown()
        
        return Observable.just(isCorrect)
            .delay(.milliseconds(500), scheduler: MainScheduler.instance)
    }

}
