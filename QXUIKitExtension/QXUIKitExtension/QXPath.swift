//
//  QXPath.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2020/1/4.
//  Copyright © 2020 labi3285_lab. All rights reserved.
//

import Foundation

public struct QXPath {
    
    /// 文档目录，可iTunes备份
    public static var document: String {
        if let e = _documentPath {
            return e
        } else {
            if let e = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
                _documentPath = e
                return e
            }
        }
        return QXDebugFatalError("wtf?", temp)
    }
    
    // 缓存目录，手动清空，系统在空间不足的时候会清空
    public static var cache: String {
        if let e = _cachePath {
            return e
        } else {
            if let e = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first {
                _cachePath = e
                return e
            }
        }
        return QXDebugFatalError("wtf?", temp)
    }
    
    // library目录，不会清空
    public static var library: String {
        if let e = _libraryPath {
            return e
        } else {
            if let e = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first {
                _libraryPath = e
                return e
            }
        }
        return QXDebugFatalError("wtf?", temp)
    }
    
    // 临时文件目录，重启清空
    public static var temp: String {
        if let e = _tempPath {
            return e
        } else {
            let e = NSTemporaryDirectory()
            _tempPath = e
            return e
        }
    }
    
    private static var _documentPath: String?
    private static var _cachePath: String?
    private static var _libraryPath: String?
    private static var _tempPath: String?

}
