//
//  GraphicProcessViewController.swift
//  CS193P
//
//  Created by Carol on 2019/3/24.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit
import MetalKit


class GraphicProcessViewController: UIViewController {
    var device: MTLDevice!
    var commandQueue: MTLCommandQueue!
    var renderCommandEncoder: MTLRenderCommandEncoder!
    lazy var mtkView: MTKView = {
       let mtk = MTKView(frame: view.bounds)
        return mtk
    }()
    var defaultLibrary: MTLLibrary!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mtkView)
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Failed to get the system's default Metal device.")
        }
        self.device = device
        commandQueue = device.makeCommandQueue()
        guard let commandBuffer = commandQueue.makeCommandBuffer() else {
            return
        }
        mtkView.device = device
        defaultLibrary = device.makeDefaultLibrary()
        
        
        if let renderDiscriptor = mtkView.currentRenderPassDescriptor {
            renderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: mtkView.currentRenderPassDescriptor!)
            renderCommandEncoder.label =  Utility.GraphicProcessLabel.RenderEncoderLabel
        }
        
        commandBuffer.commit()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
