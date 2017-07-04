//
//  UIButton+MultipleTouches.swift
//  PuyoSim
//
//  Created by roza on 2017/02/13.
//  Copyright © 2017年 roza All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    @IBInspectable var isExclusive: Bool {
        get {
            return self.isExclusiveTouch
        }
        set {
            self.isExclusiveTouch = newValue
        }
    }
}
