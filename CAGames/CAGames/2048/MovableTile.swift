//
//  MovableTil.swift
//  CAGames
//
//  Created by Carol on 2019/4/28.
//  Copyright © 2019 Carol. All rights reserved.
//

struct MovableTile {
    var src: Int
    var val: Int
    var target: Int = -1
    
    // 若非负, 则说明 描述了合并过程; -1 代表只是移动
    var src2: Int = -1
    
    init(src: Int, val: Int, target: Int = -1, src2: Int = -1) {
        self.src = src
        self.val = val
        self.target = target
        self.src2 = src2
    }
    
    func needMove() -> Bool {
        return src != target || src2 >= 0
    }
}

struct MoveAction {
    var src: MatrixCoordination
    var target: MatrixCoordination
    var val: Int
}
