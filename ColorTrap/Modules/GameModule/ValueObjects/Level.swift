//
//  Level.swift
//  ColorTrap
//
//  Created by SonHoang on 4/22/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import UIKit

enum Level {
    
    case easy
    case medium
    case hard
    case veryHard
    
    // Second calculator
    var limitTimeByLevel: TimeInterval {
        switch self {
        case .easy:
            return 1
        case .medium:
            return 0.7
        case .hard:
            return 0.5
        case .veryHard:
            return 0.3
        }
    }
    
    // Second calculator
    var minLimitTimeByLevel: TimeInterval {
        switch self {
        case .easy:
            return 0.5
        case .medium:
            return 0.3
        case .hard:
            return 0.2
        case .veryHard:
            return 0.1
        }
    }
    
    var totalAnswerByLevel: Int {
        switch self {
        case .easy, .medium, .hard:
            return 2
        case .veryHard:
            return 3
        }
    }
    
    var maxAnswerByLevel: Int {
        switch self {
        case .easy:
            return 5
        case .medium:
            return 6
        case .hard:
            return 7
        case .veryHard:
            return 8
        }
    }
    
    var scoreToDecreaseTimeByLevel: Double {
        switch self {
        case .easy, .medium:
            return 30
        case .hard:
            return 20
        case .veryHard:
            return 7
        }
    }
    
    var scoreToInscreaseQuestionByLevel: Int {
        switch self {
        case .easy, .medium:
            return 10
        case .hard:
            return 7
        case .veryHard:
            return 5
        }
    }

}
