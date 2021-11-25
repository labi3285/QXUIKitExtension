//
//  QXModel.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import Foundation
import HandyJSON

public protocol QXEnumProtocol: HandyJSONEnum { }
public protocol QXModelProtocol: HandyJSON {
    init?(any: Any?)
    init?(json: String?)
    init(dictionary: [String: Any])
    func toDictionary() -> [String: Any]
}
extension QXModelProtocol {
    // public init() { self.init() }
    public init?(any: Any?) {
        if let dic = any as? [String: Any] {
            self = Self.init(dictionary: dic)
        } else if let json = any as? String {
            if let e = Self.init(json: json) {
                self = e
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    public init?(json: String?) {
        if let e = Self.deserialize(from: json) {
            self = e
        } else {
            return nil
        }
    }
    public init(dictionary: [String: Any]) {
        self = Self.deserialize(from: dictionary)!
    }
    public func toDictionary() -> [String: Any] {
        if let dic = self.toJSON() {
            return dic
        } else {
            return QXDebugFatalError("解析错误", [:])
        }
    }
}

extension String: QXModelProtocol {
    public init?(any: Any?) {
        if let e = any {
            if let e = e as? String {
                self = e
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
extension Int: QXModelProtocol {
    public init?(any: Any?) {
        if let e = any {
            if let e = e as? Int {
                self = e
            } else if let e = e as? String {
                if let e = Int(e) {
                    self = e
                } else {
                    return nil
                }
            } else {
                if let e = Int("\(e)") {
                    self = e
                } else {
                    return nil
                }
            }
        } else {
            return nil
        }
    }
}
extension Float: QXModelProtocol {
    public init?(any: Any?) {
        if let e = any {
            if let e = e as? Float {
                self = e
            } else if let e = e as? String {
                if let e = Float(e) {
                    self = e
                } else {
                    return nil
                }
            } else {
                if let e = Float("\(e)") {
                    self = e
                } else {
                    return nil
                }
            }
        } else {
            return nil
        }
    }
}
extension Double: QXModelProtocol {
    public init?(any: Any?) {
        if let e = any {
            if let e = e as? Double {
                self = e
            } else if let e = e as? String {
                if let e = Double(e) {
                    self = e
                } else {
                    return nil
                }
            } else {
                if let e = Double("\(e)") {
                    self = e
                } else {
                    return nil
                }
            }
        } else {
            return nil
        }
    }
}
extension CGFloat: QXModelProtocol {
    public init?(any: Any?) {
        if let e = any {
            if let e = e as? CGFloat {
                self = e
            } else if let e = e as? String {
                if let e = Double(e) {
                    self = CGFloat(e)
                } else {
                    return nil
                }
            } else {
                if let e = Double("\(e)") {
                    self = CGFloat(e)
                } else {
                    return nil
                }
            }
        } else {
            return nil
        }
    }
}
