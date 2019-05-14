//
//  LastCircleGameModel.swift
//  CAGames
//
//  Created by Carol on 2019/5/4.
//  Copyright © 2019 Carol. All rights reserved.
//

import Foundation
import UIKit

class LastCircleGameModel {
    var circles: [CACircle] = []
    var height: Int = 0
    var width: Int = 0
    let baseRadius: Int = 50
    
    
    
    init(height: Int, width: Int) {
        self.height = height
        self.width = width
    }
    
    func createNewCircle() -> CACircle {
        let x = Int(arc4random_uniform(UInt32(width)))
        let y = Int(arc4random_uniform(UInt32(height)))
        let radius = generateCircleRadius(x: x, y: y)
        let color = generateRandomColor()
        let circle = CACircle(position: CGPoint(x: x, y: y), radius: radius, color: color)
        
        if circles.count == 0 {
            circles = []
        }
        circles.append(circle)
        return circle
    }
    
    func generateCircleRadius(x: Int, y: Int) -> Int {
        let radius = min(x, y, width-x, height-y)
        if radius > width/2 || radius > height/2 {
            return 50+Int(arc4random_uniform(UInt32(50)))
        } else {
            return radius
        }
    }
    
    func checkForCollision(withCircle circle: CACircle) -> (isCollide: Bool, radius: Int?) {
        for cir in circles {
            let dis = cir.radius + circle.radius
            let trueDistance: Int = distanceBetweenTwoCircles(circle1: circle, circle2: cir)
            if trueDistance < Int(dis) {
                return (true, dis - trueDistance)
            }
        }
        return (false, nil)
    }
    
    func distanceBetweenTwoCircles(circle1: CACircle, circle2: CACircle) -> Int {
        return Int(sqrt(pow(circle2.position.y-circle1.position.y, 2)+pow(circle2.position.x-circle1.position.x, 2)))
    }
    
    func generateRandomColor() -> UIColor {
        let r = CGFloat(arc4random_uniform(UInt32(255)))/255
        let g = CGFloat(arc4random_uniform(UInt32(255)))/255
        let b = CGFloat(arc4random_uniform(UInt32(255)))/255
        return UIColor(displayP3Red: r, green: g, blue: b, alpha: 1.0)
    }
    
    func clearAll() {
        self.circles = []
    }
}

