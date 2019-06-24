//
//  EmojiArtResizableLabel.swift
//  CS193P
//
//  Created by Carol on 2019/2/10.
//  Copyright © 2019年 Carol. All rights reserved.
//

import UIKit

class EmojiArtResizableLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(resizeLabel(_:)))
        self.addGestureRecognizer(pinch)
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(rotateLabel(_:)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func resizeLabel(_ gestureRecognizer: UIPinchGestureRecognizer) {
        switch gestureRecognizer.state {
        case .ended:
            self.layer.borderWidth = 0
            fallthrough
        case .changed:
            self.transform = self.transform.scaledBy(x: gestureRecognizer.scale, y:gestureRecognizer.scale)
            gestureRecognizer.scale = 1.0
        default:
            self.layer.borderColor = UIColor.blue.cgColor
            self.layer.borderWidth = 3
            self.layer.cornerRadius = 5
            self.clipsToBounds = true
            break
        }
    }
    
    @objc func rotateLabel(_ gestureRecognizer: UIRotationGestureRecognizer) {
        switch gestureRecognizer.state {
        case .ended:
            self.layer.borderWidth = 0
            fallthrough
        case .changed:
            self.transform = CGAffineTransform(rotationAngle: gestureRecognizer.rotation)
            gestureRecognizer.rotation = 0
        default:
            break
        }
    }
    
    

}
