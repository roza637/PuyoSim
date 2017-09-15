//
//  UIColorExtension.swift
//  PuyoSim
//
//  Created by roza on 2016/08/02.
//  Copyright © 2016年 roza All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    convenience init(hex: Int, alpha: Double = 1.0) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(hex & 0x0000FF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }
    
    func image(size: CGSize = CGSize(width:1, height: 1)) -> UIImage {
        UIGraphicsBeginImageContext(size)
        
        let rect = CGRect(origin: CGPoint.zero, size: size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    func alphaColor(_ alpha: CGFloat) -> UIColor {
        let rgba = self.rgba
        return UIColor(red: rgba.red, green: rgba.green, blue: rgba.blue, alpha: alpha)
    }
    
    typealias RGBA = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)
    
    var rgba: RGBA {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
    //    https://www.w3.org/TR/2008/REC-WCAG20-20081211/#relativeluminancedef
    var relativeLuminance: CGFloat {
        let rgba = self.rgba
        func lumi(_ rgb: CGFloat) -> CGFloat {
            if rgb <= 0.03928 {
                return rgb / 12.92
            } else {
                return pow(((rgb + 0.055) / 1.055), 2.4)
            }
        }
        
        let r = lumi(rgba.red)
        let g = lumi(rgba.green)
        let b = lumi(rgba.blue)
        
        return 0.2126 * r + 0.7152 * g + 0.0722 * b
    }
    
    //    https://www.w3.org/TR/2008/REC-WCAG20-20081211/#contrast-ratiodef
    func contrastRatio(_ color: UIColor) -> CGFloat {
        let luminance1 = self.relativeLuminance
        let luminance2 = color.relativeLuminance
        if luminance1 > luminance2 {
            return (luminance1 + 0.05) / (luminance2 + 0.05)
        } else {
            return (luminance2 + 0.05) / (luminance1 + 0.05)
        }
    }
    
    var recommendedTextColor: UIColor {
        let darkContrastRatio = self.contrastRatio(UIColor.black)
        let lightContrastRatio = self.contrastRatio(UIColor.white)
        
        if darkContrastRatio > lightContrastRatio {
            return UIColor.black
        } else {
            return UIColor.white
        }
    }
}


extension UIView {
    var apparentBackgroundColor: UIColor? {
        if let bg = self.backgroundColor, bg.rgba.alpha > 0 {
            return self.backgroundColor
        } else {
            return superview?.apparentBackgroundColor
        }
    }
}
