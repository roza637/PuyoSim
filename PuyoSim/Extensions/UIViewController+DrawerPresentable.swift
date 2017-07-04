//
//  UIViewController+DrawerPresentable.swift
//  PuyoSim
//
//  Created by roza on 2016/11/11.
//  Copyright © 2016年 roza All rights reserved.
//

import Foundation
import UIKit

protocol DrawerPresentable {
    var drawerView: UIView! {get}
    var backgroundView: UIView! {get}
    var drawerGravity: DrawerGravity {get}
    static func getInstance() -> Self
}

enum DrawerGravity {
    case left
    case right
}

fileprivate let backgroundAlpha: CGFloat = 0.6
fileprivate let duration: TimeInterval = 0.3

extension DrawerPresentable where Self: UIViewController {
    
    static func showDrawer() {
        let root = UIViewController.getFrontViewController()
        let dialog = Self.getInstance()
        
        dialog.view.backgroundColor = UIColor.clear  // これを先に呼ばないとストーリーボードで定義したUIがまだ生成されていないため、下の設定部分で落ちる
        dialog.backgroundView.alpha = 0
        dialog.backgroundView.backgroundColor = UIColor.black
        dialog.drawerView.frame = dialog.drawerView.frame.setX(dialog.hiddenX)
        dialog.drawerView.isHidden = true
        dialog.setGesture()
        
        
        dialog.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        if let tabBarController = root.tabBarController {
            tabBarController.present(dialog, animated: false) {
                dialog.drawerView.frame = dialog.drawerView.frame.setX(dialog.hiddenX)
                dialog.drawerView.isHidden = false
                dialog.showDrawer()
            }
        } else {
            root.present(dialog, animated: false) {
                dialog.drawerView.frame = dialog.drawerView.frame.setX(dialog.hiddenX)
                dialog.drawerView.isHidden = false
                dialog.showDrawer() }
        }
    }
    
    private func setGesture() {
        backgroundView.addTapGesture{ [weak self] _ in self?.hideDrawer() }
        drawerView.addPanGesture{ [weak self] sender in
            switch sender.state {
            case .possible:
                fallthrough
            case .began:
                fallthrough
            case .changed:
                let t = sender.translation(in: self?.drawerView)
                self?.moved(translation: t)
            default:
                let v = sender.velocity(in: self?.drawerView)
                self?.ended(velocity: v)
                break
            }
            sender.setTranslation(CGPoint.zero, in: self?.drawerView)
        }
        drawerView.addSwipeGesture{ [weak self] sender in
            switch self!.drawerGravity {
            case .left:
                if sender.direction == UISwipeGestureRecognizerDirection.left {
                    self?.hideDrawer()
                }
            case .right:
                if sender.direction == UISwipeGestureRecognizerDirection.left {
                    self?.hideDrawer()
                }
            }
        }
    }
    
    private func ended(velocity v: CGPoint) {
        switch drawerGravity {
        case .left:
            v.x >= 0 ? self.showDrawer() : self.hideDrawer()
        case .right:
            v.x <= 0 ? self.showDrawer() : self.hideDrawer()
        }
    }
    
    private func moved(translation: CGPoint) {
        let frame = drawerView.frame
        switch drawerGravity {
        case .left:
            if visibleX >= frame.addX(translation.x).x {
                drawerView.frame = self.drawerView.frame.addX(translation.x)
            }
            let ratio = drawerView.frame.right / drawerView.frame.width
            backgroundView.alpha = backgroundAlpha * ratio
        case .right:
            if visibleX <= frame.addX(translation.x).x {
                drawerView.frame = self.drawerView.frame.addX(translation.x)
            }
            let ratio = 1.0 - ((drawerView.frame.right - view.frame.width) / drawerView.frame.width)
            backgroundView.alpha = backgroundAlpha * ratio
        }
    }
    
    private var hiddenX: CGFloat {
        return drawerGravity == .left ? -drawerView.frame.width : view.frame.width
    }
    
    private var visibleX: CGFloat {
        return drawerGravity == .left ? 0 : view.frame.width - drawerView.frame.width
    }
    
    func showDrawer() {
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: .curveEaseInOut,
                       animations: {
                        self.backgroundView!.alpha = backgroundAlpha
                        self.drawerView.frame = self.drawerView.frame.setX(self.visibleX)
                        self.view.layoutIfNeeded()
        })
    }
    
    func hideDrawer(completion:(() -> ())? = nil) {
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.backgroundView!.alpha = 0
                self.drawerView.frame = self.drawerView.frame.setX(self.hiddenX)
                self.view.layoutIfNeeded()
            },
            completion: { finished in
                self.dismiss(animated: false, completion: completion)
            }
        )
    }
}
