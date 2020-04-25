//
//  GamePlayNotificationName.swift
//  ColorTrap
//
//  Created by SonHoang on 4/21/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import Foundation

extension Notification.Name {
    static var GameModuleState  : Notification.Name { return Notification.Name("GameModuleState") }
    static var HomeModuleState  : Notification.Name { return Notification.Name("HomeModuleState") }
    static var TotalScore       : Notification.Name { return Notification.Name("TotalScore") }
    static var LifeCount        : Notification.Name { return Notification.Name("LifeCount") }
}

let kGameModuleState  = "kGameModuleState"
let kHomeModuleState  = "kHomeModuleState"
let kGameScore  = "kGameScore"
let kLifeCount  = "kLifeCount"
