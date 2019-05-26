//
//  FilterCollectionVC.swift
//  CAGames
//
//  Created by Carol on 2019/5/25.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class FilterCollectionVC: UICollectionViewController {
    var filters: [String] = ["CIVignetteEffect", "CIVignetteEffect",                            "CIVignetteEffect",
                             "CIVignetteEffect", "CIVignetteEffect", "CIVignetteEffect",
                             "CIVignetteEffect", "CIVignetteEffect", "CIVignetteEffect"
                            ]
    var context: EAGLContext!
    var inputImage: CIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    
    // MARK: - Navigation

 

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return filters.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FilterCollectionViewCell
    
        // Configure the cell
        cell.videoPreviewView.bindDrawable()
        cell.videoPreviewView.context = context
        if EAGLContext.current() != context {
            EAGLContext.setCurrent(context)
        }
    
        glClearColor(0.5, 0.5, 0.5, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        glEnable(GLenum(GL_BLEND))
        glBlendFunc(GLenum(GL_ONE), GLenum(GL_ONE_MINUS_SRC_ALPHA))
        
        if let inputImage = self.inputImage {
            let sourceExtent = self.inputImage?.extent
            if let outputImage = filterWithString(name: "CIVignetteEffect", withInputImg: inputImage) {
                let ciContext = CIContext(eaglContext: context, options: nil)
                ciContext.draw(outputImage, in: cell.bounds, from: outputImage.extent)
            }
            cell.videoPreviewView.display()
        }
        return cell
    }
    
    func filterWithString(name: String, withInputImg source: CIImage) -> CIImage? {
        let extent = source.extent
        if let filter = CIFilter(name: name) {
            filter.setValue(source, forKey: kCIInputImageKey)
            filter.setValue(CIVector(x: extent.size.width/2, y: extent.size.height/2), forKey: kCIInputCenterKey)
            filter.setValue(extent.size.width/2, forKey: kCIInputRadiusKey)
            
            return filter.outputImage
        }
        return nil
    }

   
}
