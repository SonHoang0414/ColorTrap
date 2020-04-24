//
//  GameModule.swift
//  ColorTrap
//
//  Created by SonHoang on 4/22/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import Foundation

class GameModule: Module {
    override func register() {
        
        container.register(GameController.self) { resolver in
            return RPGameController(notification: resolver.resolve(GameNotification.self)!, dataSource: resolver.resolve(GameDataSource.self)!)
        }
        
        container.register(GameNotification.self) { _ in
            return RPGameNotification()
        }
        
        container.register(GameDataSource.self) { _ in
            return RPGameDataSource()
        }
        
    }
}
