//
//  ImageAddCollectionViewCell.swift
//  CS193P
//
//  Created by Carol on 2019/3/12.
//  Copyright © 2019年 Carol. All rights reserved.
//

import UIKit

class ImageAddCollectionViewCell: UICollectionViewCell {

    lazy var addButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.frame = self.frame
        btn.setImage(UIImage(named: "addUnclick"), for: .normal)
        btn.setImage(UIImage(named: "addClicked"), for: .selected)
        return btn
    }()
    
    var resignationHandler: (()-> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(addButton)
        addButton.addTarget(self, action: #selector(addEmojis(_:)), for: .touchUpInside)
    }
    
    @objc func addEmojis(_ sender: UIButton) {
        resignationHandler?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



