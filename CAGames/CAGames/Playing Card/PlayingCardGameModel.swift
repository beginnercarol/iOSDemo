//
//  PlayingCardGameModel.swift
//  CAGames
//
//  Created by Carol on 2019/5/6.
//  Copyright © 2019 Carol. All rights reserved.
//

import Foundation

class PlayingCardGameModel {
    var cards: [PlayingCard] = []
    var pairsOfCards: Int = 8
    
    
    
    // 产生乱序的 card 对, identifier
    func createAllCards() {
        cards.removeAll()
        var newCards = [PlayingCard]()
        for _ in 0 ..< pairsOfCards {
            let card = PlayingCard()
            newCards += [card, card]
        }
        
        while newCards.count > 0 {
            let index = Int(arc4random_uniform(UInt32(newCards.count-1)))
            cards.append(newCards.remove(at: index))
        }
    }
    
    // 返回任意的 card
    func dealCards() -> PlayingCard? {
        if cards.count > 0 {
            return cards.remove(at: Int(arc4random_uniform(UInt32(cards.count-1))))
        }
        return nil
    }
    
    init(withPairsOfCards pairs: Int = 8) {
        pairsOfCards = pairs
        createAllCards()
    }

    var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter({ return cards[$0].isFaceUp }).oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
 
    // 不关注视觉效果, 只关注 card state
    func chooseCard(at index: Int) {
        // 1. 有翻开的 card
        // 2. 目前没有翻开的 card
        if let matchCardIndex = indexOfOneAndOnlyFaceUpCard, matchCardIndex != index {
            if cards[matchCardIndex] == cards[index] {
                cards[matchCardIndex].isMatched = true
                cards[index].isMatched = true
            }
            cards[index].isFaceUp = true
        } else {
            for index in cards.indices {
                cards[index].isFaceUp = false
            }
            cards[index].isFaceUp = true
        }
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
