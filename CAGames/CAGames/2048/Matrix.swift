//
//  Matrix.swift
//  CAGames
//
//  Created by Carol on 2019/4/26.
//  Copyright © 2019 Carol. All rights reserved.
//

import Foundation

typealias MatrixCoordination = (row: Int, col: Int)
let kNullMatrixCoordination = MatrixCoordination(row: -1, col: -1)

struct Matrix {
    private let dimension: Int
    private var elements: [Int]
    
    private var kZeroTileValue = 0
    
    init(dimension d: Int, initialValue: Int = 0) {
        dimension = d
        elements = [Int](repeating: initialValue, count: d*d)
        kZeroTileValue = initialValue
    }
    
    func getDimension() -> Int {
        return dimension
    }
    
    func asArray() -> [Int] {
        return elements
    }
    
    func printSelf() {
        for row in 0 ..< dimension {
            var temp: [Int] = []
            for col in 0 ..< dimension {
                temp.append(self[(row, col)])
            }
            print(temp)
        }
    }
    
    subscript(index: MatrixCoordination) -> Int {
        get {
            let (row, col) = index
            assert(row >= 0 && row < dimension)
            assert(col >= 0 && col < dimension)
            return elements[row*dimension + col]
        }
        set {
            let (row, col) = index
            assert(row >= 0 && row < dimension)
            assert(col >= 0 && col < dimension)
            elements[row*dimension + col] = newValue
        }
    }
    
    mutating func clearAll() {
        for index in 0 ..< (dimension*dimension) {
            elements[index] = kZeroTileValue
        }
    }
    
    mutating func insert(atPosition position: MatrixCoordination, with value: Int) {
        if isEmpty(atPosition: position) {
            self[position] = value
        }
    }
    
    func isEmpty(atPosition position: MatrixCoordination) -> Bool {
        return self[position] == kZeroTileValue
    }
    
    func getEmptyTiles() -> [MatrixCoordination] {
        var buffer = [MatrixCoordination]()
        for row in 0 ..< dimension {
            for col in 0 ..< dimension {
                let pos = MatrixCoordination(row: row, col: col)
                if isEmpty(atPosition: pos) {
                    buffer.append(pos)
                }
            }
        }
        return buffer
    }
    
    var max: Int {
        get {
            return elements.max()!
        }
    }
    
    var total: Int {
        return elements.reduce(0, { $0 + $1 })
    }
    
    
    
}
