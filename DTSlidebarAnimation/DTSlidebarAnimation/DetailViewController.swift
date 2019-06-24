//
//  DetailViewController.swift
//  DTSlidebarAnimation
//
//  Created by Carol on 2019/6/9.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit
class DetailViewController: UIViewController {
    var imageView: UIImageView = UIImageView(frame: .zero)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.center.equalTo(self.view.safeAreaLayoutGuide)
        }
        // Do any additional setup after loading the view.
    }
    
    func configureImageView(withMenuItem item: MenuItem) {
        view.backgroundColor = item.color
        imageView.image = item.detailImage
        imageView.sizeToFit()
    }
}
