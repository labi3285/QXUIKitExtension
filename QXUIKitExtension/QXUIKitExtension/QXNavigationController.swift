//
//  QXNavigationController.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/6.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXNavigationController: UINavigationController, UIGestureRecognizerDelegate, UINavigationBarDelegate, UINavigationControllerDelegate {
    
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
    
    public override init(rootViewController: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = [rootViewController]
        if let e = rootViewController as? QXViewController {
            if let bar = e.customNavigationBar {
                view.addSubview(bar)
                customNavigationBar = bar
            }
        }
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var rootViewController: QXViewController {
        if let e = viewControllers.first as? QXViewController {
            return e
        }
        return QXDebugFatalError("QXNavigationController must work with QXViewController", QXViewController())
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.delegate = self
        self.delegate = self
    }
    
    public private(set) weak var customNavigationBarBefore: QXNavigationBar?
    public private(set) weak var customNavigationBar: QXNavigationBar?
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let e = customNavigationBarBefore {
            e.intrinsicWidth = view.bounds.width
            e.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: e.qxIntrinsicContentSize.h)
        }
        if let e = customNavigationBar {
            e.intrinsicWidth = view.bounds.width
            e.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: e.qxIntrinsicContentSize.h)
        }
    }

//    open override func pushViewController(_ viewController: UIViewController, animated: Bool) {
//        performBarPushTo(viewController, animated: animated)
//        super.pushViewController(viewController, animated: animated)
//    }
//
//    open override func popViewController(animated: Bool) -> UIViewController? {
//        performBarPopTo(viewControllers[viewControllers.count - 2], animated: animated)
//        return super.popViewController(animated: animated)
//    }
//
//    open override func popToRootViewController(animated: Bool) -> [UIViewController]? {
//        performBarPopTo(rootViewController, animated: animated)
//        return super.popToRootViewController(animated: animated)
//    }
//    open override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
//        performBarPopTo(viewController, animated: animated)
//        return super.popToViewController(viewController, animated: animated)
//    }
    
    
    //MARK:- handle pop
    
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
        if (shouldPop) {
            DispatchQueue.main.async {
                _ = self.popViewController(animated: true)
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
    
    //MARK:- custom pop
    
    private func performBarPushTo(_ viewController: UIViewController, animated: Bool) {
        let toBar = (viewController as? QXViewController)?.customNavigationBar
        let nowBar = customNavigationBar
        customNavigationBarBefore = nowBar
        customNavigationBar = toBar
        for view in view.subviews {
            if view is QXNavigationBar {
                view.removeFromSuperview()
            }
        }
        if let e = nowBar {
            view.addSubview(e)
            e.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 20 + e.fixHeight)
            e.contentView.alpha = 1
        }
        if let e = toBar {
            view.addSubview(e)
            e.intrinsicWidth = view.bounds.width
            e.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: e.qxIntrinsicContentSize.h)
            e.alpha = 0
            UIView.animate(withDuration: 0.3) {
                e.alpha = 1
            }
        }
    }
    
    private func performBarPopTo(_ viewController: UIViewController, animated: Bool) {
        let toBar = (viewController as? QXViewController)?.customNavigationBar
        var barBeforeToBar: QXNavigationBar?
        guard let i = viewControllers.firstIndex(where: { $0 === viewController }) else {
            return
        }
        if i > 0 {
            if let e = viewControllers[i - 1] as? QXViewController {
                barBeforeToBar = e.customNavigationBar
            }
        }
        customNavigationBarBefore?.removeFromSuperview()
        let nowBar = customNavigationBar
        customNavigationBarBefore = barBeforeToBar
        customNavigationBar = toBar
        if let e = toBar {
            if let n = nowBar {
                view.insertSubview(e, belowSubview: n)
            } else {
                view.addSubview(e)
            }
            e.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 20 + e.fixHeight)
            e.contentView.alpha = 1
        }
        if let e = barBeforeToBar {
            if let n = toBar {
                view.insertSubview(e, belowSubview: n)
            } else {
                view.addSubview(e)
            }
            e.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 20 + e.fixHeight)
            e.contentView.alpha = 1
        }
        
        
        UIView.animate(withDuration: 0.3, animations: {
            nowBar?.alpha = 0
        }) { (c) in
            nowBar?.removeFromSuperview()
        }
    }
    
    
    //MARK:- UINavigationControllerDelegate
    
//    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//
//    }
//    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
//
//    }
//    public func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
//
//    }
//    public func navigationControllerPreferredInterfaceOrientationForPresentation(_ navigationController: UINavigationController) -> UIInterfaceOrientation {
//
//    }
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            performBarPushTo(toVC, animated: true)
        case .pop:
            performBarPopTo(toVC, animated: true)
        case .none:
            break
        @unknown default:
            break
        }
        return nil
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
