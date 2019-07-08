//
//  QXNavigationController.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/6.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

public class QXNavigationController: UINavigationController {
    
    public required init(rootVc: QXViewController) {
        super.init(rootViewController: rootVc)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UINavigationController {
    
    public var qxNavigationBackgroundImage: QXImage? {
        set {
            if let e = newValue?.uiImage {
                navigationBar.setBackgroundImage(e, for: UIBarMetrics.default)
            } else {
                navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
            }
        }
        get {
            if let e = navigationBar.backgroundImage(for: UIBarMetrics.default) {
                return QXImage(e)
            }
            return nil
        }
    }
    
    public var qxNavigationBackgroundColor: QXColor? {
        set {
            if let e = newValue?.uiImage {
                navigationBar.setBackgroundImage(e, for: UIBarMetrics.default)
            } else {
                navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
            }
        }
        get {
            if let e = navigationBar.backgroundImage(for: UIBarMetrics.default) {
                return QXColor.image(QXImage(e))
            }
            return nil
        }
    }
    
    public var qxIsShadowed: Bool {
        set {
            if newValue {
                navigationBar.shadowImage = nil
            } else {
                navigationBar.shadowImage = UIImage()
            }
        }
        get {
            return navigationBar.shadowImage == nil
        }
    }
    
    public func qxRemoveViewController(_ vc: UIViewController) {
        if let i = viewControllers.lastIndex(where: { $0 === vc }) {
            viewControllers.remove(at: i)
        }
    }
    public func qxRemoveViewController(_ indexBackward: Int, file: StaticString = #file, line: UInt = #line) {
        let i = viewControllers.count - 1 - indexBackward
        if i >= 0 && i < viewControllers.count {
            viewControllers.remove(at: i)
        } else {
            QXDebugFatalError("index out of range", file: file, line: line)
        }
    }
    
}
