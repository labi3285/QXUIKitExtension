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
    
    public init(_ code: Int, _ message: String, _ info: Any?) {
        self.code = code
        self.message = message
        self.info = info
    }
    
    public init(_ code: Int, _ message: String) {
        self.code = code
        self.message = message
        self.info = nil
    }
    
    static let unknown: QXError = QXError(-1, "未知错误")
    static let parse: QXError = QXError(-1, "解析错误")
    static let format: QXError = QXError(-1, "格式错误")
    
}
