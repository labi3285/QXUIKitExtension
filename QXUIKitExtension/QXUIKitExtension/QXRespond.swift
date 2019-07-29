//
//  QXRespond.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import Foundation
import QXJSON

open class QXRespond<T: QXModel>: QXModel {
    
    open var isOk: Bool {
        return error == nil
    }
    
    public var data: T?
    public var error: QXError?
    
    open override func update(_ json: QXJSON) {
        super.update(json)
        if json[QXUIKitExtensionConfigs.jsonKey_code].intValue == 0 {
            let e = T.init()
            e.update(json[QXUIKitExtensionConfigs.jsonKey_data])
            data = e
            error = nil
        } else {
            if let e = QXUIKitExtensionConfigs.jsonCode_empty {
                if json[QXUIKitExtensionConfigs.jsonKey_code].intValue == e {
                    let e = T.init()
                    e.update(json[QXUIKitExtensionConfigs.jsonKey_data])
                    data = e
                    error = nil
                } else {
                    data = nil
                    error = QXError(json[QXUIKitExtensionConfigs.jsonKey_code].intValue, json[QXUIKitExtensionConfigs.jsonKey_message].stringValue)
                }
            } else {
                data = nil
                error = QXError(json[QXUIKitExtensionConfigs.jsonKey_code].intValue, json[QXUIKitExtensionConfigs.jsonKey_message].stringValue)
            }
        }
    }

}
