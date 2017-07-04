//
//  CGRectExtension.swift
//  PuyoSim
//
//  Created by roza on 2016/08/02.
//  Copyright © 2016年 roza All rights reserved.
//

import Foundation
import UIKit

extension CGRect {
    
    // Properties
    var x: CGFloat {
        return self.origin.x
    }
    
    var y: CGFloat {
        return self.origin.y
    }
    
    var right: CGFloat {
        return self.maxX
    }
    
    var bottom: CGFloat {
        return self.maxY
    }
    
    var centerX: CGFloat {
        return self.x + self.width / 2
    }
    
    var centerY: CGFloat {
        return self.y + self.height / 2
    }
    
    var center: CGPoint {
        return CGPoint(x: self.centerX, y: self.centerY)
    }
    
    
    // SetX
    func setX(_ x: CGFloat) -> CGRect {
        return CGRect(x: x, y: self.origin.y, width: self.width, height: self.height)
    }
    
    func setX(_ x: Double) -> CGRect {
        return self.setX(CGFloat(x))
    }
    
    func setX(_ x: Int) -> CGRect {
        return self.setX(CGFloat(x))
    }
    
    
    // SetY
    func setY(_ y: CGFloat) -> CGRect {
        return CGRect(x: self.origin.x, y: y, width: self.width, height: self.height)
    }
    
    func setY(_ y: Double) -> CGRect {
        return self.setY(CGFloat(y))
    }
    
    func setY(_ y: Int) -> CGRect {
        return self.setY(CGFloat(y))
    }
    
    // SetWidth
    func setWidth(_ width: CGFloat) -> CGRect {
        return CGRect(x: self.origin.x, y: self.origin.y, width: width, height: self.height)
    }
    
    func setWidth(_ width: Double) -> CGRect {
        return self.setWidth(CGFloat(width))
    }

    func setWidth(_ width: Int) -> CGRect {
        return self.setWidth(CGFloat(width))
    }
    
    //SetHeight
    func setHeight(_ height: CGFloat) -> CGRect {
        return CGRect(x: self.origin.x, y: self.origin.y, width: self.width, height: height)
    }
    
    func setHeight(_ height: Double) -> CGRect {
        return self.setHeight(CGFloat(height))
    }
    
    func setHeight(_ height: Int) -> CGRect {
        return self.setHeight(CGFloat(height))
    }

    
    //SetCenter
    func setCenterX(_ x: CGFloat) -> CGRect {
        return self.addX(x - self.centerX)
    }
    
    func setCenterX(_ x: Double) -> CGRect {
        return self.setCenterX(CGFloat(x))
    }
    
    func setCenterY(_ y: CGFloat) -> CGRect {
        return self.addY(y - self.centerY)
    }
    
    func setCenterY(_ y: Double) -> CGRect {
        return self.setCenterY(CGFloat(y))
    }
    
    func setCenter(_ center: CGPoint) -> CGRect {
        return self.setCenterX(center.x).setCenterY(center.y)
    }

    
    //SetBottom
    func setBottom(_ y:CGFloat) -> CGRect {
        return self.addY(y - self.bottom)
    }
    
    func setBottom(_ y: Double) -> CGRect {
        return self.setBottom(CGFloat(y))
    }
    
    
    // Add
    func addX(_ e: CGFloat) -> CGRect {
        return CGRect(x: self.origin.x + e, y: self.origin.y, width: self.width, height: self.height)
    }
    
    func addX(_ e: Double) -> CGRect {
        return self.addX(CGFloat(e))
    }
    
    func addX(_ e: Int) -> CGRect {
        return self.addX(CGFloat(e))
    }
    
    func addY(_ e: CGFloat) -> CGRect {
        return CGRect(x: self.origin.x, y: self.origin.y + e, width: self.width, height: self.height)
    }

    func addY(_ e: Double) -> CGRect {
        return self.addY(CGFloat(e))
    }
    
    func addY(_ e: Int) -> CGRect {
        return self.addY(CGFloat(e))
    }
    
    func addWidth(_ e: CGFloat) -> CGRect {
        return CGRect(x: self.origin.x, y: self.origin.y, width: self.width + e, height: self.height)
    }
    
    func addWidth(_ e: Double) -> CGRect {
        return self.addWidth(CGFloat(e))
    }
    
    func addWidth(_ e: Int) -> CGRect {
        return self.addWidth(CGFloat(e))
    }

    func addHeight(_ e: CGFloat) -> CGRect {
        return CGRect(x: self.origin.x, y: self.origin.y, width: self.width, height: self.height + e)
    }
    
    func addHeight(_ e: Double) -> CGRect {
        return self.addHeight(CGFloat(e))
    }
    
    func addHeight(_ e: Int) -> CGRect {
        return self.addHeight(CGFloat(e))
    }
    
}
