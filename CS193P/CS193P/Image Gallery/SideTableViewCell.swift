//
//  SideTableViewCell.swift
//  CS193P
//
//  Created by Carol on 2019/3/11.
//  Copyright © 2019年 Carol. All rights reserved.
//

import UIKit

class SideTableViewCell: UITableViewCell {
    lazy var titleTextField: UITextField = {
        let input = UITextField(frame: self.bounds)
        return input
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: self.bounds)
        return label
    }()
    
    var titleHandler: ((String)-> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.isUserInteractionEnabled = true
        self.addSubview(titleLabel)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickToChangeName(_:))))
    }
    
    @objc func clickToChangeName(_ sender: UITapGestureRecognizer) {
        titleLabel.removeFromSuperview()
        addSubview(titleTextField)
        titleTextField.becomeFirstResponder()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
extension SideTableViewCell: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            textField.text = nil
            self.resignFirstResponder()
            textField.removeFromSuperview()
            addSubview(titleLabel)
            titleLabel.text = text
            titleHandler?(text)
            
        }
    }
}
