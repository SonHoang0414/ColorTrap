//
//  Answer.swift
//  ColorTrap
//
//  Created by SonHoang on 4/22/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import UIKit

protocol Answer {
    
    var colorName: String { get }
    var color: UIColor { get }
    var isCorrect: Bool { get }
    
}

class RPAnswer: Answer {
    
    var colorName: String
    var color: UIColor
    var isCorrect: Bool
    
    init(colorName: String, color: UIColor, isCorrect: Bool) {
        self.colorName = colorName
        self.color = color
        self.isCorrect = isCorrect
    }
    
}
