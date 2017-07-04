//
//  UIViewExtension.swift
//  PuyoSim
//
//  Created by roza on 2016/08/02.
//  Copyright © 2016年 roza All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    func addSubviews(subviews: [UIView]) {
        subviews.forEach{self.addSubview($0)}
    }
    
    func addSubviews(subviews: UIView...) {
        self.addSubviews(subviews: subviews)
    }
    
    func setCornerRadius(radius: CGFloat, corner: UIRectCorner) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corner,
                                    cornerRadii: CGSize.init(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
}
