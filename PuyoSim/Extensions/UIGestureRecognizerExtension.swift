//
//  UIGestureRecognizerExtension.swift
//  PuyoSim
//
//  Created by roza on 2016/11/14.
//  Copyright © 2016年 roza All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func addTapGesture(action: @escaping (UITapGestureRecognizer) -> ()) {
        self.addGestureRecognizer(TapGestureRecognizer(action: action))
    }
    
    func addPanGesture(action: @escaping (UIPanGestureRecognizer) -> ()) {
        self.addGestureRecognizer(PanGestureRecognizer(action: action))
    }

    func addSwipeGesture(action: @escaping (UISwipeGestureRecognizer) -> ()) {
        self.addGestureRecognizer(SwipeGestureRecognizer(action: action))
    }

    func addHoldGesture(changeCount: Int = 20, durationSlow: Double = 0.1, durationFast: Double = 0.05, action: @escaping (UILongPressGestureRecognizer) -> ()) {
        self.addGestureRecognizer(HoldGestureRecognizer(changeCount: changeCount, durationSlow: durationSlow, durationFast: durationFast, action: action))
    }
}

fileprivate class TapGestureRecognizer: UITapGestureRecognizer {
    private var tapGesture: Gesture!
    
    convenience init(action: @escaping (UITapGestureRecognizer) -> ()) {
        self.init()
        self.tapGesture = Gesture(parent: self, action: action)
        self.addTarget(tapGesture, action: #selector(Gesture.action))
    }
    
    private class Gesture {
        
        private var _action: (UITapGestureRecognizer) -> ()
        weak var parent: UITapGestureRecognizer?
        
        init(parent: UITapGestureRecognizer, action: @escaping (UITapGestureRecognizer) -> ()) {
            self.parent = parent
            self._action = action
        }
        
        @objc func action() {
            _action(parent!)
        }
    }
}

fileprivate class PanGestureRecognizer: UIPanGestureRecognizer {
    private var gesture: Gesture!
    
    convenience init(action: @escaping (UIPanGestureRecognizer) -> ()) {
        self.init()
        self.gesture = Gesture(parent: self, action: action)
        self.addTarget(gesture, action: #selector(Gesture.action))
    }
    
    private class Gesture {
        
        private var _action: (UIPanGestureRecognizer) -> ()
        weak var parent: UIPanGestureRecognizer?
        
        init(parent: UIPanGestureRecognizer, action: @escaping (UIPanGestureRecognizer) -> ()) {
            self.parent = parent
            self._action = action
        }
        
        @objc func action() {
            _action(parent!)
        }
    }
}

fileprivate class SwipeGestureRecognizer: UISwipeGestureRecognizer {
    private var gesture: Gesture!
    
    convenience init(action: @escaping (UISwipeGestureRecognizer) -> ()) {
        self.init()
        self.gesture = Gesture(parent: self, action: action)
        self.addTarget(gesture, action: #selector(Gesture.action))
    }
    
    private class Gesture {
        
        private var _action: (UISwipeGestureRecognizer) -> ()
        weak var parent: UISwipeGestureRecognizer?
        
        init(parent: UISwipeGestureRecognizer, action: @escaping (UISwipeGestureRecognizer) -> ()) {
            self.parent = parent
            self._action = action
        }
        
        @objc func action() {
            _action(parent!)
        }
    }
}

class HoldGestureRecognizer: UILongPressGestureRecognizer {
    private var gesture: Gesture!
    
    convenience init(changeCount: Int = 20, durationSlow: Double = 0.1, durationFast: Double = 0.05, action: @escaping (UILongPressGestureRecognizer) -> ()) {
        self.init()
        self.gesture = Gesture(changeCount: changeCount, durationSlow: durationSlow, durationFast: durationFast, parent: self, action: action)
        self.addTarget(gesture, action: #selector(Gesture.action))
    }
    
    private class Gesture: NSObject {
        private var count = 0
        private var durationChangeCount: Int
        private var durationSlow: Double
        private var durationFast: Double
        
        var duration: Double {
            return count < durationChangeCount ? durationSlow : durationFast
        }
        
        private var _action: (UILongPressGestureRecognizer) -> ()
        weak var parent: HoldGestureRecognizer?
        
        init(changeCount: Int, durationSlow: Double, durationFast: Double, parent: HoldGestureRecognizer, action: @escaping (UILongPressGestureRecognizer) -> ()) {
            self.durationChangeCount = changeCount
            self.durationSlow = durationSlow
            self.durationFast = durationFast
            self.parent = parent
            self._action = action
        }
        
        @objc private func repeatAction() {
            if let parent = parent {
                _action(parent)
            }
            if count < durationChangeCount { count = count + 1 }
            self.perform(#selector(self.repeatAction), with: nil, afterDelay: duration)
        }
        
        private func stopAction(){
            count = 0
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.repeatAction), object: nil)
        }
        
        @objc func action() {
            if let parent = parent {
                switch parent.state {
                case .began:
                    repeatAction()
                case .changed:
                    break
                default:
                    stopAction()
                }
            }
        }
    }
}

