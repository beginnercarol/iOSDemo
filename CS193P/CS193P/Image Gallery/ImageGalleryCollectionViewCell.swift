//
//  ImageGalleryCollectionViewCell.swift
//  CS193P
//
//  Created by Carol on 2019/3/11.
//  Copyright © 2019年 Carol. All rights reserved.
//

import UIKit

class ImageGalleryCollectionViewCell: UICollectionViewCell {
    var image: String! {
        didSet {
            imageLabel.attributedText = Utility.attributedString(from: image, size: fontSize)
        }
    }
    lazy var imageLabel: UILabel = {
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
        self.layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
        clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ImageGalleryCollectionViewCell {
    struct SizeRatio {
        static let sizeRation: CGFloat = 0.8
    }
    
    private var fontSize: CGFloat {
        return self.frame.height * SizeRatio.sizeRation
    }
}


