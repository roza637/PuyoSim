//
//  UIViewController+DialogPresentable.swift
//  PuyoSim
//
//  Created by roza on 2016/11/11.
//  Copyright © 2016年 roza All rights reserved.
//

import UIKit

fileprivate let backgroundAlpha: CGFloat = 0.6
fileprivate let duration: TimeInterval = 0.2

protocol DialogPresentable {
    var dialogView: UIView! {get}
    var backgroundView: UIView! {get}
    var presentingViewController: UIViewController? {get}
    
    func showDialog(animated: Bool)
    func showDialog()
    func hideDialog(animated: Bool, completion:(() -> ())?)
    func hideDialog(completion:(() -> ())?)
    
    static func getInstance() -> Self
}

extension DialogPresentable where Self: UIViewController {
    static var topViewController: UIViewController {
        var top = UIApplication.shared.keyWindow?.rootViewController
        while (top!.presentedViewController) != nil {
            top = top!.presentedViewController
        }
        return top!
    }
    
    static func showDialog(viewController: UIViewController? = nil, animated: Bool = true, initialize: ((Self) -> ())? = nil) {
        let dialog = Self.getInstance()
        dialog.view.backgroundColor = UIColor.clear // これを呼ばないとストーリーボードで定義したUIがまだ生成されていないため、下の設定部分で落ちる
        dialog.backgroundView.alpha = 0
        dialog.backgroundView.backgroundColor = UIColor.black
        dialog.dialogView.alpha = 0
        dialog.dialogView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        dialog.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        initialize?(dialog)
        if let viewController = viewController {
            viewController.present(dialog, animated: false) { dialog.showDialog(animated: animated) }
        } else {
            topViewController.present(dialog, animated: false) { dialog.showDialog(animated: animated) }
        }
    }
    
    func showDialog() {
        showDialog(animated: true)
    }
    
    func showDialog(animated: Bool) {
        UIView.animate(withDuration: animated ? duration : 0,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.backgroundView!.alpha = backgroundAlpha
                        self.dialogView.alpha = 1
                        self.dialogView.transform = CGAffineTransform.identity
                        self.view.layoutIfNeeded()
        })
    }
    
    func hideDialog(completion:(() -> ())? = nil) {
        hideDialog(animated: true, completion: completion)
    }
    
    func hideDialog(animated: Bool, completion:(() -> ())? = nil) {
        DispatchQueue.main.async {
            UIView.animate(
                withDuration: animated ? duration : 0,
                delay: 0,
                options: .curveEaseInOut,
                animations: {
                    self.backgroundView!.alpha = 0
                    self.dialogView.alpha = 0
                    self.view.layoutIfNeeded()
                },
                completion: { finished in
                    self.dismiss(animated: false) {
                        completion?()
                    }
                }
            )
        }
    }
}
