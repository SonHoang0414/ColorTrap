//
//  PlayStore.swift
//  ColorTrap
//
//  Created by SonHoang on 4/22/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

protocol PlayStore {
    
    var totalScore: PublishRelay<Int> { get }
    var lifeCount: PublishRelay<Int> { get }
    var progress: PublishRelay<Float> { get }
    var gameOver: PublishRelay<Void> { get }
    
    var sample: Signal<Answer> { get }
    var answers: Driver<[SectionModel<String, Answer>]> { get }
        
    func stored(question: Question)
    
}

class RPPlayStore: PlayStore {

    var totalScore = PublishRelay<Int>()
    var lifeCount = PublishRelay<Int>()
    var progress = PublishRelay<Float>()
    var gameOver = PublishRelay<Void>()
    
    lazy var sample: Signal<Answer> = { return sampleRelay.asSignal() }()
    lazy var answers: Driver<[SectionModel<String, Answer>]> = { return answersRelay.asDriver() } ()
    
    private let sampleRelay = PublishRelay<Answer>()
    private let answersRelay = BehaviorRelay<[SectionModel<String, Answer>]>(value: [])
    
    func stored(question: Question) {
        sampleRelay.accept(question.sample)
        answersRelay.accept([SectionModel(model: "", items: question.answers)])
    }

}
