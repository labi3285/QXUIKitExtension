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
extension CGFloat: QXIsEmpty { public var qxIsEmpty: Bool { return self == 0 } }

extension CGSize: QXIsEmpty { public var qxIsEmpty: Bool { return self.width == 0 && self.height == 0 } }
extension CGPoint: QXIsEmpty { public var qxIsEmpty: Bool { return self.x == 0 && self.y == 0 } }
extension UIEdgeInsets: QXIsEmpty { public var qxIsEmpty: Bool { return self.top == 0 && self.right == 0 && self.bottom == 0 && self.left == 0 } }
extension CGRect: QXIsEmpty { public var qxIsEmpty: Bool { return self.width == 0 && self.height == 0 && self.minX == 0 && self.minY == 0 } }

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
    return true
}
