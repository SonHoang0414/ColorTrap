//
//  UIViewController+Extension.swift
//  ColorTrap
//
//  Created by SonHoang on 4/23/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    public var dismissWithoutCompletion: Binder<Void> {
        return Binder(self.base) { (controller, _) in
            controller.dismiss(animated: true, completion: nil)
        }
    }
}
