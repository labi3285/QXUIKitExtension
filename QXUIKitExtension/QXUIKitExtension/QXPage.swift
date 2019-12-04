//
//  QXPage.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import Foundation
import QXJSON

open class QXFilter {
        
    public var dictionary: [String: Any] = [:]
        
    open var page: Int {
        set {
            dictionary["page"] = newValue
        }
        get {
            return dictionary["page"] as? Int ?? 0
        }
    }
    open var size: Int {
        set {
            dictionary["size"] = newValue
        }
        get {
            return dictionary["size"] as? Int ?? 0
        }
    }
        
    open class func firstPage() -> QXFilter {
        let e = QXFilter()
        e.page = 1
        e.size = 15
        return e
    }
    
    open class func nextPage(_ filter: QXFilter) -> QXFilter {
        let e = QXFilter()
        e.dictionary = filter.dictionary
        e.page = filter.page + 1
        return e
    }
    
}

public class QXPage<T: QXModel>: QXModel {
    open var models: [T]?
    open var pageIndex: Int = 0
    open var pageSize: Int = 0
    open var pageCount: Int? = nil
    open var isThereMorePage: Bool {
        if let e = pageCount {
            return e > pageIndex
        } else {
            return models?.count ?? 0 != 0
        }
    }
        
    public override func update(_ json: QXJSON) {
        super.update(json)
        pageIndex = json[QXUIKitExtensionConfigs.jsonKey_pageIndex].intValue
        pageSize = json[QXUIKitExtensionConfigs.jsonKey_pageSize].intValue
        pageCount = json[QXUIKitExtensionConfigs.jsonKey_pageCount].intValue
        models = json[QXUIKitExtensionConfigs.jsonKey_pageList].jsonList?.map({
            let t = T.init()
            t.update($0)
            return t
        })
    }
    
}
