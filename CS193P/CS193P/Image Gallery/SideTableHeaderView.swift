//
//  SideTableHeaderView.swift
//  CS193P
//
//  Created by Carol on 2019/3/12.
//  Copyright © 2019年 Carol. All rights reserved.
//

import UIKit

class SideTableHeaderView: UIView {
    var addNewFileButton: UIBarButtonItem!
    
    var addNewFileHandler: (()->Void)?
    
    lazy var toolBar: UIToolbar = {
        let bar = UIToolbar(frame: self.bounds)
        return bar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(toolBar)
        addNewFileButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewFile(_:)))
        toolBar.setItems([addNewFileButton], animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addNewFile(_ sender: UIBarButtonItem) {        
        addNewFileHandler?()
    }
    
}
