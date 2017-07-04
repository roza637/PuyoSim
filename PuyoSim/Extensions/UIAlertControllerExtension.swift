//
//  UIAlertControllerExtension.swift
//  PuyoSim
//
//  Created by roza on 2016/10/17.
//  Copyright © 2016年 roza All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    static func showAlert(viewController: UIViewController, title: String?, message: String?, actions: [UIAlertAction]) {
        guard !(viewController is UIAlertController) else {
            return
        }
        
        let alert = self.init(title: title, message: message, preferredStyle: .alert)
        actions.forEach{ alert.addAction($0) }
        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    static func showAction(viewController: UIViewController, title: String?, message: String?, actions: [UIAlertAction]) {
        guard !(viewController is UIAlertController) else {
            return
        }
        
        let alert = self.init(title: title, message: message, preferredStyle: .actionSheet)
        actions.forEach{ alert.addAction($0) }
        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    static func showAlert(viewController: UIViewController, title: String?, message: String?, negative: String = "キャンセル", positive: String = "OK", onPositive: @escaping () -> (), onNegative: (() -> ())? = nil) {
        showAlert(viewController: viewController, title: title, message: message, actions: [
            UIAlertAction(title: negative, style: .cancel, handler: { _ in onNegative?() }),
            UIAlertAction(title: positive, style: .default, handler: { _ in onPositive() })
            ])
    }
    
    static func showAlert(viewController: UIViewController, title: String?, message: String?, done: String = "OK", onDone: (() -> ())? = nil) {
        showAlert(viewController: viewController, title: title, message: message, actions: [
            UIAlertAction(title: done, style: .default, handler: { _ in onDone?() })
            ])
    }
}
