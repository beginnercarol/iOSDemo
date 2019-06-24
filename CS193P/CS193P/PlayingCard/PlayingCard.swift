//
//  PlayingCard.swift
//  CS193P
//
//  Created by Carol on 2019/1/9.
//  Copyright © 2019年 Carol. All rights reserved.
//

import Foundation
import UIKit

struct PlayingCard {
    enum CardSymbol: String {
        case spade = "♠️"
        case diamond = "💎"
        case heart = "♥️"
        
        static var allItems: [CardSymbol] {
            return [.spade, .diamond, .heart]
        }
    }
    
    enum CardRank: Int {
        case one = 1
        case two = 2
        case three = 3
        
        static var allItems: [CardRank] {
            return [.one, .two, .three]
        }
    }
    
    enum CardColor {
        case red
        case green
        case purple
        static var allItems: [CardColor] {
            return [.red, .green, .purple]
        }
    }
    
    enum CardShading: Int {
        case shading = 0
        case open
        case stripped
        static var allItems: [CardShading] {
            return [.shading, .open, .stripped]
        }
    }
    
    var symbol: CardSymbol!
    var rank: CardRank!
    var shading: CardShading!
    var color: CardColor!
    var isFaceUp = false
    
    init(symbol: CardSymbol, rank: CardRank, shading: CardShading, color: CardColor) {
        self.symbol = symbol
        self.rank = rank
        self.color = color
        self.shading = shading
    }
}


extension PlayingCard.CardColor {
    var value: UIColor {
        switch self {
        case .red: return UIColor.red
        case .green: return UIColor.green
        case .purple: return UIColor.purple
        }
    }
}
