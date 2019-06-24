//
//  UIColor+ArrayInitiation.swift
//  DTSlidebarAnimation
//
//  Created by Carol on 2019/6/10.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(withArray array: [CGFloat]) {
        var source = array
        if source.count != 3 {
            
        }
        let red = source[0]/255
        let green = source[1]/255
        let blue = source[2]/255
        self.init(displayP3Red: red, green: green, blue: blue, alpha: 1.0)
    }
}
