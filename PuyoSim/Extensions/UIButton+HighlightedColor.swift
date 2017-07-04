//
//  UIButton+HighlightedColor.swift
//  PuyoSim
//
//  Created by roza on 2017/05/26.
//  Copyright © 2017年 roza All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    @IBInspectable
    var hilightedColor: UIColor? {
        get {
            return self.backgroundImage(for: .highlighted)?.color
        }
        set {
            self.setBackgroundImage(newValue?.image(), for: .highlighted)
        }
    }
}
