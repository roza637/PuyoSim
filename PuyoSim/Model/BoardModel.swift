//
//  BoardModel.swift
//  PuyoSim
//
//  Created by fxgmo on 2017/07/05.
//  Copyright © 2017年 roza. All rights reserved.
//

import Foundation

class BoardModel {
    var currentBoard = Board()
    var executedBoard: [Board] = []
}

class Board {
    var row: Int {
        return Defines.Numbers.row
    }
    
    var column: Int {
        return Defines.Numbers.column
    }
    
    lazy var board: [[Square]] = {
        return self.createBlankBoard()
    }()
    

    private func createBlankBoard() -> [[Square]] {
        var b = [[Square]]()
        for _ in 0 ..< self.row {
            var a = [Square]()
            b.append(a)
            for _ in 0 ..< self.column {
                a.append(Square())
            }
        }
        return b
    }
    
    func evaluate() {
        
    }
    
    var next: Board? {
        return nil
    }
}

class Square {
    var hasEvaluated: Bool = false
    var type: PuyoType = .blank
    var count: Int = 0
    var willVanish: Bool {
        return count >= 4
    }
    
    var top: Square?
    var left: Square?
    var right: Square?
    var bottom: Square?
    
    
    func evaluate(count: Int = 0) -> Int {
        guard type != .blank else {
            hasEvaluated = true
            return -1
        }
        
        guard !hasEvaluated else {
            return -1
        }
        
        if let top = top, self.type == top.type {
            self.count = top.evaluate(count: count + 1)
        }
        

        
        return count
    }
}

enum PuyoType {
    case blank
    case red
    case green
    case blue
    case yellow
    case purple
}
