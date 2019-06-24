//
//  TextFieldCollectionViewCell.swift
//  CS193P
//
//  Created by Carol on 2019/2/6.
//  Copyright © 2019年 Carol. All rights reserved.
//

import UIKit

class TextFieldCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    lazy var textField: EmojiTextField = {
        let textField = EmojiTextField()
        let font = UIFont.preferredFont(forTextStyle: .body).withSize(22)
        let fontMatrix = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        textField.font = fontMatrix
        textField.textAlignment = .left
        textField.clearButtonMode = .always
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    var resignationHandler: (() -> Void)? // 父添加相应的操作
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        resignFirstResponder()
        resignationHandler?()
        textField.text = nil
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.layer.borderWidth = 3.0
        textField.layer.borderColor = UIColor.blue.cgColor
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 5.0
        return true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(textField)
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        textField.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
        textField.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
