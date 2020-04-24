//
//  Container.swift
//  ColorTrap
//
//  Created by SonHoang on 4/21/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import Foundation
import Swinject

class ModuleContainer {

    lazy var homeModule: HomeModule = { return HomeModule(parent: self) }()
    
    lazy var gameModule: GameModule = { return GameModule(parent: self) }()
    
    lazy var playModule: PlayModule = { return PlayModule(parent: self) }()

}

class Module {
    weak var parent: ModuleContainer?
    let container = Container()
    
    init(parent: ModuleContainer?) {
        self.parent = parent
        register()
    }
    
    func register() {
        fatalError("Subclass Implementation")
    }
    
    func getController<C: UIViewController>(of controllerType: C.Type, in module: Module) -> C {
        guard let controller = module.container.resolve(controllerType) else {
            fatalError("\(String(describing: controllerType)) not found")
        }
        return controller
    }

}
