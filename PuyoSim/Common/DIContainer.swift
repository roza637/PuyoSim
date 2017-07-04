//
//  DIContainer.swift
//  PuyoSim
//
//  Created by roza on 2016/11/02.
//  Copyright © 2016年 roza All rights reserved.
//

import Foundation

class DIContainer {
    
    init(declaration:(DIContainer) -> ()) {
        declaration(self)
    }
    
    private var creationMap: [String : ((DIContainer) -> Any, isSingleton: Bool)] = [:]
    private var singletonMap: [String : Any] = [:]
    
    func register<T>(type: T.Type, isSingleton: Bool = true, creation: @escaping (DIContainer) -> T) {
        let key = String(describing: type)
        creationMap[key] = (creation, isSingleton)
        singletonMap[key] = nil
    }
    
    func resolve<T>(type: T.Type) -> T {
        let key = String(describing: type)
        let creation = creationMap[key]
        
        if creation!.isSingleton {
            if let singleton = singletonMap[key] {
                return singleton as! T
            } else {
                singletonMap[key] = creation!.0(self)
                return singletonMap[key] as! T
            }
        } else {
            return creation!.0(self) as! T
        }
    }
}
