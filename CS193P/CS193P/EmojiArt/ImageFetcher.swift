//
//  ImageFetcher.swift
//  CS193P
//
//  Created by Carol on 2019/1/20.
//  Copyright © 2019年 Carol. All rights reserved.
//

import Foundation
import UIKit

class ImageFetcher {
    var backup: UIImage! { didSet { callHandlerIfNeeded() }}
    var url: URL!
    var handler: (URL, UIImage) -> Void
    private var fetchFailed = false { didSet { callHandlerIfNeeded() } }
    
    func fetch(withURl url: URL) {
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    self?.handler(url, image)
                }
//                if self != nil {
//                    
//                }
            }
        }
    }
    
    func callHandlerIfNeeded() {
        if fetchFailed, let image = backup {
            handler(url, image)
        }
    }
    
    init(handler: @escaping (URL, UIImage) -> Void) {
        self.handler = handler
    }
    
    init(url: URL, handler: @escaping (URL, UIImage) -> Void) {
        self.handler = handler
        fetch(withURl: url)
    }
}
