//
//  QXError.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/5.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import Foundation

public struct QXError: Error {
    
    public var code: String
    public var message: String
    public var info: Any?
    
    public init(_ code: Any, _ message: String, _ info: Any?) {
        self.code = "\(code)"
        self.message = message
        self.info = info
    }
    
    public init(_ code: Any, _ message: String) {
        self.code = "\(code)"
        self.message = message
        self.info = nil
    }
    
    public static let unknown: QXError = QXError(-1, "未知错误")
    public static let parse: QXError = QXError(-1, "解析错误")
    public static let format: QXError = QXError(-1, "格式错误")
    public static let noData: QXError = QXError(-1, "数据丢失")

}

extension Error {
    public var qxError: QXError {
        if let err = self as? QXError {
            return err
        } else {
            let err = self as NSError
            return QXError("\(err.code)", err.domain, err.userInfo)
        }
    }
}
