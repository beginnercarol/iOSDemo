//
//  FlappyBird.swift
//  CAGames
//
//  Created by Carol on 2019/5/11.
//  Copyright © 2019 Carol. All rights reserved.
//

import Foundation

import UIKit

struct FlappyPoint {
    var x: Int = 0
    var y: Int = 0
}

enum FBDirection: Int {
    case down = 0
    case up = 1
    case forward = 2
}

// 右侧中心
struct FlappyBird {
    var position: CGPoint = .zero
    static let width: Int = 30
    static let height: Int = 30
    var birdRect: CGRect = CGRect(origin: CGPoint.zero, size: CGSize(width: FlappyBird.width, height: FlappyBird.width))
    var direction: FBDirection = .down
    var acceleration: Double = 0.0
    
//    var
}
