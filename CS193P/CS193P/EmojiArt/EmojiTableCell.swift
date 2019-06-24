//
//  EmojiTableCell.swift
//  CS193P
//
//  Created by Carol on 2019/1/24.
//  Copyright © 2019年 Carol. All rights reserved.
//

import UIKit

class EmojiTableCell: UITableViewCell {
    lazy var input: UITextView! = {
        let input  = UITextView()
        input.layer.borderWidth = 2
        input.layer.borderColor = UIColor.gray.cgColor
        input.layer.cornerRadius = 3
        input.keyboardType = .asciiCapableNumberPad
        return input
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(input)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var editingStyle: UITableViewCell.EditingStyle {
        return .insert
    }
}

extension EmojiTableCell {
    private static let barbtnWidthToWidth: CGFloat = 0.30
}
