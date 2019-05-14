//
//  GameScene.swift
//  FlappyBird
//
//  Created by Carol on 2019/5/11.
//  Copyright © 2019 Carol. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var isGameStarted: Bool = false
    var isDied: Bool = false
    let coinSound = SKAction.playSoundFileNamed("CoinSound.mp3", waitForCompletion: false)
    
    var score: Int = 0
    
    
    override func didMove(to view: SKView) {
        <#code#>
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        <#code#>
    }
    
    override func update(_ currentTime: TimeInterval) {
        <#code#>
    }
}
