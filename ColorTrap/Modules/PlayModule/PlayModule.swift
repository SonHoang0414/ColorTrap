//
//  PlayModule.swift
//  ColorTrap
//
//  Created by SonHoang on 4/22/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import Foundation
import Swinject

class PlayModule: Module {
    
    override func register() {
        
        container.register(PlayViewController.self) { resolver in
            let controller = UIStoryboard.play.controller(of: PlayViewController.self)
            controller.action = resolver.resolve(PlayAction.self)!
            controller.store = resolver.resolve(PlayStore.self)!
            return controller
        }
        
        container.register(PlayAction.self) { resolver in
            return RPPlayAction(store: resolver.resolve(PlayStore.self)!, service: resolver.resolve(PlayService.self)!)
        }
        
        container.register(PlayService.self) { resolver in
            return RPPlayservice(notification: resolver.resolve(PlayNotification.self)!, timer: resolver.resolve(PlayTimer.self)!)
        }
        
        container.register(PlayStore.self) { _ in
            return RPPlayStore()
        }
        
        container.register(PlayNotification.self) { _ in
            return RPPlayNotification()
        }
        
        container.register(PlayTimer.self) { _ in
            return RPPlayTimer()
        }

    }
    
}
