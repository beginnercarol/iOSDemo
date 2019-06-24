//
//  GameElements.swift
//  FlappyBird
//
//  Created by Carol on 2019/5/11.
//  Copyright © 2019 Carol. All rights reserved.
//

import SpriteKit

struct CollisionBitMask {
    static let birdCategory:UInt32 = 0x1 << 0
    static let pillarCategory:UInt32 = 0x1 << 1
    static let flowerCategory:UInt32 = 0x1 << 2
    static let groundCategory:UInt32 = 0x1 << 3
}

extension GameScene {
    private var BtnDimension: CGFloat {
        return 100
    }
    
    func createStartBtn() {
        let startBtn = SKSpriteNode(imageNamed: "play")
        startBtn.size = CGSize(width: BtnDimension, height: BtnDimension)
        startBtn.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        startBtn.setScale(0)
        startBtn.zPosition = 6
        startBtn.name = NodeName.StartButton
        self.startBtn = startBtn
        self.addChild(startBtn)
        startBtn.run(SKAction.scale(to: 1.0, duration: 0.5))
    }
    
    func createPauseBtn() {
        let btn = SKSpriteNode(imageNamed: "pause")
        btn.size = CGSize(width: 40, height: 40)
        btn.position = CGPoint(x: self.frame.width-30, y: self.frame.height-30)
        btn.zPosition = 6
        self.pauseBtn = btn
        self.addChild(btn)
    }
    
    
    
    
    
}
