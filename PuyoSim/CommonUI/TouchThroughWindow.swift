//
//  TouchThroughWindow.swift
//  PuyoSim
//
//  Created by roza on 2017/08/22.
//  Copyright © 2017年 GMO Click Holdings Co,. Ltd. All rights reserved.
//

import Foundation
import UIKit

class TouchThroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == self {
            return nil
        }
        return view
    }
}
