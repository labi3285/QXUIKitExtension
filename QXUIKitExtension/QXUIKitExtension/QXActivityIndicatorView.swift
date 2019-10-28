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
    
    open var margin: QXEdgeInsets = QXEdgeInsets.zero
    
    public init(systemView: UIActivityIndicatorView) {
        self.systemView = systemView
        super.init()
        addSubview(systemView)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override var intrinsicContentSize: CGSize {
        if isDisplay {
            if let e = intrinsicSize {
                return e.cgSize
            } else {
                if let e = systemView?.intrinsicContentSize {
                    return CGSize(width: margin.left + e.width + margin.right, height: margin.top + e.height + margin.bottom)
                } else {
                    return CGSize.zero
                }
            }
        } else {
            return CGSize.zero
        }
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        systemView?.frame = CGRect(x: margin.left, y: margin.top, width: bounds.width - margin.left - margin.right, height: bounds.height - margin.top - margin.bottom)
    }    
    
}
