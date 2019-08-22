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
        if let e = self as? QXViewController {
            QXMessageView.demoSuccess(msg: msg, superview: e.contentView, complete: complete)
        } else {
            QXMessageView.demoSuccess(msg: msg, superview: view, complete: complete)
        }
    }
    func showFailure(msg: String, complete: (() -> ())? = nil) {
        if let e = self as? QXViewController {
            QXMessageView.demoFailure(msg: msg, superview: e.contentView, complete: complete)
        } else {
            QXMessageView.demoFailure(msg: msg, superview: view, complete: complete)
        }
    }
    func showWarning(msg: String, complete: (() -> ())? = nil) {
        if let e = self as? QXViewController {
            QXMessageView.demoWarning(msg: msg, superview: e.contentView, complete: complete)
        } else {
            QXMessageView.demoWarning(msg: msg, superview: view, complete: complete)
        }
    }
}
