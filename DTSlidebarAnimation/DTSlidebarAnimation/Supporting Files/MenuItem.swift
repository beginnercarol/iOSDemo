//
//  MenuItem.swift
//  DTSlidebarAnimation
//
//  Created by Carol on 2019/6/10.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit

struct MenuItem: Decodable {
    var colorArray: [CGFloat]
    var imageName: String
}

extension MenuItem {
    var image: UIImage {
        return UIImage(imageLiteralResourceName: imageName)
    }
    
    var detailImage: UIImage {
        return UIImage(imageLiteralResourceName: "\(imageName)Big")
    }
    
    var color: UIColor {
        return UIColor(withArray: colorArray)
    }
}


