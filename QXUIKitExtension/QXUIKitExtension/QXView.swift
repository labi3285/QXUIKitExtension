//
//  QXView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/20.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXView: UIView {
    
    open var padding: QXEdgeInsets = QXEdgeInsets.zero
    
    public init() {
        super.init(frame: CGRect.zero)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 是否显示（影响布局）
    public var isDisplay: Bool = true {
        didSet {
            isHidden = !isDisplay
        }
    }
    
    public var respondResize: (() -> ())?
    
    open override func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()
        respondResize?()
    }
    
    public var intrinsicSize: QXSize? {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        if isDisplay {
            if let e = intrinsicSize {
                return e.cgSize
            } else {
                return CGSize.zero
            }
        }
        return CGSize.zero
    }
    
    open override func sizeToFit() {
        let wh = intrinsicContentSize
        frame = CGRect(x: frame.minX, y: frame.minY, width: wh.width, height: wh.height)
    }
    
}


extension UIView {
    
    public func qxSetNeedsLayout() {
        invalidateIntrinsicContentSize()
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    public var qxIntrinsicContentSize: QXSize{
        return intrinsicContentSize.qxSize
    }
    
    public func qxCheckOrAddSubview(_ view: UIView) {
        if let superview = view.superview {
            if superview === self {
                superview.bringSubviewToFront(view)
            } else {
                view.removeFromSuperview()
                addSubview(view)
            }
        } else {
            addSubview(view)
        }
    }
    
    public func qxCheckOrRemoveFromSuperview() {
        if superview != nil {
           removeFromSuperview()
        }
    }
    
}
