//
//  AnswerCollectionViewCell.swift
//  ColorTrap
//
//  Created by SonHoang on 4/23/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import UIKit

class AnswerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var answerLabel: UILabel!
    
    func configCell(with answer: Answer) {
        answerLabel.text = answer.colorName
        answerLabel.textColor = answer.color
    }
    
}
