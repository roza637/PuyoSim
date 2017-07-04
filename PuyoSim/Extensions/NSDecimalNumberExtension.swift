//
//  NSDecimalNumberExtension.swift
//  PuyoSim
//
//  Created by roza on 2017/01/16.
//  Copyright © 2017年 roza All rights reserved.
//

import Foundation

extension NSDecimalNumber {
    
    var absoluteValue: NSDecimalNumber {
        guard self != NSDecimalNumber.notANumber else {
            return self
        }
        
        switch self.compare(NSDecimalNumber.zero) {
        case .orderedAscending:
            return self.multiplying(by: NSDecimalNumber(value: -1))
        default:
            return self
        }
    }
    
    var optional: NSDecimalNumber? {
        if self == NSDecimalNumber.notANumber {
            return nil
        }
        
        return self
    }
}

extension NSDecimalNumber {
    func roundedString(roundingMode: NumberFormatter.RoundingMode, scale: Int) -> String {
        let formatter = NumberFormatter()
        formatter.roundingMode = roundingMode
        formatter.minimumFractionDigits = scale
        formatter.maximumFractionDigits = scale
        return formatter.string(from: self) ?? ""
    }
}
