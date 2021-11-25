//
//  UIWindow_ext.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/5.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXWindow: UIWindow {
    
    public static var keyUIWindow: UIWindow? {
        return UIApplication.shared.keyWindow
    }
    public static var keyWindow: QXWindow? {
        return UIApplication.shared.keyWindow as? QXWindow
    }
    
    public init() {
        super.init(frame: UIScreen.main.bounds)
        self.qxBackgroundColor = QXColor.dynamicWhite
    }
    public init(keyWindow rootViewController: UIViewController) {
        super.init(frame: UIScreen.main.bounds)
        self.rootViewController = rootViewController
        self.qxBackgroundColor = QXColor.dynamicWhite
        self.makeKeyAndVisible()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension UIWindow {
        
    @discardableResult public static func qxInitKeyWindow(_ vc: UIViewController, _ window: inout UIWindow?) -> UIWindow {
        let win = UIWindow(frame: UIScreen.main.bounds)
        win.rootViewController = vc
        win.makeKeyAndVisible()
        window = win
        return win
    }
    
    /// 只有单normal window的情况下才可以只用这个
    public static var qxOneNormalWindow: UIWindow? {
        if let keyWindow = UIApplication.shared.keyWindow {
            if keyWindow.windowLevel == .normal {
                return keyWindow
            } else {
                for window in UIApplication.shared.windows {
                    if window.windowLevel == .normal {
                        return window
                    }
                }
            }
        }
        return nil
    }
    
    public var qxTopVc: UIViewController? {
        return rootViewController?.qxTopViewController
    }
    
}
