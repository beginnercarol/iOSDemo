//
//  PhotoScrollCollectionViewCell.swift
//  DTSlidebarAnimation
//
//  Created by Carol on 2019/6/15.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit

class PhotoScrollCollectionViewCell: UICollectionViewCell {
    lazy var imageView: UIImageView! = {
        let imgView = UIImageView(frame: self.bounds)
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
