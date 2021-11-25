//
//  QXVersion.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2020/1/4.
//  Copyright © 2020 labi3285_lab. All rights reserved.
//

import Foundation

// Compare Two QXVerson
public func < (lhs: QXVerson, rhs: QXVerson) -> Bool {
    return QXVerson.compare(A: lhs, B: rhs) == -1
}
public func > (lhs: QXVerson, rhs: QXVerson) -> Bool {
    return QXVerson.compare(A: lhs, B: rhs) == 1
}
public func == (lhs: QXVerson, rhs: QXVerson) -> Bool {
    return QXVerson.compare(A: lhs, B: rhs) == 0
}

/// AppVersin Model
public struct QXVerson {
    
    public let elements: [Int]
    
    public init(string: String, separator: String = ".") {
        var arr = [Int]()
        for str in string.components(separatedBy: separator) {
            arr.append((str as NSString).integerValue)
        }
        self.elements = arr
    }
    
    public static func compare(A: QXVerson, B: QXVerson) -> Int {
        for i in 0..<max(A.elements.count, B.elements.count) {
            let a = A.elements.count > i ? A.elements[i] : 0
            let b = B.elements.count > i ? B.elements[i] : 0
            if a == b {
                continue
            } else if a < b {
                return -1
            } else {
                return 1
            }
        }
        return 0
    }
}
