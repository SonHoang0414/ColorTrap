//
//  HomeModule.swift
//  ColorTrap
//
//  Created by SonHoang on 4/21/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import Foundation
import Swinject

class HomeModule: Module {
    
    override func register() {
        
        container.register(HomeViewController.self) { resolver in
            let homeViewController = UIStoryboard.home.controller(of: HomeViewController.self)
            homeViewController.store = resolver.resolve(HomeStore.self)
            homeViewController.action = resolver.resolve(HomeAction.self)
            return homeViewController
        }
        
        container.register(HomeStore.self) { _ in
            return RPHomeStore()
        }
        
        container.register(HomeAction.self) { resolver in
            return RPHomeAction(store: resolver.resolve(HomeStore.self)!, service: resolver.resolve(HomeService.self)!)
        }
        
        // Domain Model
        container.register(HomeService.self) { resolver in
            return RPHomeService(notification: resolver.resolve(HomeNotification.self)!, coordinator: resolver.resolve(HomeCoordinator.self)!)
        }
        
        container.register(HomeNotification.self) { _ in
            return RPHomeNotification()
        }
        
        container.register(HomeCoordinator.self) { resolver in
            return RPHomeCoordinator(modalCoordinator: resolver.resolve(HomeModalCoordinator.self)!)
        }
        
        container.register(HomeModalCoordinator.self) { _ in
            return RPHomeModalCoordinator()
        }.initCompleted { [weak self] (resolver, modalCoordinator) in

            guard let self = self,
                let modalCoordinator = modalCoordinator as? RPHomeModalCoordinator,
                let homeViewController = resolver.resolve(HomeViewController.self)
            else { return }

            let playViewController = self.getController(of: PlayViewController.self, in: self.parent!.playModule)
            modalCoordinator.homeViewController = homeViewController
            modalCoordinator.getPlayViewController = { return playViewController }
            
        }
        
    }
    
}
