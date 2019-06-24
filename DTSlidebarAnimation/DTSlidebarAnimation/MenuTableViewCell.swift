//
//  MenuTableViewCell.swift
//  DTSlidebarAnimation
//
//  Created by Carol on 2019/6/10.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    var imgView: UIImageView!
    
    func configureCell(_ menuItem: MenuItem) {
        imgView = UIImageView(frame: self.frame)
        self.contentView.addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
        imgView.image = menuItem.image
        imgView.backgroundColor = menuItem.color
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
