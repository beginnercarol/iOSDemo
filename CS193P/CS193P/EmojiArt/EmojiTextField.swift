//
//  EmojiTextField.swift
//  CS193P
//
//  Created by Carol on 2019/2/7.
//  Copyright © 2019年 Carol. All rights reserved.
//

import UIKit

class EmojiTextField: UITextField {
    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                return mode
            }
        }
        return nil
    }
}
