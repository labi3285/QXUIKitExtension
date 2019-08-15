//
//  QXRequest_pageExt.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import Foundation
import QXJSON

extension QXRequest {
        
    /// 请求 page
    open func fetchPage<T>(done: @escaping (_ respond: QXRespond<QXPage<T>>) -> ()) {
        fetchJSON { (respond) in
            switch respond {
            case .succeed(let json):
                let e = QXRespond<QXPage<T>>()
                e.update(json)
                done(e)
            case .failed(let err):
                let e = QXRespond<QXPage<T>>()
                e.data = nil
                e.error = err
                done(e)
            }
        }
    }
    
    /// 请求 model
    open func fetchModel<T>(done: @escaping (_ respond: QXRespond<T>) -> ()) {
        fetchJSON { (respond) in
            switch respond {
            case .succeed(let json):
                let e = QXRespond<T>()
                e.update(json)
                done(e)
            case .failed(let err):
                let e = QXRespond<T>()
                e.data = nil
                e.error = err
                done(e)
            }
        }
    }
    
}

