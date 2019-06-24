//
//  ImageInputCollectionViewCell.swift
//  CS193P
//
//  Created by Carol on 2019/3/12.
//  Copyright © 2019年 Carol. All rights reserved.
//

import UIKit

class ImageInputCollectionViewCell: UICollectionViewCell {
    lazy var emojiTextField: EmojiTextField = {
        let textField = EmojiTextField(frame: self.bounds)
        textField.delegate = self
        return textField
    }()
    
    var resignationHandler: (()-> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(emojiTextField)
//        emojiTextField.becomeFirstResponder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ImageInputCollectionViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        emojiTextField.text = ""
        emojiTextField.resignFirstResponder()
        resignationHandler?()
    }
}
