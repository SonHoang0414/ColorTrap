//
//  Color+ColorName.swift
//  ColorTrap
//
//  Created by SonHoang on 4/22/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import UIKit

enum Color {
    
    case red
    case blue
    case yellow
    case black
    case green
    case purple
    case gray
    case brown
    case orange
    
    var value: UIColor {
        switch self {
        case .red:
            return .red
        case .blue:
            return .blue
        case .yellow:
            return .yellow
        case .black:
            return .black
        case .green:
            return .green
        case .purple:
            return .purple
        case .gray:
            return .gray
        case .brown:
            return .brown
        case .orange:
            return .orange
        }
    }
    
    var name: String {
        switch self {
        case .red:
            return "RED"
        case .blue:
            return "BLUE"
        case .yellow:
            return "YELLOW"
        case .black:
            return "BLACK"
        case .green:
            return "GREEN"
        case .purple:
            return "PURPLE"
        case .gray:
            return "GRAY"
        case .brown:
            return "BROWN"
        case .orange:
            return "ORANGE"
        }
    }
    
    static var allCase: [Color] {
        return [.red, .blue, .yellow, .black, .green, .purple, .gray, .brown, .orange]
    }
    
    static func color(byUIColor uiColor: UIColor) -> Color? {
        return allCase.first(where: { uiColor.isEqual($0.value) })
    }

}
