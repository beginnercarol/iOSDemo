//
//  CategoryLabelView.swift
//  DailyTasks
//
//  Created by Carol on 2019/5/29.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit

class CategoryLabelView: UILabel {
    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.width * 0.3
//        self.clipsToBounds = true
        self.layer.backgroundColor = utility.theme.labelColor.cgColor
    }
}
