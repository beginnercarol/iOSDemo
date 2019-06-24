//
//  PlaceholderCell.swift
//  CS193P
//
//  Created by Carol on 2019/2/6.
//  Copyright © 2019年 Carol. All rights reserved.
//

import UIKit

class PlaceholderCell: UICollectionViewCell {
    lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        
        return indicator
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.contentView.addSubview(indicator)
        indicator.startAnimating()
    }
}
