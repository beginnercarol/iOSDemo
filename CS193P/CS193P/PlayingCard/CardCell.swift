//
//  CardCellCollectionViewCell.swift
//  CS193P
//
//  Created by Carol on 2019/1/11.
//  Copyright © 2019年 Carol. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {
    var cardView: PlayingCardView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        cardView.layer.sublayers = nil
    }
    
    func initView(){
        cardView = PlayingCardView(frame: self.contentView.frame)
        self.contentView.addSubview(cardView)
    }
}
