//
//  TileView.swift
//  CAGames
//
//  Created by Carol on 2019/4/28.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit

class TileView: UIView {
    override func layoutSubviews() {
        self.layer.borderColor = UIColor(displayP3Red: 113/255, green: 137/255, blue: 191/255, alpha: 1.0).cgColor
        self.backgroundColor = UIColor(displayP3Red: 169/255, green: 198/255, blue: 222/255, alpha: 1.0)
        self.layer.borderWidth = 3
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
