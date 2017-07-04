//
//  UIDevice+Platform.swift
//  PuyoSim
//
//  Created by roza on 2017/01/05.
//  Copyright © 2017年 roza All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    var platform: String {
        get {
            let name = "hw.machine"
            let cName = (name as NSString).utf8String
            
            var size: Int = 0
            sysctlbyname(cName, nil, &size, nil, 0)
            
            var machine = [CChar](repeating: 0, count: size / MemoryLayout<CChar>.size)
            sysctlbyname(cName, &machine, &size, nil, 0)
            
            let platform = NSString(bytes: machine, length: size, encoding: String.Encoding.utf8.rawValue) as! String
            return platform.replacingOccurrences(of: "\0", with: "")
        }
    }
}
