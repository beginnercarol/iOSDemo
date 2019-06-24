//
//  Utility.swift
//  DailyTasks
//
//  Created by Carol on 2019/5/28.
//  Copyright © 2019 Carol. All rights reserved.
//

import Foundation
import UIKit

struct ThemeColor {
    var backgroundColor = UIColor.white
    var labelColor = UIColor.gray
}

class Utility {
    var viewRect: CGRect?
    var tabbarHeight: CGFloat = 0
    var topbarHeight: CGFloat = 0
    var viewWidth: CGFloat = 0
    var taskViewSize: CGSize = CGSize.zero
    static let taskPerRow: Int = 6
    
    static let colors: [UIColor] = [
        UIColor.red, UIColor.blue, UIColor.yellow,
        UIColor.gray, UIColor.purple, UIColor.orange
    ]
    
    static let TaskViewCellIdentifier: String = "taskView.cell"
    static let TaskViewHeaderKind: String = "taskView.header.kind"
    static let TaskViewHeaderIdentifier: String = "taskView.header"
    
    var theme = ThemeColor()
    
}
