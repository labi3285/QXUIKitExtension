//
//  QXNavigationController.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/6.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXNavigationController: UINavigationController, UIGestureRecognizerDelegate, UINavigationBarDelegate {
    
    public var tabBarTitle: String? {
        didSet {
            tabBarItem.title = tabBarTitle
        }
    }
    public var tabBarIcon: QXImage? {
        didSet {
            tabBarItem.image = tabBarIcon?.uiImage
        }
    }
    public var tabBarSelectIcon: QXImage? {
        didSet {
            tabBarItem.selectedImage = tabBarSelectIcon?.uiImage
        }
    }
    
    public var rootViewController: QXViewController {
        if let e = viewControllers.first as? QXViewController {
            return e
        }
        return QXDebugFatalError("QXNavigationController must work with QXViewController", QXViewController())
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        if self.responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            self.interactivePopGestureRecognizer?.delegate = self
        }
        navigationBar.addSubview(customNavigationBar)
    }
    
    lazy var customNavigationBar: QXView = {
        let one = QXView()
        one.backgroundColor = UIColor.red
        return one
    }()
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationBar.frame = CGRect(x: 0, y: 100, width: 300, height: 44)
//        customNavigationBar.frame = navigationBar.bounds
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let vc = viewControllers.last as? QXViewController {
            return vc.shouldPop()
        }
        return viewControllers.count > 1
    }
    
    public func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        if viewControllers.count < (navigationBar.items?.count ?? 0) {
            return true
        }
        var shouldPop = true;
        if let vc = topViewController as? QXViewController {
            shouldPop = vc.shouldPop()
        }
        if(shouldPop) {
            DispatchQueue.main.async {
                self.popViewController(animated: true)
            }
        } else {
            for e in navigationBar.subviews {
                if 0 < e.alpha && e.alpha < 1 {
                    UIView.animate(withDuration: 0.25) {
                        e.alpha = 1
                    }
                }
            }
        }
        return false
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
