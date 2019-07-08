//
//  QXEmpty.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/5.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

public protocol QXIsEmpty {
    var qxIsEmpty: Bool { get }
}

extension String: QXIsEmpty { public var qxIsEmpty: Bool { return self.count == 0 } }
extension Int: QXIsEmpty { public var qxIsEmpty: Bool { return self == 0 } }
extension Int8: QXIsEmpty { public var qxIsEmpty: Bool { return self == 0 } }
extension Int16: QXIsEmpty { public var qxIsEmpty: Bool { return self == 0 } }
extension Int32: QXIsEmpty { public var qxIsEmpty: Bool { return self == 0 } }
extension Int64: QXIsEmpty { public var qxIsEmpty: Bool { return self == 0 } }
extension UInt: QXIsEmpty { public var qxIsEmpty: Bool { return self == 0 } }
extension UInt8: QXIsEmpty { public var qxIsEmpty: Bool { return self == 0 } }
extension UInt16: QXIsEmpty { public var qxIsEmpty: Bool { return self == 0 } }
extension UInt32: QXIsEmpty { public var qxIsEmpty: Bool { return self == 0 } }
extension UInt64: QXIsEmpty { public var qxIsEmpty: Bool { return self == 0 } }
extension Double: QXIsEmpty { public var qxIsEmpty: Bool { return self == 0 } }
extension Float: QXIsEmpty { public var qxIsEmpty: Bool { return self == 0 } }
extension Float80: QXIsEmpty { public var qxIsEmpty: Bool { return self == 0 } }
extension CGFloat: QXIsEmpty { public var qxIsEmpty: Bool { return self == 0 } }

public func QXEmpty(_ e: Any?) -> Bool {
    if let e = e {
        if let e = e as? QXIsEmpty {
            return e.qxIsEmpty
        } else if let e = e as? String {
            return e.count == 0
        } else if let e = e as? NSNumber {
            return e == 0
        } else if let e = e as? [Any?] {
            return e.isEmpty
        } else if let e = e as? [AnyHashable: Any?] {
            return e.isEmpty
        } else if let e = e as? Set<AnyHashable> {
            return e.isEmpty
        } else {
            return QXDebugFatalError("not support yet", false)
        }
    }
    return false
}
