//
//  PlayingCardViewController.swift
//  CS193P
//
//  Created by Carol on 2019/1/9.
//  Copyright © 2019年 Carol. All rights reserved.
//

import UIKit

class PlayingCardViewController: UIViewController, UICollectionViewDataSource {
    private let gameDeck = PlayingCardDeck()
    private var cardSet = [PlayingCard]()
    private lazy var cardCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = interItemSpace
        layout.sectionInset = collectionViewInset
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth/SizeRatio.itemWidthToHeight)
        let tabBarVC = UITabBarController()
        return UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
    }()
    
    lazy var animator = UIDynamicAnimator(referenceView: view)
    
    lazy var gravityBehaviour: UIGravityBehavior = {
        let gravity = UIGravityBehavior()
        gravity.gravityDirection = CGVector(dx: 1.0, dy: 1.0)
        gravity.magnitude = 1.0
         
        animator.addBehavior(gravity)
        return gravity
    }()
    
    lazy var snapItemBehavior: UIDynamicItemBehavior = {
        let itemBehavior = UIDynamicItemBehavior()
        itemBehavior.elasticity = 1.0
        itemBehavior.resistance = 0
        return itemBehavior
    }()
    
    lazy private var cardBehavior = CardBehavior(in: animator)
    
    lazy var allCards: [PlayingCard] = {
        gameDeck.dealCard()!
    }()
    
    var currentCards: [PlayingCard]!
    
    private var stackView: UIStackView!
    private var moreCardButton: UIButton!
    private var setButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardCollectionView.dataSource = self
        cardCollectionView.delegate = self
        cardCollectionView.allowsMultipleSelection = true
        view.addSubview(cardCollectionView)
        currentCards = allCards
        cardCollectionView.register(CardCell.self, forCellWithReuseIdentifier: identifier)
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        print("\(String(describing: type(of: self)))")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    
    

    func initView(){
        cardCollectionView.translatesAutoresizingMaskIntoConstraints = false
        cardCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        cardCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        cardCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        cardCollectionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: SizeRatio.collectionViewToHeight).isActive = true
        stackView = UIStackView(frame: stackViewFrame)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: cardCollectionView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        moreCardButton = UIButton(type: .system)
        moreCardButton.setTitle("MoreCards", for: .normal)
        moreCardButton.addTarget(self, action: #selector(moreCards), for: .touchUpInside)
        moreCardButton.sizeToFit()
        stackView.addArrangedSubview(moreCardButton)
        setButton = UIButton(type: .system)
        setButton.setTitle("Set", for: .normal)
        setButton.addTarget(self, action: #selector(checkForSet), for: .touchUpInside)
        stackView.addArrangedSubview(setButton)
        setButton.sizeToFit()
    }
    
    // MARK: - button action
    @objc func moreCards() {
        if let moreCards = gameDeck.moreCards() {
            currentCards += moreCards
            allCards += moreCards
            resizeItemSize()
            cardCollectionView.reloadData()
        }
    }
    
    func resizeItemSize() {
        cardCollectionView.collectionViewLayout.invalidateLayout()
        for row in 0..<currentCards.count {
            if let cell = cardCollectionView.cellForItem(at: IndexPath(row: row, section: 0)) as? CardCell {
                let frameSize = cell.intrinsicContentSize
                let newWidth = frameSize.width * (1-SizeRatio.shrinkItemToWidth)
                let newItemSize = CGSize(width: newWidth, height: newWidth/SizeRatio.itemWidthToHeight)
                UIView.transition(with: cell, duration: 0.5, options: [.curveLinear], animations: { cell.frame.size = newItemSize }, completion: nil)
            }
        }
    }
    
    @objc func checkForSet() {
        if let selectedItem = cardCollectionView.indexPathsForSelectedItems, selectedItem.count==3 {
            var threeCards = [PlayingCard]()
            for indexPath in selectedItem {
                threeCards.append(allCards[indexPath.row])
            }
            if gameDeck.checkForSet(card: threeCards) {
                cardCollectionView.performBatchUpdates({ [weak cardCollectionView] in
                    cardCollectionView?.reloadData()
                    for indexPath in selectedItem {
                        let cell = cardCollectionView?.cellForItem(at: indexPath)
                        
                        cardCollectionView?.deselectItem(at: indexPath, animated: false)
                        cardCollectionView?.cellForItem(at: indexPath)?.alpha = 1.0
                        cardCollectionView?.deleteItems(at: [indexPath])
                    }
                }, completion: nil)
                cardCollectionView.reloadData()
                view.layoutIfNeeded()
            } else {
                for indexPath in selectedItem {
                    cardCollectionView.deselectItem(at: indexPath, animated: false)
                    cardCollectionView.cellForItem(at: indexPath)?.alpha = 1.0
                }
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CardCell
        cell.cardView.card = currentCards[indexPath.row]
        return cell
    }
    
}

extension PlayingCardViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? CardCell else {
            return
        }
        if indexPath.row >= currentCards.count-3 {
            snapItemBehavior.addItem(cell)
            let point = cell.frame.center
            let snapBehavior = UISnapBehavior(item: cell, snapTo: point)
            animator.addBehavior(snapBehavior)
            snapBehavior.action = {[unowned snapBehavior, weak self] in
                self?.animator.removeBehavior(snapBehavior)
            }
        }
        UIView.transition(with: cell.contentView, duration: 0.75, options: [.transitionFlipFromLeft], animations: {cell.cardView.card.isFaceUp = !cell.cardView.card.isFaceUp}, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CardCell
        
        if let selectedItems = collectionView.indexPathsForSelectedItems {
            if selectedItems.count>3 {
                for cellIndexPath in selectedItems {
                    collectionView.deselectItem(at: cellIndexPath, animated: true)
                    collectionView.cellForItem(at: cellIndexPath)?.alpha = 1.0
                }
            } else {
                UIView.transition(with: cell, duration: 0.5, options: .transitionFlipFromLeft, animations: { cell.alpha = 0.5 }, completion: nil)
            }
        }
    }
}

extension PlayingCardViewController {
    private struct SizeRatio {
        static let itemSapceToBoundsWidth: CGFloat = 0.085
        static let itemWidthToHeight:  CGFloat = 8/5
        static let itemWidthToBoundsWidth: CGFloat = 1/4
        static let interPatternToBounds: CGFloat = 0.033
        static let collectionViewToHeight: CGFloat = 0.80
        static let buttonViewToHeight: CGFloat = 0.20
        static let collectionViewInsetToBoundsHeight: CGFloat = 0.055
        static let collectionViewInsetToBoundsWidth: CGFloat = 0.033
        static let shrinkItemToWidth: CGFloat = 0.15
    }
    
    private var collectionViewFrame: CGRect {
        let statusBarHeight = SizeConstant.statusBarSize.height
        let tabBarHeight = SizeConstant.tabBarSize.height
        return CGRect(x: 0, y: statusBarHeight, width: view.frame.width, height: (view.frame.height-tabBarHeight-statusBarHeight)*SizeRatio.collectionViewToHeight)
    }
    
    private var stackViewFrame: CGRect {
        let statusBarHeight = SizeConstant.statusBarSize.height
        let tabBarHeight = SizeConstant.tabBarSize.height
        return CGRect(x: 0, y: statusBarHeight, width: view.frame.width, height: (view.frame.height-tabBarHeight-statusBarHeight)*(1-SizeRatio.collectionViewToHeight))
    }
    
    private var identifier: String {
        return "PlayingCard.game.cell"
    }
    
    private var interItemSpace: CGFloat {
        return view.bounds.width * SizeRatio.itemSapceToBoundsWidth
    }
    
    private var itemWidth: CGFloat {
        return view.bounds.width * SizeRatio.itemWidthToBoundsWidth
    }
    
    private var patternInterSpace: CGFloat {
        return SizeRatio.interPatternToBounds
    }
    
    private var collectionViewInset: UIEdgeInsets {
        let horizontalInset: CGFloat = view.bounds.width * SizeRatio.collectionViewInsetToBoundsWidth
        let verticalInset: CGFloat = view.bounds.height * SizeRatio.collectionViewInsetToBoundsHeight
        return UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }
}



extension CGRect {
    var center: CGPoint {
        return CGPoint(x: self.minX + self.width/2, y: self.minY + self.height/2)
    }
}

