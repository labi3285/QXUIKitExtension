//
//  QXApi.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/11/26.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import Foundation
import QXJSON

public typealias QXClosureApiModel<T> = (_ model: T?) -> ()
public typealias QXClosureApiModels<T> = (_ models: [T], _ isThereMore: Bool?) -> ()
public typealias QXClosureApiError = (_ err: QXError?) -> ()

public typealias QXClosureModelsApi<T> = (_ page: Int, _ size: Int, _ onSucceed: @escaping QXClosureApiModels<T>, _ onFailed: @escaping QXClosureApiError) -> ()
public typealias QXClosureModelApi<T> = (_ onSucceed: @escaping QXClosureApiModel<T>, _ onFailed: @escaping QXClosureApiError) -> ()

public struct QXModelsApi<T> {
    
    public let api: QXClosureModelsApi<T>
    public var mock: QXModelsMock<T>?
    
    public init(api: @escaping QXClosureModelsApi<T>) {
        self.api = api
    }
    
    public func execute(_ page: Int, _ size: Int, _ onSucceed: @escaping QXClosureApiModels<T>, _ onFailed: @escaping QXClosureApiError) {
        if QXApp.isRelease {
            api(page, size, onSucceed, onFailed)
        } else {
            if let e = mock {
                e.execute(page, size, onSucceed, onFailed)
            } else {
                api(page, size, onSucceed, onFailed)
            }
        }
    }
    
}

public struct QXModelApi<T> {
    
    public let api: QXClosureModelApi<T>
    var mock: QXModelMock<T>?
    
    public init(api: @escaping QXClosureModelApi<T>) {
        self.api = api
    }
    
    public func execute(_ onSucceed: @escaping QXClosureApiModel<T>, _ onFailed: @escaping QXClosureApiError) {
        if QXApp.isRelease {
            api(onSucceed, onFailed)
        } else {
            if let e = mock {
                e.execute(onSucceed, onFailed)
            } else {
                api(onSucceed, onFailed)
            }
        }
    }
    
}
