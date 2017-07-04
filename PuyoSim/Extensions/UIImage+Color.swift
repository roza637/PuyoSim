//
//  UIImage+Color.swift
//  PuyoSim
//
//  Created by roza on 2017/05/31.
//  Copyright © 2017年 roza All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    var color: UIColor {
        return color()
    }
    
    func color(point: CGPoint = CGPoint.zero) -> UIColor {
        //ピクセルデータ取得してバイナリ化
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer = CFDataGetBytePtr(pixelData)
        
        //RGBおよびアルファ値を取得
        let pixelInfo = ((Int(self.size.width) * Int(point.y)) + Int(point.x)) * 4
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo + 1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo + 2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo + 3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
