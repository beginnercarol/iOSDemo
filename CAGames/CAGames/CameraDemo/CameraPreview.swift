//
//  CameraPreview.swift
//  CAGames
//
//  Created by Carol on 2019/5/18.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit
import AVFoundation

class CameraPreview: UIView {
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    
}
