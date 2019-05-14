//
//  GameModel.swift
//  CAGames
//
//  Created by Carol on 2019/4/27.
//  Copyright © 2019 Carol. All rights reserved.
//

import Foundation

let chanceToPlayFour: Double = 0.4

class GameModel {
    var matrix: Matrix
    
    var dimension: Int {
        return matrix.getDimension()
    }
    
    var historyMove: [MoveCommand] = []
    
    let winningThreshold: Int
    
    var score: Int {
        return matrix.total
    }
    

    init(dimension: Int = 4, initialValue: Int = 0, winningThreshold threshold: Int = 2048) {
        matrix = Matrix(dimension: dimension, initialValue: initialValue)
        winningThreshold = threshold
    }
    
    func insertTile(at position: MatrixCoordination, with value: Int) {
        matrix.insert(atPosition: position, with: value)
    }
    
    func insertTileRandomly(with value: Int) -> Int {
        var emptyTiles = matrix.getEmptyTiles()
        let randomIndex = Int(arc4random_uniform(UInt32(emptyTiles.count - 1)))
        let pos = emptyTiles[randomIndex]
        insertTile(at: pos, with: value)
        return randomIndex
    }
    
    func isUserWin() -> Bool {
        if matrix.max == winningThreshold {
            return true
        } else {
            return false
        }
    }
    
    func isUserLose() -> Bool {
        if matrix.getEmptyTiles().count == 0  && !isPotentialMoveAvailable(){
            return true
        } else {
            return false
        }
    }
    
    func isPotentialMoveAvailable() -> Bool {
        var result: Bool = false
        for row in 0 ..< dimension {
            for col in 0 ..< dimension {
                result = isTileMovable(at: MatrixCoordination(row: row, col: col)) || result
                if result {
                    break
                }
            }
        }
        return result
    }
    
    func isTileMovable(at position: MatrixCoordination) -> Bool {
        let (row, col) = position
        assert(row >= 0 && row < dimension)
        assert(col >= 0 && col < dimension)
        let top: MatrixCoordination? = (row>0) ? MatrixCoordination(row: row-1, col: col) : nil
        let right = (col<dimension-1) ?MatrixCoordination(row: row, col: col+1) : nil
        let bottom = (row<dimension-1) ? MatrixCoordination(row: row+1, col: col) : nil
        let left = (col<dimension-1) ? MatrixCoordination(row: row, col: col-1) : nil
        
        let index = coordinateToIndex(position)
        
        if isTwoTilesValueEqual(tile1: position, tile2: top) || isTwoTilesValueEqual(tile1: position, tile2: right) || isTwoTilesValueEqual(tile1: position, tile2: bottom) || isTwoTilesValueEqual(tile1: position, tile2: left) {
            return true
        } else {
            return false
        }
    }
    
    func isTwoTilesValueEqual(tile1 t1: MatrixCoordination?, tile2 t2: MatrixCoordination?) -> Bool {
        if t1==nil || t2==nil {
            return false
        } else {
            if matrix[t1!] == matrix[t2!] {
                return true
            } else {
                return false
            }
        }
        
    }
    
    func coordinateToIndex(_ coordinate: MatrixCoordination) -> Int {
        let (row, col) = coordinate
        return row * dimension + col
    }
    
    func getNeighbours(around pos: MatrixCoordination) -> [MatrixCoordination] {
        let (row, col) = pos
        var result = [MatrixCoordination]()
        if row-1 > 0 {
            result.append(MatrixCoordination(row: row-1, col: col))
        }
        if row+1 < dimension {
            result.append(MatrixCoordination(row: row+1, col: col))
        }
        if col-1 > 0 {
            result.append(MatrixCoordination(row: row, col: col-1))
        }
        if col+1 < dimension {
            result.append(MatrixCoordination(row: row, col: col+1))
        }
        return result
    }

    func clearAll() {
        matrix.clearAll()
    }
    
    func getValueForInsert() -> Int {
        if uniformFromZeroToOne() > chanceToPlayFour {
            return 2
        } else {
            return 4
        }
    }
    
    func uniformFromZeroToOne() -> Double {
        return Double(arc4random()) / Double(UINT32_MAX)
    }
    
    func perform(move command: MoveCommand) -> [MoveAction] {
        var actions = [MoveAction]()
        var newMatrix = matrix
        newMatrix.clearAll()
        
        (0 ..< newMatrix.getDimension()).forEach { (index) in
            let tiles = command.getOneLine(forDimension: dimension, at: index)
            let tilesValue = tiles.map({ matrix[$0] })
            let movables = command.condense(line: command.getMovableTile(from: tilesValue))
            for move in movables {
                let target = command.getMatrixCoordination(withIndex: index, offset: move.target, dimension: dimension)
                newMatrix[target] = move.val
                if !move.needMove() {
                    continue
                }
                let src = command.getMatrixCoordination(withIndex: index, offset: move.src, dimension: dimension)
                let action = MoveAction(src: src, target: target, val: -1)
                actions.append(action)
                // 移动的同时还合并了
                if move.src2 >= 0 {
                    let src2 = command.getMatrixCoordination(withIndex: index, offset: move.src2, dimension: dimension)
                    actions.append(MoveAction(src: src2, target: target, val: -1))
                    actions.append(MoveAction(src: kNullMatrixCoordination, target: target, val: move.val))
                }
            }
        }
        self.matrix = newMatrix
        newMatrix.printSelf()
        return actions
    }
    
}


