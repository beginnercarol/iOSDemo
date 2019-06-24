//
//  Utilities.swift
//  CS193P
//
//  Created by Carol on 2019/2/14.
//  Copyright © 2019年 Carol. All rights reserved.
//

import Foundation
import UIKit

extension CGPoint {
    func offset(by point: CGPoint) -> CGPoint {
        return CGPoint(x: x+point.x, y: y+point.y)
    }
}


extension Notification.Name {
    static let EmojiArtViewDidChange = Notification.Name("EmojiArtViewDidChange")
}

