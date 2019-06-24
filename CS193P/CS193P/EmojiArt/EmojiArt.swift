//
//  EmojiArt.swift
//  CS193P
//
//  Created by Carol on 2019/2/12.
//  Copyright © 2019年 Carol. All rights reserved.
//

import Foundation
import UIKit

struct EmojiArt: Codable {
    var url: URL
    var emojis = [EmojiInfo]()
    
    struct EmojiInfo: Codable {
        let x: Int
        let y: Int
        let text: String
        let size: Int
    }
    
    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(EmojiArt.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
    
    init(url: URL, emojis: [EmojiInfo]) {
        self.url = url
        self.emojis = emojis
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    
}

