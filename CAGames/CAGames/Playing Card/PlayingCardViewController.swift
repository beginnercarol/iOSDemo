//
//  PlayingCardViewController.swift
//  CAGames
//
//  Created by Carol on 2019/5/6.
//  Copyright © 2019 Carol. All rights reserved.
//

import UIKit
import SnapKit

class PlayingCardViewController: UIViewController {
    var cardDeckCollectionView: UICollectionView!
    let pairsOfCards: Int = 8
    let gameModel = PlayingCardGameModel()
    
    var emojiDic: [PlayingCard: String] = [:]
    
    var emojisSet: [String] = "🍏🥐🍔🥩🥓🥞🦴🌭🥙🥫🍱🥗🍕🍖🥯🥥🥦⛳️🎽🎿⏳⌛️🕰🛢🐴🐌🕷🦖🙊".map({ return String($0)})
    
    private var cardSet: [String] {
        get {
            return emojisSet.map({ return String($0)})
        }
        set {
            self.cardSet = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        let width = (self.view.frame.width - 120) / CGFloat(4)
        layout.itemSize = CGSize(width: width, height: 80)
        cardDeckCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        cardDeckCollectionView.register(PlayingCardView.self, forCellWithReuseIdentifier: "cell")
        self.view.addSubview(cardDeckCollectionView)
        cardDeckCollectionView.delegate = self
        cardDeckCollectionView.dataSource = self
    }
    
    func generateEmoji(withCard card: PlayingCard) -> String {
        if emojiDic[card] == nil, emojisSet.count > 0 {
            let emoji = emojisSet.remove(at: emojisSet.count.arc4random)
            emojiDic[card] = emoji
        }
        return emojiDic[card] ?? "?"
    }
    
    func updateViewFromModel() {
        let cards = gameModel.cards
        for index in cards.indices {
            let cell = cardDeckCollectionView.cellForItem(at: IndexPath(row: index, section: 0)) as! PlayingCardView
            if cards[index].isFaceUp {
                flipCardUp(withCell: cell)
                cell.text = generateEmoji(withCard: cards[index])
                cell.backgroundColor = UIColor.white
            } else {
                if cards[index].isMatched {
                    cell.isUserInteractionEnabled = false
                }
                flipCardDown(withCell: cell, isMatched: cards[index].isMatched)
                cell.text = ""
                cell.backgroundColor = cards[index].isMatched ? UIColor.clear : UIColor.orange
            }
        }
    }
    
    func flipCardDown(withCell cell: UIView, isMatched match: Bool = false) {
        var stepOneFlip = CATransform3DIdentity
        stepOneFlip.m34 = -1.0/400
        stepOneFlip = CATransform3DRotate(stepOneFlip, CGFloat(Double.pi/2), 0, 1, 0)
        var stepTwoFlip = CATransform3DIdentity
        stepTwoFlip.m34 = -1.0/400
        stepTwoFlip = CATransform3DRotate(stepTwoFlip, CGFloat(Double.pi/2), 0, 1, 0)
        UIView.animate(withDuration: 0.25, animations: {
            cell.layer.transform = stepOneFlip
        }) { (success) in
            cell.backgroundColor = match ? UIColor.clear : UIColor.orange
            UIView.animate(withDuration: 0.25, animations: {
                cell.layer.transform = stepOneFlip
            })
        }
    }
    
    func flipCardUp(withCell cell: UIView) {
        var stepOneFlip = CATransform3DIdentity
        stepOneFlip.m34 = -1.0/400
        stepOneFlip = CATransform3DRotate(stepOneFlip, CGFloat(Double.pi/2), 0, 1, 0)
        var stepTwoFlip = CATransform3DIdentity
        stepTwoFlip.m34 = -1.0/400
        stepTwoFlip = CATransform3DRotate(stepTwoFlip, CGFloat(Double.pi/2), 0, 1, 0)
        UIView.animate(withDuration: 0.25, animations: {
            cell.layer.transform = stepOneFlip
        }) { (success) in
            cell.backgroundColor = UIColor.white
            UIView.animate(withDuration: 0.25, animations: {
                cell.layer.transform = stepOneFlip
            })
        }
    }
    
}

extension PlayingCardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2 * pairsOfCards
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PlayingCardView
        return cell
    }
    
    
}

extension PlayingCardViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        gameModel.chooseCard(at: indexPath.row)
        updateViewFromModel()
    }
}


extension PlayingCardViewController {
    struct SizeRatio {
//        static let
    }
}


extension Int {
    var arc4random: Int {
        return Int(arc4random_uniform(UInt32(self)))
    }
}
