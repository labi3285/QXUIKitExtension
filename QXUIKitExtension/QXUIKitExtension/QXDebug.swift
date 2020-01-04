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

extension Bool {
    public var qxRandom: Bool {
        return arc4random_uniform(99) % 2 == 0
    }
}

public let QXDebugText: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis felis purus, volutpat at odio non, convallis maximus velit. Curabitur vel eros dolor. Nulla at vestibulum velit. Nunc nec nisi vestibulum, vestibulum libero nec, efficitur risus. Donec consequat, velit quis interdum efficitur, massa ex consequat nibh, id consequat libero ipsum at erat. Suspendisse rhoncus imperdiet urna, sit amet viverra diam egestas vitae. Proin tincidunt molestie tempus.\nPraesent orci ligula, molestie non lobortis at, ornare sit amet est. Ut sed dolor sit amet est rutrum dapibus. Cras interdum gravida urna, sed pulvinar nulla condimentum vel. Vivamus malesuada augue nunc, ac eleifend quam dapibus ut. Nunc scelerisque condimentum vehicula. Suspendisse fermentum massa gravida magna congue, quis eleifend mauris commodo. Maecenas sed dolor et augue posuere faucibus. Suspendisse bibendum sagittis magna et faucibus. Duis eu nunc pretium, lacinia dui sit amet, mollis libero. Phasellus finibus quis nisi at tristique. Nulla tincidunt augue ut fermentum tempus.\nUt quis libero in mi dignissim malesuada vel sed tellus. Fusce tempus eu lectus eget tincidunt. Vivamus elementum aliquet mauris, id egestas magna vestibulum eu. In convallis, arcu sed tempor pretium, justo diam varius augue, ac sodales felis neque ut augue. Suspendisse commodo ac sem vitae blandit. Pellentesque vitae libero vitae nulla tincidunt interdum pretium eu sem. Fusce malesuada, lorem iaculis gravida sagittis, tellus urna imperdiet orci, a malesuada risus eros a lectus. Nulla facilisi.\nAliquam erat volutpat. Nullam ornare aliquam ligula at fringilla. Nullam vel egestas sem, sit amet euismod lacus. Curabitur a tincidunt tortor. Nulla in gravida odio, in pulvinar arcu. Vestibulum varius ligula eros, nec tincidunt dui pellentesque in. Nunc lacinia lobortis consequat. Praesent nec tempor est. Aenean purus libero, consectetur ac tortor quis, dignissim tincidunt ante. Cras sagittis ex et libero maximus, et pellentesque diam luctus. Aliquam dapibus, eros nec vulputate egestas, nibh ipsum tincidunt sem, pulvinar finibus nunc augue ac libero. Donec eu nisi quis sapien feugiat tincidunt eu et lacus. In hac habitasse platea dictumst. Aliquam facilisis massa in neque consectetur malesuada. Aenean vestibulum purus quis lacus cursus auctor.\nMauris in lacus sodales, auctor leo et, ultrices ante. Proin sed eros pharetra nisi semper vehicula. Maecenas eleifend, dui tempus feugiat venenatis, nibh ipsum viverra arcu, sit amet rutrum eros augue maximus ligula. Duis nec elementum arcu, sed aliquam lorem. In euismod egestas scelerisque. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus efficitur ultrices tellus ac aliquam. Ut vitae aliquam massa. Nunc nec imperdiet felis. Duis at arcu in diam pellentesque vulputate eget id enim."

public func QXDebugRandomText(_ length: Int) -> String {
    if QXDebugText.count >= length {
        return QXDebugText.qxString(start: 0, end: Int(arc4random_uniform(UInt32(length))))
    }
    return QXDebugText
}
public func QXDebugText(_ length: Int) -> String {
    if QXDebugText.count >= length {
        return QXDebugText.qxString(start: 0, end: length)
    }
    return QXDebugText
}
public func QXDebugRandomInt(_ max: UInt32) -> Int {
    return Int(arc4random_uniform(max))
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

public func QXDebugAssert(_ condition: Bool, _ message: String = "", file: StaticString = #file, line: UInt = #line) {
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
