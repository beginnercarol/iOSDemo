//
//  PlayingCardDeck.swift
//  CS193P
//
//  Created by Carol on 2019/1/9.
//  Copyright © 2019年 Carol. All rights reserved.
//

import Foundation

class PlayingCardDeck {
    private var cards = [PlayingCard]()
    
    func fetchCard(atIndex index: Int) -> PlayingCard? {
        if index < cards.count {
            return cards[index]
        } else {
            return nil
        }
    }
    
    func fetchRamdomCard() -> PlayingCard? {
        if cards.count > 0 {
            return cards.remove(at: cards.count.arc4random!)
        } else {
            return nil
        }
    }
    
    func dealCard() -> [PlayingCard]? {
        var dealCards = [PlayingCard]()
        for _ in 1...15 {
            if cards.count > 0 {
                dealCards.append(cards.remove(at: cards.count.arc4random!)
                )
            } else {
                return nil
            }
        }
        return dealCards
    }
    
    func moreCards() -> [PlayingCard]? {
        var moreCards = [PlayingCard]()
        for _ in 1...3 {
            if cards.count > 0 {
                moreCards.append(cards.remove(at: cards.count.arc4random!))
            } else {
                return nil
            }
        }
        return moreCards
    }
    
    init() {
        for symbol in PlayingCard.CardSymbol.allItems {
            for rank in PlayingCard.CardRank.allItems {
                for color in PlayingCard.CardColor.allItems {
                    for shading in PlayingCard.CardShading.allItems {
                        cards.append(PlayingCard(symbol: symbol, rank: rank, shading: shading, color: color))
                    }
                }
            }
        }
    }
    
    func checkForSet(card: [PlayingCard]) -> Bool {
        if card[0].symbol == card[1].symbol && card[1].symbol == card[2].symbol || card[0].color == card[1].color && card[1].color == card[2].color || card[0].shading == card[1].shading && card[1].shading == card[2].shading || card[0].rank == card[1].rank && card[1].rank == card[2].rank {
            return true
        } else {
            return checkAllInArray(withCards: card)
        }
    }
    
    func checkAllInArray(withCards cards: [PlayingCard]) -> Bool {
        var symbols = PlayingCard.CardSymbol.allItems
        var shadings = PlayingCard.CardShading.allItems
        var colors = PlayingCard.CardColor.allItems
        var ranks = PlayingCard.CardRank.allItems
        for card in cards {
            if symbols.count==0 || shadings.count==0 || colors.count==0 || ranks.count==0 {
                return true
            }
            if let index = symbols.firstIndex(of: card.symbol) {
                symbols.remove(at: index)
            }
            if let index = shadings.firstIndex(of: card.shading) {
                shadings.remove(at: index)
            }
            if let index = colors.firstIndex(of: card.color) {
                colors.remove(at: index)
            }
            if let index = ranks.firstIndex(of: card.rank) {
                ranks.remove(at: index)
            }
        }
        return false
    }
    
    
}

extension Int {
    var arc4random: Int? {
        if self > 0 {
           return Int(arc4random_uniform(UInt32(self)))
        } else {
            return nil
        }
        
    }
}
