//
//  CameraFocusView.swift
//  CAGames
//
//  Created by Carol on 2019/5/24.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit

class CameraFocusView: UIView {

    override func layoutSubviews() {
        self.layer.cornerRadius = self.bounds.size.width * 0.1
        self.layer.borderColor = UIColor.blue.cgColor
        self.layer.borderWidth = 2
        self.backgroundColor = UIColor.clear
    }

}
