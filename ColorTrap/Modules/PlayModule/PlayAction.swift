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
    
    func handleQuestionReceive(question: Question?)
    func showAnswer(isCorrect: Bool) -> Observable<Bool>
}

class RPPlayAction: PlayAction {
    
    private let disposeBag = DisposeBag()
    
    let store: PlayStore
    let service: PlayService
    
    init(store: PlayStore, service: PlayService) {
        self.store = store
        self.service = service
        
        service.totalScore()
            .bind(to: store.totalScore)
            .disposed(by: disposeBag)
        
        service.lifeCount()
            .bind(to: store.lifeCount)
            .disposed(by: disposeBag)
        
        service.question()
            .subscribe(onNext: { [weak self] question in
                guard let self = self else { return }
                self.handleQuestionReceive(question: question)
            }).disposed(by: disposeBag)
        
        service.state()
            .filter { $0 == .gameOver }
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.service.stopCountDown()
            })
            .map { _ in }
            .bind(to: store.gameOver)
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
            return self.service.start()
        }
    }()
    
    lazy var didAnswer: Action<Bool, Void> = {
        return Action { [weak self] isCorrect in
            guard let self = self else { return .empty() }
            return self.service.didAnswer(isCorrect: isCorrect)
        }
    }()
    
    lazy var didRestart: CocoaAction = {
        return CocoaAction { [weak self] in
            guard let self = self else { return .empty() }
            self.service.stopCountDown()
            return self.service.restart()
        }
    }()
    
}

extension RPPlayAction {
    
    func showAnswer(isCorrect: Bool) -> Observable<Bool> {
        // Stop count down then show correct answer
        service.stopCountDown()
        
        return Observable.just(isCorrect)
            .delay(.milliseconds(500), scheduler: MainScheduler.instance)
    }
    
    func handleQuestionReceive(question: Question?) {
        if let question = question {
            store.stored(question: question)
            service.startCount(from: question.limitTime)
        } else {
            service.renewQuestion()
                .subscribe().dispose()
        }
    }
}
