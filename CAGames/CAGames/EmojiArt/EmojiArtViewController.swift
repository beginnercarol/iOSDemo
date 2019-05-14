//
//  EmojiArtViewController.swift
//  CAGames
//
//  Created by Carol on 2019/4/25.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit

class EmojiArtViewController: UIViewController {
    var sideTableViewController = EmojiArtSideTableViewController()
    var sideTableView: UITableView {
        return sideTableViewController.tableView
    }

    lazy var emojiCollectionView: EmojiCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return EmojiCollectionView(frame: self.view.frame, collectionViewLayout: layout)
    }()
    
    var emojiDrawView: UIView!
    
    lazy var emojiScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.emojiDrawView.bounds)
        scrollView.contentSize = self.emojiDrawView.bounds.size
        scrollView.zoomScale = 1.0
        return scrollView
    }()
    
    var emojis: [String] = "🍏🥐🍔🥩🥓🥞🦴🌭🥙🥫🍱🥗🍕🍖🥯🥥🥦⛳️🎽🎿⏳⌛️🕰🛢🐴🐌🕷🦖🙊".map { return String($0) }
    
    var documents: [String] = ["untitled1", "untitled2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        // Do any additional setup after loading the view.
    }
    
    func setupViews() {
        self.addChild(sideTableViewController)
        self.view.addSubview(sideTableView)
        self.sideTableView.translatesAutoresizingMaskIntoConstraints = false
        let hSideTableViewVFLString = "H:|-==0-[sideTableView(==sideTableWidth)]->=0-|"
        let vSideTableViewVFLString = "V:|[sideTableView]|"
        let hSideTableConstraints = NSLayoutConstraint.constraints(withVisualFormat: hSideTableViewVFLString, options: .alignAllBottom, metrics: ["sideTableWidth": self.sidetableWidth], views: ["sideTableView": self.sideTableView])
        let vSideTableConstraints = NSLayoutConstraint.constraints(withVisualFormat: vSideTableViewVFLString, options: .alignAllLeft, metrics: ["sideTableWidth": self.sidetableWidth], views: ["sideTableView": self.sideTableView])
        self.view.addConstraints(hSideTableConstraints)
        self.view.addConstraints(vSideTableConstraints)
        
//        self.emojiCollectionView = EmojiCollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.collectionViewHeight))
        self.view.addSubview(emojiCollectionView)
        emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        let hCollectionViewVFLString = "H:|-[sideTableView][emojiCollectionView]-|"
//        let vCollectionViewVFLString = "V:|[emojiCollectionView(==collectionViewHeight)]-|"
//        let hCollectionViewConstraints = NSLayoutConstraint.constraints(withVisualFormat: hCollectionViewVFLString, options: .alignAllBottom, metrics: nil, views: ["sideTableView": self.sideTableView, "emojiCollectionView": self.emojiCollectionView])
//        let vCollectionViewConstraints = NSLayoutConstraint.constraints(withVisualFormat: vCollectionViewVFLString, options: .alignAllLeft, metrics: ["collectionViewHeight": self.collectionViewHeight], views: ["sideTableView": self.sideTableView, "emojiCollectionView": self.emojiCollectionView])
//        self.view.addConstraints(hCollectionViewConstraints)
//        self.view.addConstraints(vCollectionViewConstraints)
//        self.view.addConstraint(NSLayoutConstraint(item: self.emojiCollectionView, attribute: .leading, relatedBy: .equal, toItem: self.sideTableView, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        self.emojiCollectionView.leadingAnchor.constraint(equalTo: self.sideTableView.trailingAnchor).isActive = true
        self.emojiCollectionView.heightAnchor.constraint(equalToConstant: self.collectionViewHeight).isActive = true
        self.emojiCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        // 是否一定要有 frame??? 不需要
        self.emojiDrawView = UIView()
        self.view.addSubview(self.emojiDrawView)
        self.emojiDrawView.translatesAutoresizingMaskIntoConstraints = false
        
        let hEmojiDrawViewVFLString = "H:|[sideTableView][emojiDrawView]|"
        let vEmojiDrawViewVFLString = "V:|[emojiCollectionView][emojiDrawView]|"
        let hEmojiDrawViewConstraints = NSLayoutConstraint.constraints(withVisualFormat: hEmojiDrawViewVFLString, options: .alignAllBottom, metrics: nil, views: ["sideTableView": self.sideTableView, "emojiDrawView": self.emojiDrawView])
        let vEmojiDrawViewConstraints = NSLayoutConstraint.constraints(withVisualFormat: vEmojiDrawViewVFLString, options: .alignAllLeft, metrics: nil, views: ["emojiDrawView": self.emojiDrawView, "emojiCollectionView": self.emojiCollectionView])
        self.view.addConstraints(hEmojiDrawViewConstraints)
        self.view.addConstraints(vEmojiDrawViewConstraints)
        
//        self.emojiScrollView = UIScrollView(frame: self.emojiDrawView.bounds)
        self.emojiDrawView.addSubview(self.emojiScrollView)
        let hScrollViewVFLString = "H:|[emojiScrollView]|"
        let vScrollViewVFLString = "V:|[emojiScrollView]|"
        let hScrollViewConstraints = NSLayoutConstraint.constraints(withVisualFormat: hScrollViewVFLString, options: .alignAllBottom, metrics: nil, views: ["emojiScrollView": self.emojiScrollView])
        let vScrollViewConstraints = NSLayoutConstraint.constraints(withVisualFormat: vScrollViewVFLString, options: .alignAllBottom, metrics: nil, views: ["emojiScrollView": self.emojiScrollView])
        self.emojiDrawView.addConstraints(hScrollViewConstraints)
        self.emojiDrawView.addConstraints(vScrollViewConstraints)
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

extension EmojiArtViewController {
    struct SizeRatio {
        static let sidetableWidthRatio: CGFloat = 0.32
        static let collectionHeightRatio: CGFloat = 0.25
    }
    
    private var sidetableWidth: CGFloat {
        return self.view.bounds.width * SizeRatio.sidetableWidthRatio
    }
    
    private var collectionViewHeight: CGFloat {
        return self.view.bounds.height * SizeRatio.collectionHeightRatio
    }
}
