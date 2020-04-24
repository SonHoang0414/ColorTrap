//
//  GameState.swift
//  ColorTrap
//
//  Created by SonHoang on 4/21/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import UIKit

enum GameState {
    case initial
    case playing
    case nextQuestion
    case renewQuestion
    case generated(question: Question)
    case didAnswer(isCorrect: Bool)
    case gameOver
    case restart
    
    var isInitial: Bool {
        switch self {
        case .initial:
            return true
        default:
            return false
        }
    }
    
    var isGameOver: Bool {
        switch self {
        case .gameOver:
            return true
        default:
            return false
        }
    }
}
