//
//  QXTypes.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2020/1/4.
//  Copyright © 2020 labi3285_lab. All rights reserved.
//

import Foundation

/// 公用key模型
public struct QXType<Code: Equatable> {
    public let code: Code
    public let name: String
    public init(code: Code, name: String) {
        self.code = code
        self.name = name
    }
}

/// 根据name查询code
public func QXTypeSearch<Code>(name: String?, inTypes: [QXType<Code>]) -> QXType<Code>? {
    if let name = name {
        for t in inTypes {
            if t.name == name {
                return t
            }
        }
    }
    return nil
}
/// 根据code查询name
public func QXTypeSearch<Code: Equatable>(code: Code?, inKeys: [QXType<Code>]) -> QXType<Code>? {
    if let code = code {
        for key in inKeys {
            if key.code == code {
                return key
            }
        }
    }
    return nil
}

// ————————————————————————————  BREAK  ————————————————————————————

///// key设置示例
//let kDemoKeys: [QXType<Int>] = [
//    QXType(code: 0, name: "类型A"),
//    QXType(code: 1, name: "类型B"),
//    QXType(code: 2, name: "类型C"),
//    QXType(code: 3, name: "类型D")
//]
