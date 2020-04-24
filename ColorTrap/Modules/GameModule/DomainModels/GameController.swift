//
//  GameController.swift
//  ColorTrap
//
//  Created by SonHoang on 4/22/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol GameController {

    var notification: GameNotification { get }
    var dataSource: GameDataSource { get }
    
}

class RPGameController: GameController {
    
    private let disposeBag = DisposeBag()
    
    let notification: GameNotification
    let dataSource: GameDataSource
    
    init(notification: GameNotification, dataSource: GameDataSource) {
        self.notification = notification
        self.dataSource = dataSource
        
        notification.state()
            .bind(to: dataSource.state)
            .disposed(by: disposeBag)

        dataSource.stateOutput
            .subscribe(onNext: { [weak self] state in
                guard let self = self else { return }
                self.change(gameState: state)
            }).disposed(by: disposeBag)
        
        dataSource.lifeCountOutPut
            .subscribe(onNext: { [weak self] lifeCount in
                guard let self = self else { return }
                self.send(lifeCount: lifeCount)
            }).disposed(by: disposeBag)
        
        dataSource.scoreOutPut
            .subscribe(onNext: { [weak self] totalScore in
                guard let self = self else { return }
                self.send(totalScore: totalScore)
            }).disposed(by: disposeBag)
    }
    
    private func change(gameState state: GameState) {
        notification.change(gameState: state)
            .subscribe().dispose()
    }
    
    private func send(lifeCount: Int) {
        notification.send(lifeCount: lifeCount)
            .subscribe().dispose()
    }
    
    private func send(totalScore: Int) {
        notification.send(totalScore: totalScore)
            .subscribe().dispose()
    }

}
