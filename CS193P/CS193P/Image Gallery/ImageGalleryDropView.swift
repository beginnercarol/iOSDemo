//
//  ImageGalleryDropView.swift
//  
//
//  Created by Carol on 2019/3/11.
//

import UIKit
import SnapKit

class ImageGalleryDropView: UIView {
    lazy var scrollView: UIScrollView! = {
        let scrollView = UIScrollView(frame: self.bounds)
        scrollView.contentSize = self.bounds.size
        scrollView.zoomScale = 1.0
        scrollView.contentMode = .center
        return scrollView
    }()
    
    struct ImageLabel {
        var position: CGPoint
        var content: NSAttributedString
    }
    
    
    var backgroundImage: UIImage? {
        set {
            backgroundImageView.image = newValue
            backgroundImageView.sizeToFit()
            let size = newValue?.size ?? CGSize.zero
            scrollView.contentSize = size
            if size.width>0, size.height>0 {
                let scale = min(self.frame.width/size.width, self.frame.height/size.height)
                let minZoom = scale > 1 ? 1: scale
                scrollView.minimumZoomScale = minZoom
                scrollView.zoomScale = minZoom
            }
        }
        get {
            return backgroundImageView.image
        }
    }
    
    private var backgroundImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleToFill
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(scrollView)
        self.backgroundColor = UIColor.white
        scrollView.addSubview(backgroundImageView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.leading.equalTo(self.snp.leading)
            make.trailing.equalTo(self.snp.trailing)
            make.bottom.equalTo(self.snp.bottom)
        }
        scrollView.addInteraction(UIDropInteraction(delegate: self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addLabel(withAttributedString nsstring: NSAttributedString, at centered: CGPoint) {
        let label = UILabel()
        label.attributedText = nsstring
        label.sizeToFit()
        label.center = centered
        scrollView.addSubview(label)
    }
    
}

extension ImageGalleryDropView: UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self) || session.canLoadObjects(ofClass: UIImage.self) || session.canLoadObjects(ofClass: NSAttributedString.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: NSAttributedString.self) { provider in
            let location = session.location(in: self.scrollView)
            for item in provider as? [NSAttributedString] ?? [] {
                self.addLabel(withAttributedString: item, at: location)
            }
        }
        session.loadObjects(ofClass: UIImage.self) { (providers) in
            if let img = providers.first as? UIImage {
                self.backgroundImage = img
                
            }
        }
    }
}
