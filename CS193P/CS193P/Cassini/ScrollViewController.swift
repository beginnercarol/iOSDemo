//
//  ScrollViewController.swift
//  CS193P
//
//  Created by Carol on 2019/1/16.
//  Copyright © 2019年 Carol. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController, UIScrollViewDelegate {
    var scrollView: UIScrollView! {
        didSet {
            view.addSubview(scrollView)
            scrollView.addSubview(imgView)
            scrollView.minimumZoomScale = 1/25
            scrollView.maximumZoomScale = 1.0
            scrollView.delegate = self
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        }
    }
    
    lazy var indicatorView: UIActivityIndicatorView! = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        indicator.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        indicator.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        indicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        indicator.style = .whiteLarge
        indicator.color = UIColor.blue
        return indicator
    }()
    
    lazy var imgView: UIImageView = {
        let imageView = UIImageView(frame: self.scrollView.frame)
        return imageView
    }()
    
    var imgURL: URL? {
        didSet {
            image = nil
            if view.window != nil { //表示 是否显示
                fetchImage()
            }
        }
    }
    
    private var image: UIImage? {
        set {
            imgView.image = newValue
            let size = newValue?.size ?? CGSize.zero
            imgView.contentMode = .scaleToFill
//            imgView.sizeToFit()
            imgView.frame = self.scrollView.frame
            scrollView?.contentSize = imgView.frame.size
            indicatorView.stopAnimating()
        }
        get {
            return imgView.image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView = UIScrollView(frame: view.frame)
        indicatorView.startAnimating()
        if imgURL == nil {
            imgURL = Bundle.main.url(forResource: "palace", withExtension: "jpg")
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if imgView.image == nil {
            fetchImage()
        }
    }
    
    private func fetchImage() {
        indicatorView.startAnimating()
        let session  = URLSession(configuration: .default)
        if let url = imgURL {
            let task = session.dataTask(with: url) { (data: Data?, response, error) in
                
                if let imgData = data, url == self.imgURL{
                    
                    DispatchQueue.main.async {
                        
                        self.image = UIImage(data: imgData)
                    }
                } else {
                    self.image = UIImage(data: try! Data(contentsOf: self.imgURL!))
                    print("URLRequest failed:\(response)")
                }
            }
            task.resume()

        }
    }
    
    // MARK: - UIScrollView Delegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgView
    }

}
