//
//  GraphicProcessRender.swift
//  CS193P
//
//  Created by Carol on 2019/3/25.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit
import MetalKit

class GraphicProcessRender: NSObject, MTKViewDelegate {
    var device: MTLDevice!
    var commandQueue: MTLCommandQueue!
    var renderCommandEncoder: MTLRenderCommandEncoder!
    var pipelineState: MTLRenderPipelineState!
    
    init(withMTKView view: MTKView) {
        super.init()
        device = view.device
        let defaultLibrary = device.makeDefaultLibrary()
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.label = "Simple pipeline"
        
        guard let pipeState = try? device.makeRenderPipelineState(descriptor: pipelineStateDescriptor) else {
            print("Error when use pipelinestate")
            return
        }
        
        pipelineState = pipeState
        
        commandQueue = device.makeCommandQueue()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        <#code#>
    }
    
    func draw(in view: MTKView) {
        <#code#>
    }

    
}
