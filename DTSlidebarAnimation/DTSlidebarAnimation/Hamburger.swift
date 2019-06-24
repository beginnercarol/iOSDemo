//
//  Hamburger.swift
//  DTSlidebarAnimation
//
//  Created by Carol on 2019/6/11.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit

class Hamburger: UIView {
    var imageView: UIImageView!
    override init(frame: CGRect) {
        super.init(frame: frame)
                imageView = UIImageView(frame: self.bounds)
        self.frame = CGRect(x: 0, y: 0, width: self.frame.width+80, height: self.frame.height)
        imageView.image = UIImage(named: "Hamburger")
        imageView.sizeToFit()
        self.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeDirection() {
        if imageView.frame.origin.x == 0 {
//            self.frame = CGRect(x: 0, y: 0, width: self.frame.width+80, height: self.frame.height)
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5, animations: {
                    self.imageView.frame.origin.x = 80
                    
                    self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
                })
            }
        } else {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5, animations: {
                    self.imageView.frame.origin.x = 0
                    self.imageView.transform = .identity
                })
            }
        }
    }
    
}
