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
    func showLoading(msg: String?) {
        _ = QXMessageView.demoLoading(msg: msg, superview: view)
    }
    func hideLoading() {
        for view in view.subviews {
            if let view = view as? QXMessageView {
                view.remove()
            }
        }
    }
    func showSuccess(msg: String, complete: (() -> ())? = nil) {
        QXMessageView.demoSuccess(msg: msg, superview: view, complete: complete)
    }
    func showFailure(msg: String, complete: (() -> ())? = nil) {
        QXMessageView.demoFailure(msg: msg, superview: view, complete: complete)
    }
    func showWarning(msg: String, complete: (() -> ())? = nil) {
        QXMessageView.demoWarning(msg: msg, superview: view, complete: complete)
    }
}

extension UIView {
    func showLoading(msg: String?) {
        _ = QXMessageView.demoLoading(msg: msg, superview: self)
    }
    func hideLoading() {
        for view in self.subviews {
            if let view = view as? QXMessageView {
                view.remove()
            }
        }
    }
    func showSuccess(msg: String, complete: (() -> ())? = nil) {
        QXMessageView.demoSuccess(msg: msg, superview: self, complete: complete)
    }
    func showFailure(msg: String, complete: (() -> ())? = nil) {
        QXMessageView.demoFailure(msg: msg, superview: self, complete: complete)
    }
    func showWarning(msg: String, complete: (() -> ())? = nil) {
        QXMessageView.demoWarning(msg: msg, superview: self, complete: complete)
    }
}
