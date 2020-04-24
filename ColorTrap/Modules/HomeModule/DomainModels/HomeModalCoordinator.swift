//
//  HomeModalCoordinator.swift
//  ColorTrap
//
//  Created by SonHoang on 4/22/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeModalCoordinator {
    
    func presentPlayViewController() -> Observable<Void>
    
}

class RPHomeModalCoordinator: HomeModalCoordinator {
    
    weak var homeViewController: HomeViewController?
    var getPlayViewController: (() -> PlayViewController?)?
    
    func presentPlayViewController() -> Observable<Void> {
        
        return Observable.create { [weak self] observable -> Disposable in
            guard
                let self = self,
                let homeViewController = self.homeViewController,
                let playViewController = self.getPlayViewController?()
            else {
                observable.onNext(())
                observable.onCompleted()
                return Disposables.create()
            }
            
            playViewController.modalTransitionStyle = .crossDissolve
            playViewController.modalPresentationStyle = .fullScreen
            homeViewController.present(playViewController, animated: true) {
                observable.onNext(())
                observable.onCompleted()
            }
            return Disposables.create()
        }
        
    }
    
}
