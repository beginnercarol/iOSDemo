//
//  FlappyGameModel.swift
//  CAGames
//
//  Created by Carol on 2019/5/11.
//  Copyright © 2019 Carol. All rights reserved.
//

import Foundation



class FlappyGameModel: NSObject {
    var pipes: [FlappyPipe] = []
    var bird = FlappyBird()
    
    func isCollide(withPipe pipe: FlappyPipe) {
        return 
    }
}
