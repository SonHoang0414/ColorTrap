//
//  HomeService.swift
//  ColorTrap
//
//  Created by SonHoang on 4/21/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeService {

    var notification: HomeNotification { get }
    var coordinator: HomeCoordinator { get }
    
    func start() -> Observable<Void>

}

class RPHomeService: HomeService {

    let notification: HomeNotification
    let coordinator: HomeCoordinator
    
    init(notification: HomeNotification, coordinator: HomeCoordinator) {
        self.notification = notification
        self.coordinator = coordinator
    }
    
    func start() -> Observable<Void> {
        return coordinator.presentPlayViewController()
    }

}
