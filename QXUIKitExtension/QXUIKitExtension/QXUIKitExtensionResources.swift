//
//  QXBundle.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/19.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import Foundation

public class QXUIKitExtensionResources {
    
    public static let shared: QXUIKitExtensionResources = QXUIKitExtensionResources()
    
    public var bundle: Bundle {
        if let e = _bundle {
            return e
        }
        let bundle = Bundle(for: QXUIKitExtensionResources.self)
        if let path = bundle.path(forResource: "QXUIKitExtensionResources.bundle", ofType: nil) {
            if let e = Bundle(path: path) {
                _bundle = e
                return e
            }
        }
        return QXDebugFatalError("无效资源", Bundle())
    }
    
    public init() { }
    
    private var _bundle: Bundle?
    
    public func image(gifPath: String) -> QXImage {
        return QXImage(gifPath: gifPath, in: bundle)
    }
    
    public func image(_ cacheNamed: String) -> QXImage {
        return QXImage(cacheNamed, in: bundle)
    }
    
}

extension QXUIKitExtensionResources {
    
    /**
     * 获取资源路径
     */
    public func path(for name: String) -> String {
        if let e = bundle.path(forResource: name, ofType: nil) {
            return e
        }
        return QXDebugFatalError("无效资源", "invaild")
    }
    
    /**
     * 获取资源地址
     */
    public func url(for name: String) -> QXURL {
        if let e = bundle.url(forResource: name, withExtension: nil) {
            return QXURL.nsUrl(e)
        }
        return QXDebugFatalError("无效资源", QXURL.invaild)
    }
    
}
