//
//  QXApi.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/11/26.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import Foundation
import QXJSON

public typealias QXClosureApiModel<Model>
    = (_ model: Model?) -> ()
public typealias QXClosureApiModels<Model>
    = (_ models: [Model], _ isThereMore: Bool?) -> ()
public typealias QXClosureApiError
    = (_ err: QXError?) -> ()

public typealias QXClosureModelsApi<Model>
    = (_ filter: QXFilter, _ onSucceed: @escaping QXClosureApiModels<Model>, _ onFailed: @escaping QXClosureApiError) -> ()
public typealias QXClosureModelApi<Model> = (_ onSucceed: @escaping QXClosureApiModel<Model>, _ onFailed: @escaping QXClosureApiError) -> ()

open class QXModelsApi<Model> {
    
    public let api: QXClosureModelsApi<Model>
    public var mock: QXModelsMock<Model>?
    
    public init(api: @escaping QXClosureModelsApi<Model>) {
        self.api = api
    }
    
    public func execute(_ filter: QXFilter, _ onSucceed: @escaping QXClosureApiModels<Model>, _ onFailed: @escaping QXClosureApiError) {
        if QXApp.isRelease {
            api(filter, onSucceed, onFailed)
        } else {
            if let e = mock {
                e.execute(filter, onSucceed, onFailed)
            } else {
                api(filter, onSucceed, onFailed)
            }
        }
    }
    
}

public struct QXModelApi<T> {
    
    public let api: QXClosureModelApi<T>
    public var mock: QXModelMock<T>?
    
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
