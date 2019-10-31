//
//  QXTableViewStaticCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXStaticBaseCell: QXTableViewCell {
    
    open override var model: Any? {
        didSet {
            // 因为model是cell本身，这里防止循环引用
            super.model = nil
        }
    }
    
    open func height(_ model: Any?, _ width: CGFloat) -> CGFloat? {
        return fixHeight
    }
    open var fixHeight: CGFloat?
    
    open override class func height(_ model: Any?, _ width: CGFloat) -> CGFloat? {
        if let e = model as? QXStaticBaseCell {
            return e.height(model, width)
        }
        return nil
    }
    
    required public init() {
        super.init("static")
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    required public init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }
    
}

open class QXStaticBaseHeaderFooterView: QXTableViewHeaderFooterView {
    
    open override var model: Any? {
        didSet {
            // 因为model是view本身，这里防止循环引用
            super.model = nil
        }
    }
    
    open func height(_ model: Any?, _ width: CGFloat) -> CGFloat? {
        return fixHeight
    }
    open var fixHeight: CGFloat?
    
    open override class func height(_ model: Any?, _ width: CGFloat) -> CGFloat? {
        if let e = model as? QXStaticBaseHeaderFooterView {
            return e.height(model, width)
        }
        return nil
    }
    
    required public init() {
        super.init("static")
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    required public init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }
    
}

