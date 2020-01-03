//
//  QXURL.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/6/22.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import Foundation

public enum QXURL: CustomStringConvertible {
    
    case url(_ url: String)
    case file(_ path: String)
    
    @available(OSX 10.11, iOS 9.0, *)
    case data(_ data: Data)
    
    case nsURL(_ url: URL)
    
    public static let invaild: QXURL = QXURL.url("invalid")
    
    public static func file(_ file: String, in bundle: Bundle) -> QXURL {
        if let e = bundle.url(forResource: file, withExtension: nil) {
            return QXURL.nsURL(e)
        } else {
            return QXDebugFatalError("invalid: \(file)", QXURL.invaild)
        }
    }
    
    public var nsURL: URL? {
        switch self {
        case .url(let e):
            return URL(string: e.qxUrlEncodingString)
        case .file(let e):
            return URL(fileURLWithPath: e.qxUrlEncodingString)
        case .nsURL(let e):
            return e
        case .data(let e):
            if #available(iOS 9.0, *) {
                return URL(dataRepresentation: e, relativeTo: nil)
            } else {
                return QXDebugFatalError("support >=9.0", URL(string: ""))
            }
        }
    }
    
    public var stringValue: String {
        switch self {
        case .url(let e):
            return e
        case .file(let e):
            return e
        case .nsURL(let e):
            return e.absoluteString
        case .data(let data):
            return data.base64EncodedString()
        }
    }
    
    public var description: String {
        switch self {
        case .url(let e):
            return "QXURL.url \(e)"
        case .file(let e):
            return "QXURL.file \(e)"
        case .nsURL(let e):
            return "QXURL.nsURL \(e)"
        case .data(let data):
            return "QXURL.data \(data.count)"
        }
    }
    
}
