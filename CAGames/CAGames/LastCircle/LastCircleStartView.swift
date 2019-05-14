//
//  LastCircleStartView.swift
//  CAGames
//
//  Created by Carol on 2019/5/5.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit

class LastCircleStartView: UIView {
    var gameStart: CircleView!
//    var gameStartAction:((UITapGestureRecognizer) -> Void)!
    override init(frame: CGRect) {
        super.init(frame: frame)
        let circle = CACircle(position: CGPoint(x: self.bounds.width/2, y: self.bounds.height/2), radius: 80, color: UIColor.getRandomColor())
        gameStart = CircleView(withCircle: circle, withLabel: true)
        self.addSubview(gameStart)
        gameStart.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.width.equalTo(160)
            make.height.equalTo(160)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIColor {
    static func getRandomColor() -> UIColor{
        let r = CGFloat(arc4random_uniform(UInt32(255)))/255
        let g = CGFloat(arc4random_uniform(UInt32(255)))/255
        let b = CGFloat(arc4random_uniform(UInt32(255)))/255
        return UIColor(displayP3Red: r, green: g, blue: b, alpha: 1.0)
    }
}
