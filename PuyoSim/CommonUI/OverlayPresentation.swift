//
//  OverlayPresentation.swift
//  PuyoSim
//
//  Created by roza on 2017/08/22.
//  Copyright © 2017年 GMO Click Holdings Co,. Ltd. All rights reserved.
//

import Foundation
import UIKit

protocol OverlayPresentation {
    var window: UIWindow?{get set}
    
    func showAnimation()
    var showAnimateDuration: TimeInterval{get}
    
    func hideAnimation()
    var hideAnimateDuration: TimeInterval{get}
    
    func didHideWindow()
}

extension OverlayPresentation where Self: UIViewController {
    
    private func createWindow() -> UIWindow {
        let frame = UIScreen.main.bounds
        
        let window = TouchThroughWindow(frame: frame)
        window.backgroundColor = UIColor.clear
        window.rootViewController = self
        return window
    }
    
    func showOverlay(duration: Double) {
        var s = self
        DispatchQueue.main.async {
            s.window = s.createWindow()
            s.window?.makeKeyAndVisible()
            UIView.animate(withDuration: s.showAnimateDuration, animations: {
                s.showAnimation()
            }, completion: { _ in
                DispatchQueue.main.after(when: duration, block: {
                    s.hideOverlay()
                })
            })
        }
    }
    
    func showOverlay() {
        var s = self
        DispatchQueue.main.async {
            s.window = s.createWindow()
            s.window?.makeKeyAndVisible()
            UIView.animate(withDuration: s.showAnimateDuration, animations: {
                s.showAnimation()
            })
        }
    }
    
    func hideOverlay() {
        var s = self
        DispatchQueue.main.async {
            UIView.animate(withDuration: s.hideAnimateDuration, animations: {
                s.hideAnimation()
            }, completion: { _ in
                if (s.window?.isKeyWindow)! {
                    UIApplication.shared.delegate?.window?.flatMap{ $0.makeKeyAndVisible() }
                }

                s.window = nil
                s.didHideWindow()
            })
        }
    }
    
    func didHideWindow() {
        // Optional Method
    }
}

