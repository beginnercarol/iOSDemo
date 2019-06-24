//
//  PhotoDetailViewController.swift
//  DTSlidebarAnimation
//
//  Created by Carol on 2019/6/15.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: self.view.bounds)
        scroll.contentSize = self.view.bounds.size
        scroll.delegate = self
        return scroll
    }()
    
    lazy var imageView: UIImageView = {
        let imgView = UIImageView(frame: self.view.bounds)
        return imgView
    }()
    
    var imageViewTopConstraint: NSLayoutConstraint?
    var imageViewBottomConstraint: NSLayoutConstraint?
    var imageViewLeadingConstraint: NSLayoutConstraint?
    var imageViewTrailingConstraint: NSLayoutConstraint?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        NSLog("NibName???",#function)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageViewTopConstraint = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1.0, constant: 0)
        imageViewBottomConstraint = NSLayoutConstraint(item: imageView, attribute: .bottom, relatedBy: .equal, toItem: scrollView, attribute: .bottom, multiplier: 1.0, constant: 0)
        imageViewLeadingConstraint = NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1.0, constant: 0)
        imageViewTrailingConstraint = NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: scrollView, attribute: .trailing, multiplier: 1.0, constant: 0)

        imageViewTopConstraint?.isActive = true
        imageViewBottomConstraint?.isActive = true
        imageViewLeadingConstraint?.isActive = true
        imageViewTrailingConstraint?.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("viewDidLoad", #function)
        self.view.addSubview(scrollView)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.updateMinZoomScale(view.bounds.size)
    }
    
    func setupImage(withImage image: UIImage) {
        self.imageView.image = image
        self.imageView.sizeToFit()
        self.scrollView.contentSize = self.imageView.frame.size
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func updateMinZoomScale(_ size: CGSize) {
        let widthScale = size.width / imageView.frame.width
        let heightScale = size.height / imageView.frame.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }

}

extension PhotoDetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(view.frame.size)
    }
    
    fileprivate func updateConstraintsForSize(_ size: CGSize) {
        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        imageViewTopConstraint?.constant = yOffset
        imageViewBottomConstraint?.constant = yOffset
        imageViewLeadingConstraint?.constant = xOffset
        imageViewTrailingConstraint?.constant = xOffset
//        imageView.snp.makeConstraints { (make) in
//            make.top.equalTo(scrollView.snp.top).offset(yOffset)
//            make.bottom.equalTo(scrollView.snp.bottom).offset(yOffset)
//        }
//        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
//        imageView.snp.makeConstraints { (make) in
//            make.leading.equalTo(scrollView.snp.leading).offset(xOffset)
//            make.trailing.equalTo(scrollView.snp.trailing).offset(xOffset)
//        }
//        view.layoutIfNeeded()
    }
}


