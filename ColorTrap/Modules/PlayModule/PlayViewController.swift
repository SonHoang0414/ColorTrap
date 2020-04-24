//
//  PlayViewController.swift
//  ColorTrap
//
//  Created by SonHoang on 4/22/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class PlayViewController: UIViewController {
    
    @IBOutlet weak var quitGameButton: UIButton!
    
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var lifeCountLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var countDownProgress: UIProgressView!
    
    @IBOutlet weak var answerCollectionView: UICollectionView!
    
    private let disposeBag = DisposeBag()
    
    var store: PlayStore!
    var action: PlayAction!
    
    lazy var dataSouce = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Answer>>(configureCell: { (_, collectionView, indexPath, answer) -> UICollectionViewCell in
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnswerCollectionViewCell", for: indexPath) as? AnswerCollectionViewCell else { return UICollectionViewCell() }
        cell.configCell(with: answer)
        return cell
    })

}

extension PlayViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindingStoreAndAction()
        bindingOtherAction()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        action.onWillAppear.execute()
    }
    
    private func bindingStoreAndAction() {

        store.totalScore.asSignal()
            .map { "\($0)" }
            .emit(to: totalScoreLabel.rx.text)
            .disposed(by: disposeBag)
        
        store.lifeCount.asSignal()
            .map { "\($0)" }
            .emit(to: lifeCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        store.sample
            .emit(onNext: { [weak self] correctAnswer in
                guard let self = self else { return }
                self.questionLabel.text = correctAnswer.colorName
                self.questionLabel.textColor = correctAnswer.color
            }).disposed(by: disposeBag)
        
        store.answers
            .drive(answerCollectionView.rx.items(dataSource: dataSouce))
            .disposed(by: disposeBag)
        
        store.progress.asSignal()
            .emit(to: countDownProgress.rx.progress)
            .disposed(by: disposeBag)
        
        store.gameOver.asSignal()
            .emit(onNext: { [weak self] _ in
                guard let self = self else { return }
                let alertViewController = UIAlertController(title: "Game Over", message: "Your score is :\(self.totalScoreLabel.text ?? "")", preferredStyle: .alert)
                let restartAction = UIAlertAction(title: "Restart", style: .default) { [weak self] _ in
                    guard let self = self else { return }
                    self.action.didRestart.execute()
                }
                let quitAction = UIAlertAction(title: "Quit", style: .destructive) { [weak self] _ in
                    guard let self = self else { return }
                    self.quitGameButton.sendActions(for: .touchUpInside)
                }
                alertViewController.addAction(quitAction)
                alertViewController.addAction(restartAction)
                self.present(alertViewController, animated: false, completion: nil)
            }).disposed(by: disposeBag)
    }
    
    private func bindingOtherAction() {
        quitGameButton.rx.tap
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.action.didRestart.execute()
            })
            .bind(to: rx.dismissWithoutCompletion)
            .disposed(by: disposeBag)
        
        answerCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        answerCollectionView.rx.modelSelected(Answer.self)
            .flatMap({ [weak self] answer -> Observable<Bool> in
                guard let self = self else { return .just(answer.isCorrect) }
                return self.action.showAnswer(isCorrect: answer.isCorrect)
            }).subscribe(onNext: { [weak self] isCorrect in
                guard let self = self else { return }
                self.action.didAnswer.execute(isCorrect)
            }).disposed(by: disposeBag)
    }
    
}

extension PlayViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: 50, height: 50)
    }

}
