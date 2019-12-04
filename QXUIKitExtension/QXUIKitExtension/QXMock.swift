//
//  QXMock.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/11/26.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import Foundation
import QXJSON

public class QXModelsMock<Model> {
    
    public init(factor: ((_ filter: QXFilter) -> [Model])?) {
        self.factor = factor
        self.error = nil
    }
    public init(_ error: QXError) {
        self.factor = nil
        self.error = error
    }
    
    public let factor: ((_ filter: QXFilter) -> [Model])?
    public let error: QXError?
    public var requestSecs: TimeInterval = 1
    
    public func execute(_ filter: QXFilter, _ onSucceed: @escaping QXClosureApiModels<Model>, _ onFailed: @escaping QXClosureApiError) {
        DispatchQueue.main.qxAsyncAfter(requestSecs) {
            if let e = self.error {
                onFailed(e)
            } else {
                if let f = self.factor {
                    let ms = f(filter)
                    onSucceed(ms, true)
                } else {
                    onSucceed([], false)
                }
            }
        }
    }
    
}


public class QXModelMock<T> {
        
    public init(factor: (() -> T)?) {
        self.factor = factor
        self.error = nil
    }
    public init(_ error: QXError) {
        self.factor = nil
        self.error = error
    }
    
    public let factor: (() -> T)?
    public let error: QXError?
    public var requestSecs: TimeInterval = 1
    
    public func execute(_ onSucceed: @escaping QXClosureApiModel<T>, _ onFailed: @escaping QXClosureApiError) {
        DispatchQueue.main.qxAsyncAfter(requestSecs) {
            if let e = self.error {
                onFailed(e)
            } else {
                if let f = self.factor {
                    let m = f()
                    onSucceed(m)
                } else {
                    onSucceed(nil)
                }
            }
        }
    }
    
}
