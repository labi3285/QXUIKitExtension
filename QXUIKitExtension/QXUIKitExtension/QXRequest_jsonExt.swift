//
//  QXRequest_jsonExt.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import Foundation
import QXJSON

extension QXRequest {
    
    /// 请求 json
    open func fetchJSON(done: @escaping (_ respond: Respond<QXJSON>) -> Void) {
        fetchData { (respond) in
            switch respond {
            case .succeed(let t):
                let e = QXJSON(t)
                done(.succeed(e))
            case .failed(let e):
                done(.failed(e))
            }
        }
    }
    
}
