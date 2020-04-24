//
//  GamePlayNotificationName.swift
//  ColorTrap
//
//  Created by SonHoang on 4/21/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import Foundation

extension Notification.Name {
    static var PlayGame         : Notification.Name { return Notification.Name("PlayGame") }
    static var GameState        : Notification.Name { return Notification.Name("GameState") }
    static var PointUp          : Notification.Name { return Notification.Name("PointUp") }
    static var TotalScore       : Notification.Name { return Notification.Name("TotalScore") }
    static var LifeCount        : Notification.Name { return Notification.Name("LifeCount") }
    static var RestartGame      : Notification.Name { return Notification.Name("RestartGame") }
    static var Question         : Notification.Name { return Notification.Name("Question") }
    static var RenewQuestion    : Notification.Name { return Notification.Name("RenewQuestion") }
    static var UserAnswer       : Notification.Name { return Notification.Name("UserAnswer") }
}

let kGameState  = "kGameState"
let kQuestion   = "kQuestion"
let kGameScore  = "kGameScore"
let kLifeCount  = "kLifeCount"
let kUserAnswer = "kUserAnswer"
