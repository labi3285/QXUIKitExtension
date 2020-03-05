//
//  QXTextFilter.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

public enum QXTextFilter {
    
    /// 字符串
    case characters(limit: Int?, regex: String?)
    
    /// ascii
    case ascii(limit: Int?, regex: String?)

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
    
    /// 手机号
    case phone
    
    /// 银行卡
    case backCard(length: Int?)
    
    /// 按utf8数量（英文占1单位，汉字占俩单位）
    case utf8(count: Int, regex: String?)
    
    /// 16进制，是否大写
    case hex(count: Int, uppercased: Bool)
    
    public func filte(_ text: String) -> String {
        if text == "" {
            return text
        }
        func doRegex(_ text: String, regex: String?) -> String {
            if let regex = regex {
                return _filte(text, regex: regex)
            }
            return text
        }
        func doLimit(_ text: String, limit: Int?) -> String {
            if let limit = limit {
                if text.count >= limit {
                    return text.qxString(start: 0, end: limit - 1)
                }
            }
            return text
        }
        func doUTF8Limit(_ text: String, limit: Int) -> String {
            var t = ""
            var length = 0
            for char in text {
                let s = "\(char)"
                if s.lengthOfBytes(using: .utf8) == 1 {
                    length += 1
                } else {
                    length += 2
                }
                if length <= limit {
                    t += s
                } else {
                    break
                }
            }
            return t
        }
        switch self {
        case .ascii(limit: let limit, regex: let regex):
            var _text = text
            _text = doRegex(_text, regex: regex)
            _text = doLimit(_text, limit: limit)
            return _text
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
        case .phone:
            if text.count == 1 && text != "1" {
                return ""
            }
            var count: Int = 1
            var t = ""
            for e in text {
                let char = "\(e)"
                if "1234567890".contains(char) {
                    t += char
                    if count == 3 || count == 7 {
                        t += " "
                    }
                    if count >= 11 {
                        break
                    }
                    count += 1
                }
            }
            t = t.qxStringByCheckOrRemoveSuffix(" ")
            return t
        case .backCard(length: let l):
            var count: Int = 1
            var t = ""
            for e in text {
                let char = "\(e)"
                if "1234567890".contains(char) {
                    t += char
                    if count == 4 || count == 8 || count == 12 || count == 16 {
                        t += " "
                    }
                    if count >= l ?? 20 {
                        break
                    }
                    count += 1
                }
            }
            t = t.qxStringByCheckOrRemoveSuffix(" ")
            return t
        case .utf8(count: let count, regex: let regex):
            var _text = text
            _text = doRegex(_text, regex: regex)
            _text = doUTF8Limit(_text, limit: count)
            return _text
        case .hex(count: let count, uppercased: let uppercased):
            var _text = ""
            for e in text {
                if "1234567890abcdefABCDEF".contains(e) {
                    if uppercased {
                        _text += "\(e)".uppercased()
                    } else {
                        _text += "\(e)".lowercased()
                    }
                }
            }
            _text = doLimit(_text, limit: count)
            return _text
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

extension UITextField {
    
    public func qxUpdateFilter(_ filter: QXTextFilter?) {
        if let filter = filter {
            switch filter {
            case .ascii(limit: _, regex: _):
                keyboardType = .asciiCapable
            case .characters(limit: _, regex: _):
                keyboardType = .default
            case .integer(min: _, max: _):
                keyboardType = .decimalPad
            case .double(min: _, max: _):
                keyboardType = .decimalPad
            case .float(min: _, max: _):
                keyboardType = .decimalPad
            case .number(limit: _):
                keyboardType = .numberPad
            case .money(min: _, max: _):
                keyboardType = .decimalPad
            case .phone:
                keyboardType = .numberPad
            case .backCard(length: _):
                keyboardType = .numberPad
            case .utf8(count: _, regex: _):
                keyboardType = .default
            case .hex(count: _, uppercased: _):
                keyboardType = .asciiCapable
            }
        } else {
            keyboardType = .default
        }
    }
    
}

extension UITextView {
    
    public func qxUpdateFilter(_ filter: QXTextFilter?) {
        if let filter = filter {
            switch filter {
            case .ascii(limit: _, regex: _):
                keyboardType = .asciiCapable
            case .characters(limit: _, regex: _):
                keyboardType = .default
            case .integer(min: _, max: _):
                keyboardType = .decimalPad
            case .double(min: _, max: _):
                keyboardType = .decimalPad
            case .float(min: _, max: _):
                keyboardType = .decimalPad
            case .number(limit: _):
                keyboardType = .numberPad
            case .money(min: _, max: _):
                keyboardType = .decimalPad
            case .phone:
                keyboardType = .numberPad
            case .backCard(length: _):
                keyboardType = .numberPad
            case .utf8(count: _, regex: _):
                keyboardType = .default
            case .hex(count: _, uppercased: _):
                keyboardType = .asciiCapable
            }
        } else {
            keyboardType = .default
        }
    }
    
}

