//
//  String_ext.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/6/22.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

extension String {
    
    public var qxInt: Int? { return Int(self) }
    public var qxInt8: Int8? { return Int8(self) }
    public var qxInt16: Int16? { return Int16(self) }
    public var qxInt32: Int32? { return Int32(self) }
    public var qxInt64: Int64? { return Int64(self) }
    
    public var qxIntValue: Int { return qxInt ?? 0 }
    public var qxInt8Value: Int8 { return qxInt8 ?? 0 }
    public var qxInt16Value: Int16 { return qxInt16 ?? 0 }
    public var qxInt32Value: Int32 { return qxInt32 ?? 0 }
    public var qxInt64Value: Int64 { return qxInt64 ?? 0 }
    
    public var qxUInt: UInt? { return UInt(self) }
    public var qxUInt8: UInt8? { return UInt8(self) }
    public var qxUInt16: UInt16? { return UInt16(self) }
    public var qxUInt32: UInt32? { return UInt32(self) }
    public var qxUInt64: UInt64? { return UInt64(self) }
    
    public var qxUIntValue: UInt { return qxUInt ?? 0 }
    public var qxUInt8Value: UInt8 { return qxUInt8 ?? 0 }
    public var qxUInt16Value: UInt16 { return qxUInt16 ?? 0 }
    public var qxUInt32Value: UInt32 { return qxUInt32 ?? 0 }
    public var qxUInt64Value: UInt64 { return qxUInt64 ?? 0 }
    
    public var qxDouble: Double? { return Double(self) }
    public var qxFloat: Float? { return Float(self) }
    public var qxCGFloat: CGFloat? { if let e = Double(self) { return CGFloat(e) }; return nil }
    
    public var qxDoubleValue: Double { return qxDouble ?? 0.0 }
    public var qxFloatValue: Float { return qxFloat ?? 0.0 }
    public var qxCGFloatValue: CGFloat { return qxCGFloat ?? 0.0 }

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
    
    public var qxUrlEncodingString: String {
        let charSet = NSMutableCharacterSet()
        charSet.formUnion(with: CharacterSet.urlQueryAllowed)
        charSet.addCharacters(in: "#%")
        return addingPercentEncoding(withAllowedCharacters: charSet as CharacterSet) ?? ""
    }
    
    /// 下划线
    public var qxUnderline: String {
        if !self.contains("_") {
            var str = ""
            for c in self {
                let s = "\(c)"
                if s == s.uppercased() {
                    str += "_" + s.lowercased()
                } else {
                    str += s
                }
            }
            return str
        }
        
        return self
    }
    
    /// 驼峰
    public var qxHump: String {
        if self.contains("_") {
            var str = ""
            var isPreUnderLine: Bool = false
            for c in self {
                let s = "\(c)"
                if s == "_" {
                    isPreUnderLine = true
                } else {
                    if isPreUnderLine {
                        str += s.uppercased()
                        isPreUnderLine = false
                    } else {
                        str += s
                    }
                }
            }
            return str
        }
        return self
    }
    
    
    public func qxRegexReplaceOccurrences(pattern: String, with: String,
                                 options: NSRegularExpression.Options = []) -> String {
        let regex = try! NSRegularExpression(pattern: pattern, options: options)
        return regex.stringByReplacingMatches(in: self, options: [],
                                              range: NSMakeRange(0, self.count),
                                              withTemplate: with)
    }
    
}
