//
//  ArrayExtension.swift
//  PuyoSim
//
//  Created by roza on 2016/11/24.
//  Copyright © 2016年 roza All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    
    var distinct: [Element] {
        var a: [Element] = []
        self.forEach{
            if !a.contains($0) {
                a.append($0)
            }
        }
        return a
    }
}

extension Array {
    
    func distinct(isEquivalent: (Element, Element) -> Bool) -> [Element] {
        return self.reduce([]) { (a: [Element], e: Element) -> [Element] in
            a.filter{ isEquivalent($0, e) }.count > 0 ? a : a + [e]
        }
    }
}

extension Array {
    mutating func move(from: Int, to: Int) {
        let fromObject = self[from]
        
        self.remove(at: from)
        self.insert(fromObject, at: to)
    }
}

extension Sequence {
    func parallelForEach(_ action: @escaping (Self.Iterator.Element) -> ()) {
        let queue = DispatchQueue.global()
        let group = DispatchGroup()
        for e in self {
            queue.async(group: group) {
                action(e)
            }
        }
        group.wait()
    }
}
