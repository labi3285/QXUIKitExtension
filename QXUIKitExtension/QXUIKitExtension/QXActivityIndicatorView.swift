//
//  QXIndicatorView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/20.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXActivityIndicatorView: QXView {
    
    public private(set) var systemView: UIActivityIndicatorView?
    public func startAnimating() {
        systemView?.startAnimating()
    }
    public func stopAnimating() {
        systemView?.stopAnimating()
    }
        
    public override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        updateIndicatorView()
    }
    @objc func applicationDidBecomeActive() {
        DispatchQueue.main.qxAsyncWait(0.2) {
            self.updateIndicatorView()
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    public func updateIndicatorView() {
        if #available(iOS 13.0, *) {
            switch UITraitCollection.current.userInterfaceStyle {
            case .dark:
                systemView = UIActivityIndicatorView(style: .white)
            default:
                systemView = UIActivityIndicatorView(style: .gray)
            }
        } else {
            systemView = UIActivityIndicatorView(style: .gray)
        }
        for view in subviews {
            view.removeFromSuperview()
        }
        if let e = systemView {
            addSubview(e)
        }
        qxSetNeedsLayout()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func natureContentSize() -> QXSize {
        if let e = systemView?.intrinsicContentSize {
            return e.qxSize.sizeByAdd(padding)
        }
        return QXSize.zero
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        systemView?.qxRect = qxBounds.rectByReduce(padding)
    }
    
}
