//
//  GameScene.swift
//  SpriteKitDemo
//
//  Created by Carol on 2019/5/13.
//  Copyright © 2019 Carol. All rights reserved.
//
import Foundation
import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    private var monsters: [SKNode] = []
    private var projectiles: [SKNode] = []
    
    var monsterKilled: Int = 0
    
    override init(size: CGSize) {
        super.init(size: size)
        self.backgroundColor = SKColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        let player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: player.size.width/2, y: size.height/2)
        
        self.addChild(player)
        let actionAddMonster = SKAction.run {[weak self] in
            self?.addMonster()
        }
        
        let pauseAction = SKAction.wait(forDuration: 1.0)
        let actionSeq = SKAction.sequence([actionAddMonster, pauseAction])
        let repeatAction = SKAction.repeatForever(actionSeq)
        self.run(repeatAction)
    }
    
    func addMonster() {
        let monster = SKSpriteNode(imageNamed: "monster")
        let size = self.size
        let minY = monster.size.height / 2
        let maxY = size.height - minY
        let actualY = CGFloat(CGFloat(arc4random_uniform(UInt32(maxY-minY))) + minY)
        
        monster.position = CGPoint(x: size.width + monster.size.width/2, y: actualY)
        
        self.addChild(monster)
        monsters.append(monster)
        
        // speed of monster
        let minDuration: CGFloat = 2.0
        let maxDuration: CGFloat = 4.0
        let actualDuration = CGFloat(CGFloat(arc4random_uniform(UInt32(maxDuration-minDuration))) + minDuration)
        
        let actionMove = SKAction.move(to: CGPoint(x: -size.width/2, y: actualY), duration: TimeInterval(actualDuration))
        monster.run(actionMove) {[unowned monster] in
            monster.removeFromParent()
            self.monsters.removeObject(monster)
            // show result scene
            self.changeToResultScene(withResult: false)
        }
        
    }
    
    func changeToResultScene(withResult won: Bool) {
        let resultScene = ResultScene(size: self.size, won: won)
        let transitionReveal = SKTransition.reveal(with: SKTransitionDirection.up, duration: 1.0)
        
        self.scene?.view?.presentScene(resultScene, transition: transitionReveal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_ currentTime: TimeInterval) {
        var projectilesToDelete = [SKNode]()
        var monstersToDelete = [SKNode]()
        for projectile in self.projectiles {
            for monster in self.monsters {
                if (monster.frame).intersects(projectile.frame) {
                    monstersToDelete.append(monster)
                }
            }
            for monster in monstersToDelete {
                monster.removeFromParent()
                self.monsters.removeObject(monster)
                self.monsterKilled += 1
                if self.monsterKilled >= 30 {
                    // show  new  scene
                    self.changeToResultScene(withResult: true)
                }
            }
            if monstersToDelete.count > 0 {
                projectilesToDelete.append(projectile)
            }
        }
        
        
        
        for projectile in projectilesToDelete {
            projectile.removeFromParent()
            self.projectiles.removeObject(projectile)
        }
    }
    
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let size = self.size
            let projectile = SKSpriteNode(imageNamed: "projectile.png")
            projectile.position = CGPoint(x: projectile.size.width/2, y: size.height/2)
            
            let location = touch.location(in: self)
            let offset = CGPoint(x: location.x - projectile.position.x, y: location.y - projectile.position.y)
            
            if offset.x < 0 {
                return
            }
            
            self.addChild(projectile)
            projectiles.append(projectile)
            
            let realX = Float(size.width + projectile.size.width/2)
//            let ratio: float = float(offset.y / offset.x)
            
            let ratio: Float = Float(offset.y / offset.x)
            
            let realY = realX * ratio + Float(location.y)
            
            let offRealX = realX - Float(projectile.position.x)
            let offRealY = realY - Float(projectile.position.y)
            let dis: Float = sqrt((offRealX*offRealX) + (offRealY*offRealY))
            let velocity: Float = Float(self.size.width)
            let realMoveDuration: Double = Double(dis/velocity)
            
            projectile.run(SKAction.move(to: CGPoint(x: CGFloat(realX), y: CGFloat(realY)), duration: realMoveDuration)) {[weak projectile] in
                if let strongProjectile = projectile {
                    projectile?.removeFromParent()
                    self.projectiles.removeObject(strongProjectile)
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    

}

extension Array where Element: Equatable{
    mutating func removeObject(_ obj: Element) {
        if let index = firstIndex(of: obj) {
            self.remove(at: index)
        }
    }
}
