//
//  HomeViewController.swift
//  ColorTrap
//
//  Created by SonHoang on 4/21/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import UIKit
import RxSwift

class HomeViewController: UIViewController {
    
    @IBOutlet weak var startGameButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    var store: HomeStore!
    var action: HomeAction!

    override func viewDidLoad() {
        super.viewDidLoad()

        bindingActionAndStore()
    }
    
    private func bindingActionAndStore() {
        
        // Binding view action
        startGameButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.action.onStart.execute()
            }).disposed(by: disposeBag)
    }

}
