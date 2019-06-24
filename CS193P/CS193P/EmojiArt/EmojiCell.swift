//
//  EmojiCellCollectionViewCell.swift
//  CS193P
//
//  Created by Carol on 2019/1/21.
//  Copyright © 2019年 Carol. All rights reserved.
//

import UIKit

class EmojiCell: UICollectionViewCell {
    var emoji: String! {
        didSet {
            emojiLabel.text = emoji
        }
    }
    
    lazy var emojiLabel: UILabel! = {
        let label = UILabel(frame: self.bounds)
        self.contentView.addSubview(label)
        let font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        let fontMetrix = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        label.font = fontMetrix
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        emojiLabel.attributedText = nil
    }
    
}

extension EmojiCell {
    private struct SizeRatio {
        static let fontRatioToHeight: CGFloat = 0.83
    }
    
    private var fontSize: CGFloat {
        return SizeRatio.fontRatioToHeight * self.frame.height
    }
}
