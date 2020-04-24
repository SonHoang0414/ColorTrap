//
//  AppDelegate.swift
//  ColorTrap
//
//  Created by SonHoang on 4/21/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let module = ModuleContainer()
    
    var gameController: GameController!
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let gameModule = module.gameModule
        gameController = gameModule.container.resolve(GameController.self)!
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let homeModule = module.homeModule
        let homeController = homeModule.container.resolve(HomeViewController.self)!
        window?.rootViewController = homeController
        window?.makeKeyAndVisible()
        
        return true
    }
    


}

