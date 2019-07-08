//
//  QXError.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/5.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import Foundation

public struct QXError {
    
    public var code: Int
    public var message: String
    public var info: Any?
    
    init(_ code: Int, _ message: String, _ info: Any? = nil) {
        self.code = code
        self.message = message
        self.info = info
    }
    
}
