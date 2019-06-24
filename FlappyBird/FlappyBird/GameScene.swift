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
    
    var bird: SKSpriteNode!
    
    var birdSprite: [SKTexture] = []
    
    let birdAtlas = SKTextureAtlas(named: "player")
    
    var repeatedBird: SKAction!
    
    var pauseBtn: SKSpriteNode!
    var startBtn: SKSpriteNode!
    
    override init(size: CGSize) {
        super.init(size: size)
        createScene()
        self.createStartBtn()
    }

    
    func createScene() {
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = CollisionBitMask.groundCategory
        self.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        self.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        // 检测碰撞
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = SKColor(red: 80.0/255.0, green: 192.0/255.0, blue: 203.0/255.0, alpha: 1)
        
        for i in 0..<2 {
            let background = SKSpriteNode(imageNamed: "bg")
            background.anchorPoint = CGPoint(x: 0, y: 0)
            background.position = CGPoint(x: CGFloat(i) * self.frame.width, y: 0)
            background.name = NodeName.Background
            background.size =  self.frame.size
            self.addChild(background)
        }
        
        birdSprite.append(birdAtlas.textureNamed("bird1"))
        birdSprite.append(birdAtlas.textureNamed("bird2"))
        birdSprite.append(birdAtlas.textureNamed("bird3"))
        birdSprite.append(birdAtlas.textureNamed("bird4"))
        
        self.bird = createBird()
        self.addChild(self.bird)
        
        let animateBird = SKAction.animate(with: birdSprite, timePerFrame: 0.1)
        self.repeatedBird = SKAction.repeatForever(animateBird)
    }
   
    
    func createBird() -> SKSpriteNode {
        let bird = SKSpriteNode(texture: SKTextureAtlas(named: "player").textureNamed("bird1"))
        bird.size = CGSize(width: 50, height: 50)
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.width/2)
        bird.physicsBody?.linearDamping = 1.1
        bird.physicsBody?.restitution = 0
        
        // 碰撞 定义 与谁碰撞 与谁接触
        bird.physicsBody?.categoryBitMask = CollisionBitMask.birdCategory
        bird.physicsBody?.collisionBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.groundCategory
        bird.physicsBody?.contactTestBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.flowerCategory | CollisionBitMask.groundCategory
        
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody?.isDynamic = true
        return bird
    }
    
    
    func createPillarPair() -> SKNode {
        let pillarTop = SKSpriteNode(imageNamed: "pillar")
        pillarTop.name = NodeName.PillarTop
        
        pillarTop.physicsBody = SKPhysicsBody(rectangleOf: pillarTop.size)
        pillarTop.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
        pillarTop.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        pillarTop.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        pillarTop.physicsBody?.isDynamic = false
        pillarTop.physicsBody?.affectedByGravity = false
        
        let pillarBottom = SKSpriteNode(imageNamed: "pillar")
        pillarBottom.name = NodeName.PillarBottom
        
        pillarBottom.physicsBody = SKPhysicsBody(rectangleOf: pillarBottom.size)
        pillarBottom.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
        pillarBottom.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        pillarBottom.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        pillarBottom.physicsBody?.isDynamic = false
        pillarBottom.physicsBody?.affectedByGravity = false
        
        pillarTop.zRotation = CGFloat.pi
        
        pillarTop.size = CGSize(width: PillarWidth, height: self.frame.height)
        pillarBottom.size = CGSize(width: PillarWidth, height: self.frame.height)
        
        pillarTop.position = CGPoint(x: self.frame.width + 25, y: self.frame.height/2+randomBreakHeight)
        pillarBottom.position = CGPoint(x: self.frame.width + 25, y: self.frame.height/2-randomBreakHeight)
        let wallNode = SKNode()
        wallNode.addChild(pillarTop)
        wallNode.addChild(pillarBottom)
        wallNode.zPosition = 1
        let randomPosition = arc4random_uniform(UInt32(400))-200
        wallNode.position.y = wallNode.position.y + CGFloat(randomPosition)
        return wallNode
    }
    
    func createPillar() {
        let distance: CGFloat = DisBetweenPillars
        for i in 0...2 {
            let pillarTop = SKSpriteNode(imageNamed: "pillar")
            pillarTop.name = NodeName.PillarTop
            
            pillarTop.physicsBody = SKPhysicsBody(rectangleOf: pillarTop.size)
            pillarTop.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
            pillarTop.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
            pillarTop.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
            pillarTop.physicsBody?.isDynamic = false
            pillarTop.physicsBody?.affectedByGravity = false
            
            let pillarBottom = SKSpriteNode(imageNamed: "pillar")
            pillarBottom.name = NodeName.PillarBottom
            
            pillarBottom.physicsBody = SKPhysicsBody(rectangleOf: pillarBottom.size)
            pillarBottom.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
            pillarBottom.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
            pillarBottom.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
            pillarBottom.physicsBody?.isDynamic = false
            pillarBottom.physicsBody?.affectedByGravity = false
            
            pillarTop.zRotation = CGFloat.pi
            
            pillarTop.size = CGSize(width: PillarWidth, height: self.frame.height)
            pillarBottom.size = CGSize(width: PillarWidth, height: self.frame.height)
            pillarTop.anchorPoint = CGPoint(x: 1, y: 1)
            pillarTop.position = CGPoint(x: self.frame.width + CGFloat(i)*distance + CGFloat(i)*PillarWidth, y: self.frame.height)
            pillarBottom.anchorPoint = CGPoint(x: 0, y: 1)
            pillarBottom.position = CGPoint(x: self.frame.width + CGFloat(i)*distance + CGFloat(i)*PillarWidth, y: 0)
            self.addChild(pillarTop)
            self.addChild(pillarBottom)
        }
    }
   
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
//        createScene()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            if !isGameStarted {
                if let startBtn = self.childNode(withName: NodeName.StartButton) {
                    let frame = startBtn.frame
                    if frame.contains(location) {
                        isGameStarted = true
                        bird.physicsBody?.affectedByGravity = true
                        bird.run(repeatedBird)
                        createPillar()
                        bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                        bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
                    }
                    self.isPaused = false
                    startBtn.removeFromParent()
                    self.createPauseBtn()
                }
            } else {
                if !isDied {
                    let frame = pauseBtn.frame
                    if !isPaused { // not paused
                        bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 40))
                        
                        if frame.contains(location) {
                            pauseBtn.texture = SKTexture(imageNamed: "play")
                            isPaused = true
                        }
                    } else {
                        if frame.contains(location) {
                            pauseBtn.texture = SKTexture(imageNamed: "pause")
                            isPaused = false
                        }
                       
                    }

                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isGameStarted {
            if !isDied {
                enumerateChildNodes(withName: NodeName.Background) { (node, error) in
                    let bg = node as! SKSpriteNode
                    bg.position = CGPoint(x: bg.position.x - 2, y: 0)
                    if bg.position.x <= -bg.size.width {
                        bg.position = CGPoint(x: bg.position.x + bg.size.width*2, y: 0)
                    }
                }
                updatePillars()
            }
        }
    }
    
    func updatePillars() {
        let randHeight = self.randomHeight
        enumerateChildNodes(withName: NodeName.PillarTop) { (node, error) in

            if node.position.x > -self.OffsetOfPillar {
                node.position = CGPoint(x: node.position.x - 2, y: node.position.y)
            } else {
                node.position = CGPoint(x: self.frame.width, y: self.frame.height - randHeight)
            }
        }
        enumerateChildNodes(withName: NodeName.PillarBottom) { (node, error) in
            if node.position.x > -self.OffsetOfPillar {
                node.position = CGPoint(x: node.position.x - 2, y: node.position.y)
            } else {
                node.position = CGPoint(x: self.frame.width, y: self.frame.height - randHeight - self.randomBreakHeight)
            }
        }
    }
    
    // MARK: - SKPhysics
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == CollisionBitMask.birdCategory &&
            secondBody.categoryBitMask == CollisionBitMask.pillarCategory ||
            firstBody.categoryBitMask == CollisionBitMask.pillarCategory &&
            secondBody.categoryBitMask == CollisionBitMask.birdCategory ||
            firstBody.categoryBitMask == CollisionBitMask.groundCategory &&
            secondBody.categoryBitMask == CollisionBitMask.birdCategory ||
            firstBody.categoryBitMask == CollisionBitMask.birdCategory &&
            secondBody.categoryBitMask == CollisionBitMask.groundCategory {
            
            NSLog("A: \(firstBody.categoryBitMask) collide with B: \(secondBody.categoryBitMask)")
            if isDied == false {
                isDied = true
            }
        }
    }
}

extension GameScene {
    // MARK: -Size Related
    struct NodeName{
        static let PillarTop: String = "pillarTop"
        static let PillarBottom: String = "pillarBottom"
        static let Background: String = "background"
        static let StartButton: String = "startButton"
        static let PauseButton: String = "pauseButton"
    }
    
    
    
    private var DimensionOfBird: CGFloat {
        return 50
    }
    
    private var DisBetweenPillars: CGFloat {
        return 200
    }
    
    private var PillarWidth: CGFloat {
        return 54
    }
    
    private var OffsetOfPillar: CGFloat {
        return 3*(PillarWidth+DisBetweenPillars) - self.frame.width
    }
    
    private var randomHeight: CGFloat {
        let min = self.frame.height / 2 - 100
        let max = self.frame.height / 2 + 100
        return CGFloat(arc4random_uniform(UInt32(max-min))) + min
    }
    
    private var randomBreakHeight: CGFloat {
        let min = DimensionOfBird*2
        let max = 4 * DimensionOfBird
        return CGFloat(arc4random_uniform(UInt32(max-min)) + UInt32(min))
    }

}


