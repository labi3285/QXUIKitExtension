//
//  QXJSON.swift
//
//  Created by labi3285 on 2018/8/10.
//  Copyright © 2018年 labi3285. All rights reserved.
//

import UIKit

public struct QXJSON: CustomStringConvertible {
    
    public init(_ any: Any?) {
        self.metaData = _makeupMetaData(any)
    }
    
    public init() { }
    
    public private(set) var metaData: Any? = nil
    public static var null: QXJSON = QXJSON.init()
    
    public var description: String {
        if let metaData = metaData {
            if metaData is [Any?] || metaData is [AnyHashable: Any?] {
                if let data = try? JSONSerialization.data(withJSONObject: metaData, options: .prettyPrinted) {
                    if let s = String(data: data, encoding: .utf8) {
                        return s
                    }
                }
            } else {
                return "\(metaData)"
            }
        }
        return "null"
    }

    fileprivate func _makeupMetaData(_ any: Any?) -> Any? {
        if let any = any {
            if let json = any as? QXJSON {
                return json.metaData
            } else if let arr = any as? [QXJSON] {
                return arr.map({ $0.metaData })
            } else if let arr = any as? [Any?] {
                return arr.map { _makeupMetaData($0) }
            } else if let dic = any as? [AnyHashable: Any?] {
                return dic.mapValues({ _makeupMetaData($0) })
            } else {
                return any
            }
        }
        return nil
    }
    
}

extension QXJSON {
    
    public subscript(index: Int) -> QXJSON {
        set {
            if let metaData = metaData {
                if var arr = metaData as? [Any?] {
                    if index < 0 {
                        arr.insert(newValue.metaData, at: 0)
                    } else if index >= arr.count {
                        arr.append(newValue.metaData)
                    } else {
                        arr[index] = newValue.metaData
                    }
                    self.metaData = arr
                }
            }
        }
        get {
            if let metaData = metaData {
                if let arr = metaData as? [Any?] {
                    if index >= 0 && index < arr.count {
                        return QXJSON(arr[index])
                    }
                }
            }
            return QXJSON.null
        }
    }
    
    
    public subscript(key: String) -> QXJSON {
        set {
            if let metaData = metaData {
                if var dic = metaData as? [AnyHashable: Any?] {
                    dic[key] = newValue.metaData
                    self.metaData = dic
                }
            }
        }
        get {
            if let metaData = metaData {
                if let dic = metaData as? [AnyHashable: Any?] {
                    if let any = dic[key] {
                        return QXJSON(any)
                    }
                }
            }
            return QXJSON.null
        }
    }

}

extension QXJSON {
    
    public var jsonList: [QXJSON]? {
        set {
            metaData = _makeupMetaData(newValue)
        }
        get {
            if let metaData = metaData {
                if let arr = metaData as? [Any?] {
                    return arr.map({ QXJSON($0) })
                } else if let dic = metaData as? [AnyHashable: Any] {
                    return dic.map({ QXJSON(($0, $1)) })
                }
            }
            return nil
        }
    }
    
    public var uint: UInt? {
        set {
            metaData = newValue
        }
        get {
            if let metaData = metaData {
                if let n = metaData as? UInt {
                    return n
                } else if let n = metaData as? NSNumber {
                    return n.uintValue
                } else if let s = metaData as? String {
                    return UInt(s)
                }
            }
            return nil
        }
    }
    
    public var uint8: UInt8? {
        set {
            metaData = newValue
        }
        get {
            if let metaData = metaData {
                if let n = metaData as? UInt8 {
                    return n
                } else if let n = metaData as? NSNumber {
                    return n.uint8Value
                } else if let s = metaData as? String {
                    return UInt8(s)
                }
            }
            return nil
        }
    }
    
    public var uint16: UInt16? {
        set {
            metaData = newValue
        }
        get {
            if let metaData = metaData {
                if let n = metaData as? UInt16 {
                    return n
                } else if let n = metaData as? NSNumber {
                    return n.uint16Value
                } else if let s = metaData as? String {
                    return UInt16(s)
                }
            }
            return nil
        }
    }
    
    public var uint32: UInt32? {
        set {
            metaData = newValue
        }
        get {
            if let metaData = metaData {
                if let n = metaData as? UInt32 {
                    return n
                } else if let n = metaData as? NSNumber {
                    return n.uint32Value
                } else if let s = metaData as? String {
                    return UInt32(s)
                }
            }
            return nil
        }
    }
    
    public var uint64: UInt64? {
        set {
            metaData = newValue
        }
        get {
            if let metaData = metaData {
                if let n = metaData as? UInt64 {
                    return n
                } else if let n = metaData as? NSNumber {
                    return n.uint64Value
                } else if let s = metaData as? String {
                    return UInt64(s)
                }
            }
            return nil
        }
    }
    
    public var int: Int? {
        set {
            metaData = newValue
        }
        get {
            if let metaData = metaData {
                if let n = metaData as? Int {
                    return n
                } else if let n = metaData as? NSNumber {
                    return n.intValue
                } else if let s = metaData as? String {
                    return Int(s)
                }
            }
            return nil
        }
    }
    
    public var int8: Int8? {
        set {
            metaData = newValue
        }
        get {
            if let metaData = metaData {
                if let n = metaData as? Int8 {
                    return n
                } else if let n = metaData as? NSNumber {
                    return n.int8Value
                } else if let s = metaData as? String {
                    return Int8(s)
                }
            }
            return nil
        }
    }
    
    public var int16: Int16? {
        set {
            metaData = newValue
        }
        get {
            if let metaData = metaData {
                if let n = metaData as? Int16 {
                    return n
                } else if let n = metaData as? NSNumber {
                    return n.int16Value
                } else if let s = metaData as? String {
                    return Int16(s)
                }
            }
            return nil
        }
    }
    
    public var int32: Int32? {
        set {
            metaData = newValue
        }
        get {
            if let metaData = metaData {
                if let n = metaData as? Int32 {
                    return n
                } else if let n = metaData as? NSNumber {
                    return n.int32Value
                } else if let s = metaData as? String {
                    return Int32(s)
                }
            }
            return nil
        }
    }
    
    public var int64: Int64? {
        set {
            metaData = newValue
        }
        get {
            if let metaData = metaData {
                if let n = metaData as? Int64 {
                    return n
                } else if let n = metaData as? NSNumber {
                    return n.int64Value
                } else if let s = metaData as? String {
                    return Int64(s)
                }
            }
            return nil
        }
    }
    
    public var float: Float? {
        set {
            metaData = newValue
        }
        get {
            if let metaData = metaData {
                if let n = metaData as? Float {
                    return n
                } else if let n = metaData as? NSNumber {
                    return n.floatValue
                } else if let s = metaData as? String {
                    return Float(s)
                }
            }
            return nil
        }
    }
    
    public var double: Double? {
        set {
            metaData = newValue
        }
        get {
            if let metaData = metaData {
                if let n = metaData as? Double {
                    return n
                } else if let n = metaData as? NSNumber {
                    return n.doubleValue
                } else if let s = metaData as? String {
                    return Double(s)
                }
            }
            return nil
        }
    }

    public var bool: Bool? {
        set {
            metaData = newValue
        }
        get {
            if let metaData = metaData {
                if let n = metaData as? Bool {
                    return n
                } else if let n = metaData as? NSNumber {
                    return n.boolValue
                } else if let s = metaData as? String {
                    if s.contains("F") || s.contains("f") || s.contains("否") || s.contains("N") || s.contains("n") {
                        return false
                    } else if s.contains("Y") || s.contains("y") || s.contains("是") || s.contains("T") || s.contains("t") {
                        return true
                    } else {
                        if let n = Int(s) {
                            return n != 0
                        }
                    }
                    return nil
                }
            }
            return nil
        }
    }
    
    public var string: String? {
        set {
            metaData = newValue
        }
        get {
            if let metaData = metaData {
                if let s = metaData as? String {
                    return s
                } else if let n = metaData as? NSNumber {
                    return n.stringValue
                }
            }
            return nil
        }
    }
    
    public var array: [Any?]? {
        set {
            metaData = newValue
        }
        get {
            if let metaData = metaData {
                if let arr = metaData as? [Any?] {
                    return arr
                }
            }
            return nil
        }
    }
    
    public var dictionary: [AnyHashable: Any?]? {
        set {
            metaData = newValue
        }
        get {
            if let metaData = metaData {
                if let dic = metaData as? [AnyHashable: Any?] {
                    return dic
                }
            }
            return nil
        }
    }

    public var jsonListValue: [QXJSON]
                                    { return jsonList ?? [] }

    public var uintValue: UInt      { return uint ?? 0 }
    public var uint8Value: UInt8    { return uint8 ?? 0 }
    public var uint16Value: UInt16  { return uint16 ?? 0 }
    public var uint32Value: UInt32  { return uint32 ?? 0 }
    public var uint64Value: UInt64  { return uint64 ?? 0 }
    
    public var intValue: Int        { return int ?? 0 }
    public var int8Value: Int8      { return int8 ?? 0 }
    public var int16Value: Int16    { return int16 ?? 0 }
    public var int32Value: Int32    { return int32 ?? 0 }
    public var int64Value: Int64    { return int64 ?? 0 }
    
    public var floatValue: Float    { return float ?? 0 }
    public var doubleValue: Double  { return double ?? 0 }
    public var boolValue: Bool  { return bool ?? false }

    public var stringValue: String  { return string ?? "" }
    
    public var arrayValue: [Any?]   { return array ?? [] }
    public var dictionaryValue: [AnyHashable: Any?]
                                    { return dictionary ?? [:] }

}

extension QXJSON {
    
    public var jsonData: Data? {
        set {
            if let data = newValue {
                metaData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            } else {
                metaData = nil
            }
        }
        get {
            if let metaData = metaData {
                if metaData is [Any?] || metaData is [AnyHashable: Any?] {
                    if let data = try? JSONSerialization.data(withJSONObject: metaData, options: .init(rawValue: 0)) {
                        return data
                    }
                }
            }
            return nil
        }
    }
    
    public var jsonString: String? {
        set {
            jsonData = newValue?.data(using: .utf8)
        }
        get {
            if let data = jsonData {
                return String(data: data, encoding: .utf8)
            }
            return nil
        }
    }
    
}

extension QXJSON:
    ExpressibleByStringLiteral,
    ExpressibleByIntegerLiteral,
    ExpressibleByFloatLiteral,
    ExpressibleByDictionaryLiteral,
    ExpressibleByArrayLiteral,
    ExpressibleByNilLiteral
{
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
    public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
        self.init(value)
    }
    public init(unicodeScalarLiteral value: StringLiteralType) {
        self.init(value)
    }
    
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(value)
    }
    
    public init(floatLiteral value: FloatLiteralType) {
        self.init(value)
    }
    
    public init(dictionaryLiteral elements: (String, Any)...) {
        let array = elements
        self.init(dictionaryLiteral: array)
    }
    public init(dictionaryLiteral elements: [(String, Any)]) {
        var dic = [String: Any?](minimumCapacity: elements.count)
        for element in elements {
            dic[element.0] = QXJSON(element.1).metaData
        }
        self.init(dic)
    }
    
    public init(arrayLiteral elements: Any...) {
        self.init(elements)
    }
    
    public init(nilLiteral: ()) {
        self.init(nil)
    }
    
}

