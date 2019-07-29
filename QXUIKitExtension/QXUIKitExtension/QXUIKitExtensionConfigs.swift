//
//  Configs.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/19.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

public struct QXUIKitExtensionConfigs {
    
    /// 表示成功的code
    static var jsonCode_ok: Int = 0
    /// 那种网络错误，标示为内容为空，ni表示不处理
    static var jsonCode_empty: Int? = nil

    /// 分页参数的key
    static var jsonKey_code: String = "code"
    static var jsonKey_message: String = "msg"
    static var jsonKey_data: String = "data"
    static var jsonKey_pageIndex: String = "pageNum"
    static var jsonKey_pageSize: String = "pageSize"
    static var jsonKey_pageCount: String = "total"
    static var jsonKey_pageList: String = "list"
    
}

//public protocol QXUIKitExtensionConfigsProtocol {
//    func qxUIKitExtensionUIImageViewAsycCacheRequest(_ imageView: UIImageView, _ url: URL, _ onProgress: ((QXProgress) -> ())?, _ onDone: ((_ image: UIImage?) -> ())?)
//    func qxUIKitExtensionUIImageViewHandleGif(_ imageView: UIImageView, _ data: Data)
//}
//
//public var QXUIKitExtensionConfigs: QXUIKitExtensionConfigsProtocol = QXUIKitExtensionNullConfigs()
//
//struct QXUIKitExtensionNullConfigs: QXUIKitExtensionConfigsProtocol {
//    
//    func qxUIKitExtensionUIImageViewAsycCacheRequest(_ imageView: UIImageView, _ url: URL, _ onProgress: ((QXProgress) -> ())?, _ onDone: ((_ image: UIImage?) -> ())?) {
//        QXDebugFatalError("Customise QXUIKitExtensionConfigs required")
//    }
//    
//    func qxUIKitExtensionUIImageViewHandleGif(_ imageView: UIImageView, _ data: Data) {
//        QXDebugFatalError("Customise QXUIKitExtensionConfigs required")
//    }
//    
//}




