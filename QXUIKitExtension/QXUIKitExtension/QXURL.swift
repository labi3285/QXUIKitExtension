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
    
    public var nsUrl: URL? {
        switch self {
        case .url(let url):
            return URL(string: url)
        case .file(let path):
            return URL(fileURLWithPath: path)
        case .data(let data):
            if #available(iOS 9.0, *) {
                return URL(dataRepresentation: data, relativeTo: nil)
            } else {
                fatalError("support 9.0")
            }
        }
    }
}
