//
//  String_ext.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/6/22.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import Foundation

extension String {
    
    public func qxSubStringWithoutPrefix(_ str: String) -> String {
        if hasPrefix(str) {
            return qxSubStringForward(length: count - str.count, jump: str.count)
        }
        return self
    }
    public func qxSubStringWithoutSuffix(_ str: String) -> String {
        if hasSuffix(str) {
            return qxSubStringBackward(length: count - str.count, jump: str.count)
        }
        return self
    }
    
    public func qxSubStringForward(length: Int, jump: Int) -> String {
        let s = jump
        let e = s + length - 1
        return qxSubString(start: s, end: e)
    }
    public func qxSubStringBackward(length: Int, jump: Int) -> String {
        let s = count - jump - length
        let e = s + length - 1
        return qxSubString(start: s, end: e)
    }
    public func qxSubString(start: Int, end: Int) -> String {
        var s = start
        var e = end
        if s < 0 { s = 0 }
        if e >= count { e = count - 1 }
        if e <= s { e = s }
        let _s = index(startIndex, offsetBy: s)
        let _e = index(startIndex, offsetBy: e)
        return String(self[_s..._e])
    }
    
}
