//
//  DTViewDelegate.swift
//  DailyTasks
//
//  Created by Carol on 2019/6/6.
//  Copyright © 2019 Carol. All rights reserved.
//

import Foundation
import UIKit

protocol DTViewDelegate {
    var infoTopView: UIView { get set }
    var contentView: UIView { get set }
}
