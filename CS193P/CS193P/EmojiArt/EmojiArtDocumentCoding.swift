//
//  EmojiArtDocument.swift
//  CS193P
//
//  Created by Carol on 2019/2/8.
//  Copyright © 2019年 Carol. All rights reserved.
//

import Foundation
import UIKit

class EmojiArtDocumentCoding: NSObject, NSCoding {
    var name: String
    var createdDate: Date
    var detail: String?
    var content: UIImage
    init(name: String, createdDate: Date, content: UIImage, detail: String?) {
        self.name = name
        self.createdDate = createdDate
        self.content = content
        self.detail = detail
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "EmojiArtName")
        aCoder.encode(createdDate, forKey: "createdDate")
        aCoder.encode(detail, forKey: "detail")
        aCoder.encode(content, forKey: "content")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "EmojiArtName") as! String
        createdDate = aDecoder.decodeObject(forKey: "createdDate") as! Date
        content = aDecoder.decodeObject(forKey: "content") as! UIImage
        detail = aDecoder.decodeObject(forKey: "detail") as? String
        super.init()
    }
}
