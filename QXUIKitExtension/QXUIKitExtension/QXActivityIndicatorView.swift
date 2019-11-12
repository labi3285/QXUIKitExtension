//
//  QXIndicatorView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/20.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXActivityIndicatorView: QXView {
    public var systemView: UIActivityIndicatorView? {
        didSet {
            for view in subviews {
                view.removeFromSuperview()
            }
            if let view = systemView {
                addSubview(view)
            }
            qxSetNeedsLayout()
        }
    }
    public func startAnimating() {
        systemView?.startAnimating()
    }
    public func stopAnimating() {
        systemView?.stopAnimating()
    }
        
    public init(systemView: UIActivityIndicatorView) {
        self.systemView = systemView
        super.init()
        addSubview(systemView)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func natureContentSize() -> QXSize {
        if let e = systemView?.intrinsicContentSize {
            return e.qxSize.sizeByAdd(padding)
        } else {
            return QXSize.zero
        }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        systemView?.qxRect = qxBounds.rectByReduce(padding)        
    }
    
}
