//
//  QXPage.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import Foundation

open class QXFilter {
        
    public var dictionary: [String: Any] = [:]
        
    open var page: Int {
        set {
            dictionary["page"] = newValue
        }
        get {
            return dictionary["page"] as? Int ?? 0
        }
    }
    open var size: Int {
        set {
            dictionary["size"] = newValue
        }
        get {
            return dictionary["size"] as? Int ?? 15
        }
    }

}
