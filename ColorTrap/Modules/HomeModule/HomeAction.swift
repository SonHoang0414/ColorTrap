//
//  HomeAction.swift
//  ColorTrap
//
//  Created by SonHoang on 4/21/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import Foundation
import Action
import RxSwift
import UIKit

protocol HomeAction {
    var store: HomeStore { get }
    var service: HomeService { get }
    
    var onStart: CocoaAction { get }
}

class RPHomeAction: HomeAction {
    
    private let disposeBag = DisposeBag()
    
    let store: HomeStore
    let service: HomeService
    
    init(store: HomeStore, service: HomeService) {
        
        self.store = store
        self.service = service

    }
    
    lazy var onStart: CocoaAction = {
        return CocoaAction { [weak self] rect in
            guard let self = self else { return .empty() }
            return self.service.start()
        }
    }()
}
