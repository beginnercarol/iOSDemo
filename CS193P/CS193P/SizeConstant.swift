//
//  SizeConstant.swift
//  CS193P
//
//  Created by Carol on 2019/1/12.
//  Copyright © 2019年 Carol. All rights reserved.
//

import Foundation
import UIKit

struct SizeConstant {
    static var statusBarSize: CGRect {
        return UIApplication.shared.statusBarFrame
    }
    static var tabBarSize: CGRect {
        return UITabBarController().tabBar.frame
    }
}

