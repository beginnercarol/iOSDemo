//
//  ResultScene.swift
//  SpriteKitDemo
//
//  Created by Carol on 2019/5/14.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit
import SpriteKit

class ResultScene: SKScene {
    var won: Bool = false
    
    init(size: CGSize, won: Bool) {
        self.won = won
        super.init(size: size)
        self.backgroundColor = SKColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        let font = UIFont.preferredFont(forTextStyle: .body)
        let fontMetric = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        var paragraph = NSParagraphStyle.default
        
        var data = won ? "You win" : "Lost"
        let attributedString = NSAttributedString(string: data, attributes: [NSAttributedString.Key.font: fontMetric, NSAttributedString.Key.paragraphStyle: paragraph])
        
        let resultLabel = SKLabelNode(attributedText: attributedString)
        resultLabel.position = self.frame.center
        
        self.addChild(resultLabel)
        
        let retryLabel = SKLabelNode(attributedText: NSAttributedString(string: "Retry?", attributes: [NSAttributedString.Key.font: fontMetric, NSAttributedString.Key.paragraphStyle: paragraph]))
        
        retryLabel.position = CGPoint(x: resultLabel.position.x, y: resultLabel.position.y * 0.8)
        retryLabel.name = "retryLabel"
        self.addChild(retryLabel)
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchPoint = touch.location(in: self)
            let node = self.nodes(at: touchPoint).first!
            
            if node.name == "retryLabel" {
                changeToGameScene()
            }
        }
    }
    
    func changeToGameScene() {
        let gameScene = GameScene(size: self.size)
        let revealTransition = SKTransition.reveal(with: .down, duration: 1.0)
        self.scene?.view?.presentScene(gameScene, transition: revealTransition)
    }
}


extension CGRect {
    var center: CGPoint {
        return CGPoint(x: self.midX, y: self.midY)
    }
}
