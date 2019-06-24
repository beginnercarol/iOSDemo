//
//  Utility.swift
//  CS193P
//
//  Created by Carol on 2019/3/11.
//  Copyright © 2019年 Carol. All rights reserved.
//

import UIKit

class Utility {
    struct Identifier {
        static let SideTableCellIdentifier = "sidetable.cell"
        static let SideTableHeaderViewIdentifier = "sidetable.header"
        static let SideTableInputCellIdentifier = "sidetable.input"
        static let CollectionViewCellIdentifier = "collectionView.cell"
        static let CollectionViewAddIdentifier = "collectionView.add.cell"
        static let CollectionViewInputIdentifier = "collectionView.input.cell"
    }
    static func attributedString(from string: String, size: CGFloat) -> NSAttributedString {
        let font = UIFont.preferredFont(forTextStyle: .body).withSize(size)
        let fontMetrix = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.font: fontMetrix, .paragraphStyle: paragraphStyle])
    }
    
    struct GraphicProcessLabel {
        static let RenderEncoderLabel = "MyFirstRenderEncoder"
    }
}


class ImageGalleryFetcher {
    var backupImage: UIImage! {didSet {callHandlerIfNeeded()}}
    var url: URL!
    var fetchFailed: Bool = false
    func fetch(withURL url: URL) {
        DispatchQueue.main.async {
            if let data = try? Data(contentsOf: url) {
                self.url = url
                if let img = UIImage(data: data) {
                    self.handler(url, img)
                }
            } else {
                self.fetchFailed = true
                print("Fetch Image Failed")
            }
        }
    }
    
    var handler: ((URL, UIImage) -> Void)!
    
    init(handler: @escaping (URL, UIImage) -> Void) {
        self.handler = handler
    }
    init(url: URL, handler: @escaping (URL, UIImage) -> Void) {
        self.handler = handler
        fetch(withURL: url)
    }
    
    func callHandlerIfNeeded() {
        if fetchFailed, let img = backupImage {
            handler(url, img)
        }
    }
}
