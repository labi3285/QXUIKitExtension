//
//  QXTextFilter.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import Foundation

public enum QXTextFilter {
    
    /// 字符串
    case characters(limit: Int?, regex: String?)

    /// 编号
    case number(limit: Int?)
    
    /// 整数
    case integer(min: Int, max: Int)
    /// 浮点数
    case float(min: Float, max: Float)
    /// 双精度
    case double(min: Double, max: Double)
    
    /// 金额
    case money(min: Double, max: Double)
    
    public func filte(_ text: String) -> String {
        func doRegex(_ text: String, regex: String?) -> String {
            if let regex = regex {
                return _filte(text, regex: regex)
            }
            return text
        }
        func doLimit(_ text: String, limit: Int?) -> String {
            if let limit = limit {
                if text.count >= limit {
                    return text.qxSubString(start: 0, end: limit)
                }
            }
            return text
        }
        switch self {
        case .characters(limit: let limit, regex: let regex):
            var _text = text
            _text = doRegex(_text, regex: regex)
            _text = doLimit(_text, limit: limit)
            return _text
        case .number(limit: let limit):
            var _text = text
            _text = doLimit(_text, limit: limit)
            var cc = ""
            for c in _text {
                if "0123456789".contains(c) {
                    cc += "\(c)"
                }
            }
            return cc
        case .integer(min: let _min, max: let _max):
            var n = (text as NSString).integerValue
            n = min(max(n, _min), _max)
            return "\(n)"
        case .float(min: let _min, max: let _max):
            if text.hasSuffix(".") {
                var t = text
                t.removeLast()
                var n = (t as NSString).integerValue
                n = min(Int(_max), max(Int(_min), n))
                return "\(n)."
            } else if text.contains(".") {
                var n = (text as NSString).floatValue
                n = min(max(n, _min), _max)
                return "\(n)"
            } else {
                var n = (text as NSString).integerValue
                n = min(Int(_max), max(Int(_min), n))
                return "\(n)"
            }
        case .double(min: let _min, max: let _max):
            if text.hasSuffix(".") {
                var t = text
                t.removeLast()
                var n = (t as NSString).integerValue
                n = min(Int(_max), max(Int(_min), n))
                return "\(n)."
            } else if text.contains(".") {
                var n = (text as NSString).doubleValue
                n = min(max(n, _min), _max)
                return "\(n)"
            } else {
                var n = (text as NSString).integerValue
                n = min(Int(_max), max(Int(_min), n))
                return "\(n)"
            }
        case .money(min: let _min, max: let _max):
            if text.hasSuffix(".") {
                var t = text
                t.removeLast()
                var n = (t as NSString).integerValue
                n = min(Int(_max), max(Int(_min), n))
                return "\(n)."
            } else if text.contains(".") {
                var n = (text as NSString).doubleValue
                n = min(max(n, _min), _max)
                n = Double(Int(n * 100)) / 100
                return "\(n)"
            } else {
                var n = (text as NSString).integerValue
                n = min(Int(_max), max(Int(_min), n))
                return "\(n)"
            }
        }
        
    }
    
    /// 正则过滤
    private func _filte(_ text: String, regex: String) -> String {
        do {
            let result = try NSRegularExpression(pattern: regex, options: .caseInsensitive)
            return result.stringByReplacingMatches(
                in: text,
                options: .reportCompletion,
                range: NSMakeRange(0, text.count),
                withTemplate: "")
        } catch {
        }
        return text
    }
    
}
