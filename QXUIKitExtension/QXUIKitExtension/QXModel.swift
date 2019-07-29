//
//  QXModel.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import Foundation
import QXJSON

open class QXModel {
    
    public var __json: QXJSON = QXJSON()
    open func update(_ json: QXJSON) {
        __json = json
    }
    
    required public init() {
        
    }
    
}
