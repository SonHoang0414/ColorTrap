//
//  UIStoryboard+Extensions.swift
//  ColorTrap
//
//  Created by SonHoang on 4/21/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import UIKit

extension UIStoryboard {

    static var main: UIStoryboard   { return UIStoryboard(name: "Main", bundle: nil) }
    static var home: UIStoryboard   { return UIStoryboard(name: "Home", bundle: nil) }
    static var play: UIStoryboard   { return UIStoryboard(name: "Play", bundle: nil) }

}

extension UIStoryboard {
    
    func controller<Controller: UIViewController>(of type: Controller.Type) -> Controller {
        return self.instantiateViewController(withIdentifier: String(describing: type)) as! Controller
    }
    
}
