//
//  CassiniViewController.swift
//  CS193P
//
//  Created by Carol on 2019/1/18.
//  Copyright © 2019年 Carol. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController {
    lazy var btnStack: UIStackView! = {
        let stack = UIStackView()
        
        stack.alignment = .center
        stack.axis = .vertical
        stack.distribution = .equalCentering
        view.addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: vertivalConstant).isActive = true
        stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: horizontalConstant).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalConstant).isActive = true
        stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -vertivalConstant).isActive = true
        return stack
    }()
    
    var lightBtn: UIButton! {
        didSet {
            lightBtn.setTitle("Light", for: UIControl.State.normal)
            lightBtn.sizeToFit()
            btnStack.addArrangedSubview(lightBtn)
        }
    }
    
    var earthBtn: UIButton! {
        didSet {
            earthBtn.setTitle("Earth", for: .normal)
            earthBtn.sizeToFit()
            btnStack.addArrangedSubview(earthBtn)
        }
    }
    
    var moonBtn: UIButton! {
        didSet {
            moonBtn.setTitle("Moon", for: .normal)
            moonBtn.sizeToFit()
            btnStack.addArrangedSubview(moonBtn)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    func initView() {
        lightBtn = UIButton(type: .system)
        lightBtn.addTarget(self, action: #selector(chooseDetailView(_:)), for: .touchUpInside)
        moonBtn = UIButton(type: .system)
        moonBtn.addTarget(self, action: #selector(chooseDetailView(_:)), for: .touchUpInside)
        earthBtn = UIButton(type: .system)
        earthBtn.addTarget(self, action: #selector(chooseDetailView(_:)), for: .touchUpInside)
    }
    
    @objc func chooseDetailView(_ sender: UIButton) {
        if let currentTitle = sender.currentTitle {
            if let url = DemoURL.LIFE[currentTitle] {
                var parentVC: PlanetSplitViewController!
                var currentVC: UIResponder! = self
                while currentVC.next != nil {
                    if let vc = currentVC.next as? PlanetSplitViewController {
                        parentVC = vc
                        break
                    }
                    currentVC = currentVC.next!
                }
                let imgVC = parentVC.scrollVC
                imgVC.imgURL = url
                parentVC.showDetailViewController(parentVC.scrollVC, sender: self)
            }
        }
    }
}

extension CassiniViewController {
    private struct SizeRatio {
        static let verticalInsetToHeihgt: CGFloat = 0.15
        static let horizontalInsetToWidth: CGFloat = 0.10
    }
    
    private var vertivalConstant: CGFloat {
        return view.frame.height * SizeRatio.verticalInsetToHeihgt
    }
    
    private var horizontalConstant: CGFloat {
        return view.frame.width * SizeRatio.horizontalInsetToWidth
    }
}
