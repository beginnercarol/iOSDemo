//
//  PlayingCard.swift
//  CAGames
//
//  Created by Carol on 2019/5/6.
//  Copyright © 2019 Carol. All rights reserved.
//

import Foundation

struct PlayingCard: Hashable {
    var isFaceUp: Bool = false
    var isMatched: Bool = false
    var identifier: Int
    
    static func ==(lhs: PlayingCard, rhs: PlayingCard) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var hashValue: Int {
        return self.identifier
    }
    
    static var identifierFactory: Int = 0
    
    static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = PlayingCard.getUniqueIdentifier()
    }
}
