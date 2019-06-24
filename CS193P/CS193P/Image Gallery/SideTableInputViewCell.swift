//
//  SideTableInputViewCell.swift
//  CS193P
//
//  Created by Carol on 2019/3/18.
//  Copyright © 2019年 Carol. All rights reserved.
//

import UIKit

class SideTableInputViewCell: UITableViewCell {
    lazy var titleTextField: UITextField = {
        let input = UITextField(frame: self.bounds)
        return input
    }()
    
    var titleHandler: ((String)-> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addSubview(titleTextField)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

