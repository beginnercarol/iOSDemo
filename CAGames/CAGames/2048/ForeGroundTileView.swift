//
//  ForeGroundTileView.swift
//  CAGames
//
//  Created by Carol on 2019/4/30.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit

class ForeGroundTileView: UIView {
    var valueForTile: Int = 0 {
        didSet {
            layoutIfNeeded()
        }
    }
    
    var valueLabel = UILabel()
    
    override func layoutSubviews() {
        self.addSubview(valueLabel)
        let font = UIFont.preferredFont(forTextStyle: .body)
        let fontMatrix = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        
        let attributedString = NSAttributedString(string: "\(valueForTile)", attributes: [NSAttributedString.Key.font: fontMatrix])
        valueLabel.attributedText = attributedString
        valueLabel.textAlignment = .center
        valueLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.center.equalTo(self.snp.center)
        }
        self.layer.borderColor = UIColor(displayP3Red: 1.0, green: 199/255, blue: 133/255, alpha: 1.0).cgColor
        self.layer.borderWidth = 3
        self.layer.cornerRadius = 5
        self.backgroundColor = UIColor(displayP3Red: 245/255, green: 225/255, blue: 218/255, alpha: 1.0)
        self.clipsToBounds = true
    }
    
        override var intrinsicContentSize: CGSize {
            var orgSize = super.intrinsicContentSize
            valueLabel.sizeToFit()
            return valueLabel.intrinsicContentSize
        }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
