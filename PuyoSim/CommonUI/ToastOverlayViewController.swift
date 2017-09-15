//
//  ToastOverlayViewController.swift
//  PuyoSim
//
//  Created by roza on 2017/08/22.
//  Copyright © 2017年 GMO Click Holdings Co,. Ltd. All rights reserved.
//

import Foundation
import UIKit

class ToastManager {
    private let queue = DispatchQueue(label: "ToastManager Show Message Queue")
    
    static var shared: ToastManager = ToastManager()
    private init() { }
    
    func show(message: String, duration: TimeInterval = 3) {
        queue.async {
            ToastOverlayViewController.show(message: message, duration: duration)
        }
    }
    
}

fileprivate class ToastOverlayViewController: UIViewController, OverlayPresentation {

    static func show(message: String, duration: TimeInterval) {
        let instance = ToastOverlayViewController(message: message)
        instance.showSync(duration: duration)
    }
    
    private let semaphore = DispatchSemaphore(value: 0)
    private func showSync(duration: TimeInterval) {
        self.showOverlay(duration: duration)
        semaphore.wait()
    }
    
    var window: UIWindow?
    
    private var label = UILabel()
    
    init(message: String) {
        super.init(nibName: nil, bundle: nil)
        label.alpha = 0
        label.text = message
    }
    
    func didHideWindow() {
        semaphore.signal()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isUserInteractionEnabled = false
        label.backgroundColor = UIColor.black
        label.textColor = UIColor.white
        view.addSubview(label)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        label.sizeToFit()
        label.frame = label.frame.setCenterX(view.frame.centerX).setBottom(view.frame.bottom - 52)
    }
    
    var showAnimateDuration: TimeInterval = 0.2
    func showAnimation() {
        self.label.alpha = 1
    }
    
    var hideAnimateDuration: TimeInterval = 0.2
    func hideAnimation() {
        self.label.alpha = 0
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIApplication.shared.statusBarStyle
    }
    
}
