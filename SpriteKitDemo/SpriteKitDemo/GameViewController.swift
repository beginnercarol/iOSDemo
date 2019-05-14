//
//  GameViewController.swift
//  SpriteKitDemo
//
//  Created by Carol on 2019/5/13.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var skView: SKView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        skView = SKView(frame: self.view.bounds)
        skView.showsFPS = true
        self.view = skView
        skView.showsNodeCount = true
        
        let scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = SKSceneScaleMode.aspectFill
        
        skView.presentScene(scene)
        
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
