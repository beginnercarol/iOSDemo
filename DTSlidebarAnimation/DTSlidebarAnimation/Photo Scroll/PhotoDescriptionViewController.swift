//
//  PhotoDescriptionViewController.swift
//  DTSlidebarAnimation
//
//  Created by Carol on 2019/6/18.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit

class PhotoDescriptionViewController: UIViewController {
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: self.view.bounds)
        scroll.contentSize = self.view.bounds.size
        scroll.delegate = self
        return scroll
    }()
    
    lazy var despView: UIView = {
        let view = UIView(frame: self.view.bounds)
        return view
    }()
    
    lazy var textLabel: UILabel = {
        return UILabel(frame: .zero)
    }()
    
    lazy var imageView: UIImageView! = {
        let imgView = UIImageView(frame: self.view.bounds)
        imgView.contentMode = .scaleAspectFit 
        return imgView
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField(frame: .zero)
        return textField
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        
        scrollView.addSubview(despView)
        scrollView.contentSize = despView.bounds.size
        despView.snp.makeConstraints { (make) in
            make.edges.equalTo(scrollView)
        }
        
        despView.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(self.despView.snp.leading)
            make.trailing.equalTo(self.despView.snp.trailing)
            make.height.equalTo(500)
        }
        
        despView.addSubview(textLabel)
        
        textLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.despView.snp.centerX)
            make.top.equalTo(imageView.snp.bottom).offset(30)
        }
        
        textLabel.text = "What name fits me best?"
        textLabel.sizeToFit()
        despView.addSubview(textField)
        
        textField.snp.makeConstraints { (make) in
            make.leading.equalTo(despView.snp.leading).offset(8)
            make.trailing.equalTo(despView.snp.trailing).offset(8)
            make.top.equalTo(textLabel.snp.bottom).offset(30)
            make.height.equalTo(30)
            
        }
        
        textField.layer.cornerRadius = 5
        textField.layer.borderWidth = 3
        textField.layer.borderColor = UIColor.gray.cgColor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func setupImage(withImage image: UIImage) {
        self.imageView.image = image
        self.scrollView.contentSize = self.despView.frame.size
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}


extension PhotoDescriptionViewController: UIScrollViewDelegate {
    
}
