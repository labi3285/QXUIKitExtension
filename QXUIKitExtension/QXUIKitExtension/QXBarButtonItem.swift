//
//  UIBarButtonItem_ext.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/5.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXBarButtonItem: UIBarButtonItem {
    
    public static func backItem(_ title: String) -> QXBarButtonItem {
        let e = QXBarButtonItem()
        e.title = title
        return e
    }
    
    public static func titleItem(_ title: String, _ handler: @escaping () -> Void) -> QXBarButtonItem {
        let e = QXBarButtonItem(title: title, style: .plain, target: nil, action: #selector(itemClick))
        e.target = e
        e.respondClick = handler
        return e
    }
    
    public static func iconItem(_ icon: String, _ handler: @escaping () -> Void) -> QXBarButtonItem {
        let e = QXBarButtonItem(image: UIImage(named: icon), style: .plain, target: nil, action: #selector(itemClick))
        e.target = e
        e.respondClick = handler
        return e
    }
    
    public static func stackItem(_ views: QXViewProtocol...) -> QXBarButtonItem {
        return stackItem(views)
    }
    public static func stackItem(_ views: [QXViewProtocol]) -> QXBarButtonItem {
        let stack = QXStackView()
        stack.views = views
        stack.sizeToFit()
        let e = QXBarButtonItem(customView: stack)
        stack.respondNeedsLayout = { [weak stack] in
            stack?.sizeToFit()
        }
        return e
    }
    
    @objc open func itemClick() {
        respondClick?()
    }
    public var respondClick: (() -> Void)?
    
}
