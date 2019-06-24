//
//  DTViewController.swift
//  DTSlidebarAnimation
//
//  Created by Carol on 2019/6/9.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit

import SnapKit

class DTViewController: UIViewController {
    //
    //  DTViewController.swift
    //  DailyTasks
    //
    //  Created by Carol on 2019/6/6.
    //  Copyright © 2019 Carol. All rights reserved.
    //
    var infoTopView: UIView!
    var topStackView: UIStackView!
    var contentView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInfoTopView()
        setupContentView()
        // Do any additional setup after loading the view.
    }
    
    func setupInfoTopView() {
        infoTopView = UIView(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: self.view.frame.width, height: topViewHeight))
        self.view.addSubview(infoTopView)
        topStackView = UIStackView(frame: self.infoTopView.bounds)
        self.infoTopView.addSubview(topStackView)
        topStackView.axis = .horizontal
        topStackView.distribution = .equalCentering
        topStackView.alignment = .fill
        topStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 3, trailing: 0)
        topStackView.isLayoutMarginsRelativeArrangement = true
        infoTopView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
            make.top.equalTo(self.view.snp.top).offset(statusBarHeight)
            make.height.equalTo(topViewHeight)
        }
    }
    
    func setupContentView() {
        contentView = UIView(frame: self.view.bounds)
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
            make.top.equalTo(self.infoTopView.snp.bottom)
            make.height.equalTo(contentViewHeight)
        }
        contentView.backgroundColor = UIColor.white
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

extension DTViewController {
    var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
    
    var topViewHeight: CGFloat {
        let navigationVC = UINavigationController(rootViewController: self)
        let height = navigationVC.navigationBar.frame.height
        return height
    }
    
    var contentViewHeight: CGFloat {
        let tabbarVC = UITabBarController()
        tabbarVC.viewControllers = [self]
        let height = tabbarVC.tabBar.frame.height
        return  self.view.frame.height - statusBarHeight - topViewHeight - height
    }
}

