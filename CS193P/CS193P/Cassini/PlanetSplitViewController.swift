//
//  PlanetSplitViewController.swift
//  CS193P
//
//  Created by Carol on 2019/1/18.
//  Copyright © 2019年 Carol. All rights reserved.
//

import UIKit

class PlanetSplitViewController: UISplitViewController {
    lazy var navigationVC: UINavigationController! = {
        return UINavigationController(rootViewController: planetVC)
    }()
    
    var planetVC = CassiniViewController()
    var scrollVC = ScrollViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override var isCollapsed: Bool {
        return false
    }
    
    func initView(){
        self.viewControllers = [navigationVC, scrollVC]
        self.preferredDisplayMode = .allVisible
    }
    
    // MARK: - Navigation
    

}

extension PlanetSplitViewController: UISplitViewControllerDelegate {
    
}
