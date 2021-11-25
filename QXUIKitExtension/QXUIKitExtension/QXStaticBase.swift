//
//  QXTableViewStaticCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXStaticCell: QXTableViewCell {
    
    override open var model: Any? {
        didSet {
            // 因为model是cell本身，这里防止循环引用
            super.model = nil
        }
    }
    
    open var isDisplay: Bool = true
    open var isEnabled: Bool = true

    open func height(_ model: Any?) -> CGFloat? {
        return nil
    }
    open var fixHeight: CGFloat?
    
    open override class func height(_ model: Any?, _ context: QXTableViewCell.Context) -> CGFloat? {
        if let e = model as? QXStaticCell {
            e.context = context
            return e.height(e)
        }
        return nil
    }
    
    open var canMove: Bool = false
    open var editActions: [UITableViewRowAction]?
    
    open override class func canMove(_ model: Any?, _ context: QXTableViewCell.Context) -> Bool {
        if let e = model as? QXStaticCell {
            return e.canMove
        }
        return false
    }
    
    open override class func editActions(_ model: Any?, _ context: QXTableViewCell.Context) -> [UITableViewRowAction]? {
        if let e = model as? QXStaticCell {
            return e.editActions
        }
        return nil
    }
    
    public required init() {
        super.init("static")
        backButton.isDisplay = false
        contentView.clipsToBounds = true
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public required init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }
        
}

open class QXStaticHeaderFooterView: QXTableViewHeaderFooterView {
    
    override open var model: Any? {
        didSet {
            // 因为model是view本身，这里防止循环引用
            super.model = nil
        }
    }
    
    open var isDisplay: Bool = true
    open var isEnabled: Bool = true
    
    open func height(_ model: Any?) -> CGFloat? {
        return nil
    }
    open var fixHeight: CGFloat?
    
    open override class func height(_ model: Any?, _ context: QXTableViewHeaderFooterView.Context) -> CGFloat? {
        if let e = model as? QXStaticHeaderFooterView {
            e.context = context
            return e.height(e)
        }
        return nil
    }

    public required init() {
        super.init("static")
        backButton.isDisplay = false
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public required init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }
    
}

