//
//  QXPrint.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/5.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

extension UIView {
    public func qxDebugRandomColor() {
        #if DEBUG
        backgroundColor = UIColor.qxRandom(alpha: 0.5)
        for view in subviews {
            view.qxDebugRandomColor()
        }
        #endif
    }
}

public func QXPrint<T>(_ t: T, _ file: String = #file, _ line: Int = #line) {
    print("[\((file as NSString).lastPathComponent) \(line) release] \(t)")
}

public func QXDebugPrint<T>(_ t: T, _ file: String = #file, _ line: Int = #line) {
    #if DEBUG
    print("[\((file as NSString).lastPathComponent) \(line) debug] \(t)")
    #endif
}

public func ?? <T>(lhs: T?, rhs: @autoclosure () -> Never) -> T {
    switch lhs {
    case let value?:
        return value
    case nil:
        rhs()
    }
}

public func QXAssert(_ condition: Bool, _ message: String, file: StaticString = #file, line: UInt = #line) {
    #if DEBUG
    assert(condition, message, file: file, line: line)
    #endif
}

public func QXDebugAssert(_ condition: Bool, _ message: String, file: StaticString = #file, line: UInt = #line) {
    assert(condition, message, file: file, line: line)
}

public func QXFatalError(_ msg: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError(msg(), file: file, line: line)
}

public func QXDebugFatalError(_ msg: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) {
    #if DEBUG
    fatalError(msg(), file: file, line: line)
    #endif
}

@discardableResult public func QXDebugFatalError<T>(_ msg: @autoclosure () -> String, _ t: T, file: StaticString = #file, line: UInt = #line) -> T {
    #if DEBUG
    fatalError(msg(), file: file, line: line)
    #endif
    return t
}
