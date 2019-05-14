//
//  CircleView.swift
//  CAGames
//
//  Created by Carol on 2019/5/5.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit

class CircleView: UIView {
    var startLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(withCircle circle: CACircle, withLabel: Bool = false) {
        let frame = CGRect(x: 0, y: 0, width: 2*circle.radius, height: 2*circle.radius)
        super.init(frame: frame)
        layer.cornerRadius = CGFloat(circle.radius)
        clipsToBounds = true
        backgroundColor = circle.color
        if withLabel {
            startLabel = UILabel()
            self.addSubview(startLabel!)
            let font = UIFont.preferredFont(forTextStyle: .body)
            let fontMetrix = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
            let attributedString = NSAttributedString(string: "START", attributes: [.font: fontMetrix])
            startLabel?.attributedText = attributedString
            startLabel?.snp.makeConstraints({ (make) in
                make.center.equalTo(self)
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
