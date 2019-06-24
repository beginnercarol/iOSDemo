//
//  EmojiArtDocument.swift
//  CS193P
//
//  Created by Carol on 2019/2/13.
//  Copyright © 2019年 Carol. All rights reserved.
//

import UIKit

class EmojiArtDocument: UIDocument {
    var emojiArt: EmojiArt?
    override func contents(forType typeName: String) throws -> Any {
        return emojiArt?.json ?? Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        if let json = contents as? Data {
            emojiArt = EmojiArt(json: json)
        }
    }
}
