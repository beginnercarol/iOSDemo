//
//  EmojiArtStore.swift
//  CS193P
//
//  Created by Carol on 2019/2/8.
//  Copyright © 2019年 Carol. All rights reserved.
//

import Foundation

class EmojiArtStore: NSObject {
    var allDocs = [EmojiArtDocument]()
    let docsArchiveURL: URL = {
        let docsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docsDirectory.appendingPathComponent("docs.archive")
    }()
    
//    func saveChanges() -> Bool {
//        return NSKeyedArchiver.archiveRootObject(<#T##rootObject: Any##Any#>, toFile: <#T##String#>)
//    }
//
//    override init() {
//        if let archivedDocs = NSKeyedUnarchiver.unarchiveObject(withFile: <#T##String#>) as? [EmojiArtDocument] {
//            allDocs = archivedDocs
//        }
//    }
}
