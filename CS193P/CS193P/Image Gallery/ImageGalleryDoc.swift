//
//  ImageGalleryDoc.swift
//  CS193P
//
//  Created by Carol on 2019/3/17.
//  Copyright © 2019年 Carol. All rights reserved.
//

import Foundation
import UIKit

struct ImageGalleryLabel: Codable {
    var size: CGSize
    var center: CGPoint
    var text: String
    init?(withLabel label: UILabel) {
        if let attributedString = label.attributedText {
            self.center = label.center
            self.text = attributedString.string
            self.size = attributedString.size() //?
        } else {
            return nil
        }
    }
}

struct ImageGalleryDoc: Codable {
    var labels = [ImageGalleryLabel]()
    var url: URL
    
    init(withLabels labels: [ImageGalleryLabel], url: URL) {
        self.labels = labels
        self.url = url
    }
    
    init?(json: Data) {
        if let data = try? JSONDecoder().decode(ImageGalleryDoc.self, from: json) {
            self = data
        } else {
            return nil
        }
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
}
