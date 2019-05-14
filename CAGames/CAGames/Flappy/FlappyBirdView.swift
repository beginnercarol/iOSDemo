//
//  FlappyBirdView.swift
//  CAGames
//
//  Created by Carol on 2019/5/11.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit

class FlappyBirdView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var position: CGPoint = .zero
    var viewBird: UIImageView!
    
    override func layoutSubviews() {
        viewBird = UIImageView(frame: self.bounds)
        self.addSubview(viewBird)
    }

}
