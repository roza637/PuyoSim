//
//  BoardViewModel.swift
//  PuyoSim
//
//  Created by roza on 2017/07/04.
//  Copyright © 2017年 roza. All rights reserved.
//

import Foundation
import Bond

class BoardViewModel {
    
}

class PuyoViewModel {
    let isGhost = Observable(false)
    let type = Observable<PuyoType>(.blank)
}
