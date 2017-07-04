//
//  UIImageView+TemplateImage.swift
//  PuyoSim
//
//  Created by roza on 2017/05/22.
//  Copyright © 2017年 roza All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    @IBInspectable
    var templateImage: UIImage? {
        get {
            return self.image
        }
        set {
            self.image = newValue?.withRenderingMode(.alwaysTemplate)
        }
    }
}
