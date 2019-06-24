//
//  ViewController.swift
//  DTSlidebarAnimation
//
//  Created by Carol on 2019/6/9.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit
import SnapKit
extension UIView {
    func embedInsideSafeArea(_ subview: UIView) {
        addSubview(subview)
        subview.snp.makeConstraints { (make) in
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing)
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
}

class ViewController: UIViewController {
    let menuWidth: CGFloat = 80.0
    lazy var threshold: CGFloat = menuWidth / 2
    lazy var scroller: UIScrollView = {
        let scroller = UIScrollView(frame: .zero)
        scroller.isPagingEnabled = true
        scroller.delaysContentTouches = false
        scroller.bounces = false
        scroller.showsHorizontalScrollIndicator = false
        scroller.delegate = self
        return scroller
    }()
    
    var scrollContentView: UIView!
    
    var detailViewController: DetailViewController?
    var menuViewController: MenuTableViewController?
    var menuViewContainer = UIView(frame: .zero)
    var detailViewContainer = UIView(frame: .zero)
    var hamView: Hamburger!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.embedInsideSafeArea(scroller)
        setupNavigationHamburger()
        scrollContentView = UIView(frame: CGRect(x: 0, y: 0, width: scrollerContentSize.width+menuWidth, height: scrollerContentSize.height))
        scroller.addSubview(scrollContentView)
        scroller.contentSize = scrollContentView.frame.size
        setupMenuContainer()
        setupDetailContainer()
        
        menuViewController = MenuTableViewController()
        detailViewController = DetailViewController()
        embedInNav(menuViewController!, into: menuViewContainer)
        embedInNav(detailViewController!, into: detailViewContainer)
        menuViewController?.delegate = self
    }
    
    func setupMenuContainer() {
        scrollContentView.addSubview(menuViewContainer)
        menuViewContainer.snp.makeConstraints { (make) in
            make.width.equalTo(menuWidth)
            make.top.equalTo(scrollContentView.snp.top)
            make.leading.equalTo(scrollContentView.snp.leading)
            make.bottom.equalTo(scrollContentView.snp.bottom)
        }
    }
    
    func setupDetailContainer() {
        scrollContentView.addSubview(detailViewContainer)
        detailViewContainer.snp.makeConstraints { (make) in
            make.top.equalTo(scrollContentView.snp.top)
            make.leading.equalTo(menuViewContainer.snp.trailing)
            make.bottom.equalTo(scrollContentView.snp.bottom)
            make.trailing.equalTo(scrollContentView.snp.trailing)
        }
//        detailViewContainer.backgroundColor = UIColor.red
    }
    
    func setupNavigationHamburger() {
        hamView = Hamburger(frame: CGRect(x: 20, y: 0, width: 20, height: 20))
        let button = UIBarButtonItem(customView: hamView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleMenu))
        tapGesture.numberOfTapsRequired = 1
        hamView.addGestureRecognizer(tapGesture)
//        button.target = self
//        button.action = #selector(toggleMenu)
        self.navigationItem.leftBarButtonItem = button
    }
    
    @objc func toggleMenu() {
        let isMenuHidden = scroller.contentOffset.x > threshold
        if isMenuHidden {
            moveMenu(position: 0)
        } else {
            moveMenu(position: menuWidth)
        }
        hamView.changeDirection()
    }
    
    func moveMenu(position: CGFloat) {
        scroller.setContentOffset(CGPoint(x: position, y: 0), animated: true)
    }

}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let fraction = calculateFraction()
        updateVisibility(menuViewContainer, fraction: fraction)
    }
    
    // 与 3D 相关的内容 here
    func calculateFraction() -> CGFloat {
        let fraction = scroller.contentOffset.x / menuWidth
        return Swift.min(Swift.max(0, fraction), 1.0)
    }
    
    func calculateTransform(withFraction fraction: CGFloat, withWidth width: CGFloat) -> CATransform3D {
        var identity = CATransform3DIdentity
        identity.m34 = -1.0 / 1000
        
        // 绕 y 轴旋转, menuContainer 原本与xoy平面平行, 最后将会旋转 直到与yoz平面重合, 因此是逆时针旋转
        let angle = -fraction * CGFloat.pi/2
        
//        let offsetX = width/2 + width * fraction
        let offsetX = width / 2 + width * fraction / 4 /// 2// why?
        // didScroll初始化时也会调用, 由于原来的 anchorPoint 是(0.5, 0.5) 现在是(1.0, 0.5) 需要向右移一半的 width 后半部分不是很明白

        
        let angleTransform = CATransform3DRotate(identity, angle, 0, 1.0, 0)
        let translateTransform = CATransform3DMakeTranslation(offsetX, 0, 0)
        return CATransform3DConcat(angleTransform, translateTransform)
    }
    
    func updateVisibility(_ container: UIView, fraction: CGFloat) {
        container.layer.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        container.layer.transform = calculateTransform(withFraction: fraction, withWidth: menuWidth)
        container.alpha = 1.0 - fraction
    }
    
}

extension ViewController: MenuDelegate {
    func didSelectMenuItem(_ item: MenuItem) {
        detailViewController?.configureImageView(withMenuItem: item)
    }
}

extension ViewController {
    func embedInNav(_ vc: UIViewController, into container: UIView) {
//        let nav = UINavigationController(rootViewController: vc)
//        let nav = installNavigationController(vc)
        self.addChild(vc)
        container.embedInsideSafeArea(vc.view)
    }
    
    func installNavigationController(_ rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.navigationBar.barTintColor = UIColor.black
        nav.navigationBar.tintColor = UIColor.green
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.clipsToBounds = true
        addChild(nav)
        return nav
    }
    
    // 注意 在 viewdidload 中 是无法获取到 safeAreaInsets 的
    var scrollerContentSize: CGSize {
        let top = self.navigationController?.navigationBar.frame.height ?? 0
        let bottom = self.tabBarController?.tabBar.frame.height ?? 0
        let width = view.frame.width
        let height = view.frame.height
        return CGSize(width: width, height: height - top - bottom)
    }
}

