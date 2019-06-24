//
//  EmojiHeaderCell.swift
//  CS193P
//
//  Created by Carol on 2019/2/3.
//  Copyright © 2019年 Carol. All rights reserved.
//

import UIKit

class EmojiHeaderCell: UICollectionViewCell {
    lazy var addButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.frame = self.bounds
        button.setImage(UIImage(named: "addUnclick"), for: .normal)
        
        button.setTitle("def", for: .normal)
        button.setTitle("highlight", for: .highlighted)
        button.setTitle("focused", for: .focused)
        button.setTitle("selected", for: .selected)
        button.tintColor = UIColor.red
        button.titleLabel?.sizeToFit()
        button.setTitleColor(UIColor.blue, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body).withSize(20)
        let titleLabelWidth = button.titleLabel!.bounds.size.width
        let imageViewWidth = button.imageView!.bounds.size.width
        let titleLabelHeight = button.titleLabel!.bounds.size.height
        let imageViewHeight = button.imageView!.bounds.size.height
        let interSpace: CGFloat = 4.0
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: titleLabelHeight+interSpace, right: -(interSpace+titleLabelWidth))
        button.titleEdgeInsets = UIEdgeInsets(top: imageViewHeight+interSpace, left: -(interSpace+imageViewWidth), bottom: 0, right: 0)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.contentView.addSubview(addButton)
//        addButton.addTarget(self, action: #selector(addMoreEmojis(_:)), for: .touchUpInside)
    }
    
    @objc func addMoreEmojis(_ sender: UIButton) {
        let textField = UITextField()
        textField.becomeFirstResponder()
    }
    
    
}
