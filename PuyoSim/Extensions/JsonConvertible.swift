//
//  JsonConvertible.swift
//  PuyoSim
//
//  Created by roza on 2016/12/07.
//  Copyright © 2016年 roza All rights reserved.
//

import Foundation
import CoreGraphics

protocol JsonConvertible {
    var jsonObject: Any {get}
}

extension JsonConvertible {
    var jsonObject: Any {
        return self
    }
}

extension JsonConvertible {
    var jsonDictionary: [String: Any] {
        var dic = [String: Any]()
        Mirror(reflecting: self).children.forEach { property in
            let value = property.value as! JsonConvertible
            dic[property.label!] = value.jsonObject
        }
        return dic
    }
}

extension String: JsonConvertible {
}

extension Int: JsonConvertible {
}

extension Double: JsonConvertible {
}

extension Float: JsonConvertible {
}

extension Bool: JsonConvertible {
}

extension CGPoint: JsonConvertible {
    var jsonObject: Any {
        return ["x": self.x,
                "y": self.y]
    }
}

extension Array: JsonConvertible {
    var jsonObject: Any {
        return self.map({ element -> Any in
            let value = element as! JsonConvertible
            return value.jsonObject
        })
    }
}

extension Dictionary: JsonConvertible {
    var jsonObject: Any {
        var dic = [String : Any]()
        self.forEach({(key, value)  in
            let convertibleKey = key as! JsonConvertible
            let convertibleValue = value as! JsonConvertible
            dic[convertibleKey.jsonObject as! String] = convertibleValue.jsonObject
        })
        return dic
    }
}
