//
//  MoveCommand.swift
//  CAGames
//
//  Created by Carol on 2019/4/27.
//  Copyright © 2019 Carol. All rights reserved.
//

import Foundation

class MoveCommand {
    func getOneLine(forDimension dimension: Int, at index: Int) -> [MatrixCoordination] {
        fatalError("Not Implemented")
    }
    
    func getMatrixCoordination(withIndex index: Int, offset: Int, dimension: Int) -> MatrixCoordination {
        fatalError("Not Implemented")
    }
    
    // 此处的 coordination 会与原本的 matrix 不一样
    func getMovableTile(from line: [Int]) -> [MovableTile] {
        var buffer = [MovableTile]()
        for (idx, val) in line.enumerated() {
            if val>0 {
                buffer.append(MovableTile(src: idx, val: val, target: buffer.count, src2: -1))
            }
        }
        return buffer
    }
    
    func condense(line: [MovableTile]) -> [MovableTile] {
        var result = [MovableTile]()
        var skip: Bool = false
        for (idx, tile) in line.enumerated() {
            if skip {
                //                result.append(line[idx])
                skip = false
                continue
            }
            if idx == line.count - 1 {
                var collapse = tile
                collapse.target = result.count
                result.append(collapse)
                break
            }
            let nextTile = line[idx+1]
            if tile.val == nextTile.val {
                skip = true
                result.append(MovableTile(src: tile.src, val: tile.val*2, target: result.count, src2: nextTile.src))
            } else {
                var collapse = tile
                collapse.target = result.count
                result.append(collapse)
            }
        }
        return result
    }
}

class UpMoveCommand: MoveCommand {
    override func getOneLine(forDimension dimension: Int, at index: Int) -> [MatrixCoordination] {
        return (0 ..< dimension).map({ MatrixCoordination(row: $0, col: index) })
    }
    
    override func getMatrixCoordination(withIndex index: Int, offset: Int, dimension: Int) -> MatrixCoordination {
        return MatrixCoordination(row: offset, col: index)
    }
}

class DownMoveCommand: MoveCommand {
    override func getOneLine(forDimension dimension: Int, at index: Int) -> [MatrixCoordination] {
        return (0 ..< dimension).map({ MatrixCoordination(row: $0, col: index) }).reversed()
    }
    
    override func getMatrixCoordination(withIndex index: Int, offset: Int, dimension: Int) -> MatrixCoordination {
        return MatrixCoordination(row: dimension-offset-1, col: index)
    }
}

class LeftMoveCommand: MoveCommand {
    override func getOneLine(forDimension dimension: Int, at index: Int) -> [MatrixCoordination] {
        return (0 ..< dimension).map({ MatrixCoordination(row: index, col: $0) })
    }
    
    override func getMatrixCoordination(withIndex index: Int, offset: Int, dimension: Int) -> MatrixCoordination {
        return MatrixCoordination(row: index, col: offset)
    }
}

class RightMoveCommand: MoveCommand {
    override func getOneLine(forDimension dimension: Int, at index: Int) -> [MatrixCoordination] {
        return (0 ..< dimension).map({ MatrixCoordination(row: index, col: $0) }).reversed()
    }
    
    override func getMatrixCoordination(withIndex index: Int, offset: Int, dimension: Int) -> MatrixCoordination {
        return MatrixCoordination(row: index, col: dimension-offset-1)
    }
}
