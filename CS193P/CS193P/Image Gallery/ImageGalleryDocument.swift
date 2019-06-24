//
//  ImageGalleryDocument.swift
//  CS193P
//
//  Created by Carol on 2019/3/17.
//  Copyright © 2019年 Carol. All rights reserved.
//

import UIKit

class ImageGalleryDocument: UIDocument {
    var imageGallery: ImageGalleryDoc!
    
    //write
    override func contents(forType typeName: String) throws -> Any {
        return imageGallery.json
    }
    
    //read
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        if let data = contents as? Data {
            imageGallery = ImageGalleryDoc(json: data)
        }
    }
    
    
    
}
