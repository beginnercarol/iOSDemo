//
//  PlayingCardView.swift
//  
//
//  Created by Carol on 2019/5/6.
//

import UIKit

class PlayingCardView: UICollectionViewCell {
    private var emojiLabel: UILabel
    var text: String? {
        set {
            emojiLabel.text = newValue
        }
        get {
            return emojiLabel.text
        }
    }
    override init(frame: CGRect) {
        emojiLabel = UILabel()
        super.init(frame: frame)
        self.contentView.addSubview(emojiLabel)
        emojiLabel.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
        emojiLabel.textAlignment = .center
        emojiLabel.font = UIFont.systemFont(ofSize: 20)
        self.backgroundColor = UIColor.orange
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
