//
//  FilterCollectionViewCell.swift
//  CAGames
//
//  Created by Carol on 2019/5/25.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit
import AVFoundation
import GLKit

class FilterCollectionViewCell: UICollectionViewCell {
    var videoPreviewView: GLKView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        videoPreviewView = GLKView(frame: self.bounds)
        videoPreviewView.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2.0)
        videoPreviewView.frame = self.bounds
        self.addSubview(videoPreviewView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
