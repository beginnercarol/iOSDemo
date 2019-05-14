//
//  Circle.swift
//  CAGames
//
//  Created by Carol on 2019/5/4.
//  Copyright © 2019 Carol. All rights reserved.
//

import Foundation
import UIKit

struct CACircle {
    var position: CGPoint
    var radius: Int
    var color: UIColor
    init(position: CGPoint, radius: Int, color: UIColor) {
        self.position = position
        self.radius = radius
        self.color = color
    }
}


