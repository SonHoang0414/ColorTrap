//
//  HomeCoordinator.swift
//  ColorTrap
//
//  Created by SonHoang on 4/22/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeCoordinator {
    
    var modalCoordinator: HomeModalCoordinator { get }
    
    func presentPlayViewController() -> Observable<Void>
}

class RPHomeCoordinator: HomeCoordinator {
    
    let modalCoordinator: HomeModalCoordinator
    
    init(modalCoordinator: HomeModalCoordinator) {
        self.modalCoordinator = modalCoordinator
    }
    
    func presentPlayViewController() -> Observable<Void> {
        return modalCoordinator.presentPlayViewController()
    }

}
