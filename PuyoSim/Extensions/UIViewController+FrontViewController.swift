//
//  UIViewController+FrontViewController.swift
//  PuyoSim
//
//  Created by roza on 2016/10/28.
//  Copyright © 2016年 roza All rights reserved.
//

import UIKit

extension UIViewController {
    static func getFrontViewController() -> UIViewController {
        var topViewController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        while topViewController.presentedViewController != nil {
            topViewController = topViewController.presentedViewController!
        }
        
        return topViewController
    }
}
