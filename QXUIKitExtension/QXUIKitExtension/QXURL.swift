//
//  QXURL.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/6/22.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import Foundation

public enum QXURL {
    
    case url(_ url: String)
    case file(_ path: String)
    
    @available(OSX 10.11, iOS 9.0, *)
    case data(_ data: Data)
    
    case nsUrl(_ url: URL)
    
    public static let invaild: QXURL = QXURL.url("invalid")
    
    public var nsUrl: URL? {
        switch self {
        case .url(let e):
            return URL(string: e.qxUrlEncodingString)
        case .file(let e):
            return URL(fileURLWithPath: e.qxUrlEncodingString)
        case .nsUrl(let e):
            return e
        case .data(let e):
            if #available(iOS 9.0, *) {
                return URL(dataRepresentation: e, relativeTo: nil)
            } else {
                return QXDebugFatalError("support >=9.0", URL(string: ""))
            }
        }
    }
    
}
