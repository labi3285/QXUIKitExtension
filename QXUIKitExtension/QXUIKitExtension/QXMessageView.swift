//
//  QXMessageView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/22.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import QXMessageView

extension UIViewController {
    open func showLoading(msg: String?) {
        _ = QXMessageView.demoLoading(msg: msg, superview: view)
    }
    open func hideLoading() {
        for view in view.subviews {
            if let view = view as? QXMessageView {
                view.remove()
            }
        }
    }
    open func showSuccess(msg: String, complete: (() -> Void)? = nil) {
        QXMessageView.demoSuccess(msg: msg, superview: view, complete: complete)
    }
    open func showFailure(msg: String, complete: (() -> Void)? = nil) {
        QXMessageView.demoFailure(msg: msg, superview: view, complete: complete)
    }
    open func showWarning(msg: String, complete: (() -> Void)? = nil) {
        QXMessageView.demoWarning(msg: msg, superview: view, complete: complete)
    }
}

extension UIView {
    open func showLoading(msg: String?) {
        _ = QXMessageView.demoLoading(msg: msg, superview: self)
    }
    open func hideLoading() {
        for view in self.subviews {
            if let view = view as? QXMessageView {
                view.remove()
            }
        }
    }
    open func showSuccess(msg: String, complete: (() -> Void)? = nil) {
        QXMessageView.demoSuccess(msg: msg, superview: self, complete: complete)
    }
    open func showFailure(msg: String, complete: (() -> Void)? = nil) {
        QXMessageView.demoFailure(msg: msg, superview: self, complete: complete)
    }
    open func showWarning(msg: String, complete: (() -> Void)? = nil) {
        QXMessageView.demoWarning(msg: msg, superview: self, complete: complete)
    }
}
