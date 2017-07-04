//
//  StringExtension.swift
//  PuyoSim
//
//  Created by roza on 2016/11/11.
//  Copyright © 2016年 roza All rights reserved.
//

import Foundation
import UIKit

extension String {
    var decimal: NSDecimalNumber {
        return NSDecimalNumber(string: self)
    }
}

extension String {
    
    var urlImage: UIImage? {
        if let url = URL(string: self) {
            do {
                return try UIImage(data: Data(contentsOf: url))
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
    
    var length: Int {
        return self.characters.count
    }
    
    func substring(to: Int) -> String {
        return self.substring(to: self.index(self.startIndex, offsetBy: to))
    }
    
    func substring(from: Int) -> String {
        return self.substring(from: self.index(self.startIndex, offsetBy: from))
    }

    func substring(from: Int, length: Int) -> String {
        let start = self.index(self.startIndex, offsetBy: from)
        let end = self.index(startIndex, offsetBy: length)
        
        return self.substring(with: start..<end)
    }

    var isDouble: Bool {
        let components = self.components(separatedBy: ".")
        return 1 < components.count
    }

    var secureString: String {
        var result = ""
        for _ in 0..<self.length {
            result = result.appending("*")
        }
        return result
    }
}

protocol StringOptionalExtensionProtocol {
    var value: String {get}
}

extension String: StringOptionalExtensionProtocol {
    var value: String {
        return self
    }
}

extension Optional where Wrapped: StringOptionalExtensionProtocol {
    var isNilOrEmpty: Bool {
        switch self {
        case .none:
            return true
        case let .some(value):
            return value.value.isEmpty
        }
    }
    
    var emptyAsNil: String? {
        return isNilOrEmpty ? nil : self?.value
    }
}
