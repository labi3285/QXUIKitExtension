//
//  QXNavigationController.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/6.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXNavigationController: UINavigationController, UINavigationBarDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
        
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
//        if let e = rootViewController as? QXViewController {
//            if let bar = e.customNavigationBar {
//                view.addSubview(bar)
//                customNavigationBar = bar
//            }
//        }
    }
    public required init?(coder aDecoder: NSCoder) {
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
        interactivePopGestureRecognizer?.isEnabled = true
        interactivePopGestureRecognizer?.delegate = self
//        view.addGestureRecognizer(screenEdgePanGestureRecognizer)
//        screenEdgePanGestureRecognizer.delegate = self
//        self.delegate = self
    }
    
//    public final lazy var screenEdgePanGestureRecognizer: UIScreenEdgePanGestureRecognizer = {
//        let e = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleScreenEdgePanGestureRecognizer(_:)))
//        e.edges = .left
//        return e
//    }()
    
//    @objc func handleScreenEdgePanGestureRecognizer(_ recognizer: UIScreenEdgePanGestureRecognizer) {
//        guard let view = recognizer.view else {
//            return
//        }
//        if view.bounds.width < 0 {
//            return
//        }
//        var process = recognizer.translation(in: view).x / view.bounds.width
//        process = min(max(process, 0), 1)
//        switch recognizer.state {
//        case .began:
//            interactiveTransition = UIPercentDrivenInteractiveTransition()
//            _ = self.popViewController(animated: true)
//        case .changed:
//            interactiveTransition?.update(process)
//        default:
//            if (process > 0.5) {
//                interactiveTransition?.finish()
//            } else {
//                interactiveTransition?.cancel()
//                performBarPushTo(_customNavigationBarForRecover, animated: true)
//            }
//            interactiveTransition = nil
//        }
//    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if viewControllers.count == 1 {
            return false
        }
        return (topViewController as? QXViewController)?.shouldPop() ?? true
    }
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public private(set) var customNavigationBar: QXNavigationBar?
    private(set) var _customNavigationBarForRecover: QXNavigationBar?

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let e = customNavigationBar {
            e.frame = navigationBar.frame
            e.fixWidth = view.bounds.width
            e.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: e.qxIntrinsicContentSize.h)
        }
    }

//    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
//        let bar = (viewController as? QXViewController)?.customNavigationBar
//        performBarPushTo(bar, animated: animated)
//        super.pushViewController(viewController, animated: animated)
//    }
//
//    override open func popViewController(animated: Bool) -> UIViewController? {
//        let bar = (viewControllers[viewControllers.count - 2] as? QXViewController)?.customNavigationBar
//        performBarPopTo(bar, animated: animated)
//        return super.popViewController(animated: animated)
//    }
//
//    override open func popToRootViewController(animated: Bool) -> [UIViewController]? {
//        let bar = rootViewController.customNavigationBar
//        performBarPopTo(bar, animated: animated)
//        return super.popToRootViewController(animated: animated)
//    }
//    override open func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
//        let bar = (viewController as? QXViewController)?.customNavigationBar
//        performBarPopTo(bar, animated: animated)
//        return super.popToViewController(viewController, animated: animated)
//    }
    
    //MARK:- UINavigationBarDelegate
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
    
//    //MARK:- Custom push
//    private func performBarPushTo(_ bar: QXNavigationBar?, animated: Bool) {
//        let toBar = bar
//        let nowBar = customNavigationBar
//        customNavigationBar = toBar
//        for view in view.subviews {
//            if view is QXNavigationBar {
//                view.removeFromSuperview()
//            }
//        }
//        func setBar(_ bar: QXNavigationBar) {
//            view.addSubview(bar)
//            bar.fixWidth = view.bounds.width
//            bar.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: bar.intrinsicContentSize.height)
//        }
//        if let e = nowBar {
//            setBar(e)
//        }
//        if let e = toBar {
//            setBar(e)
//        }
//        nowBar?.alpha = 1
//        toBar?.alpha = 0
//        UIView.animate(withDuration: 0.3, animations: {
//            nowBar?.alpha = 0
//            toBar?.alpha = 1
//        }) { (c) in
//            nowBar?.removeFromSuperview()
//        }
//    }
//    private func performBarPopTo(_ bar: QXNavigationBar?, animated: Bool) {
//        let toBar = bar
//        let nowBar = customNavigationBar
//        customNavigationBar = toBar
//        _customNavigationBarForRecover = nowBar
//        for view in view.subviews {
//            if view is QXNavigationBar {
//                view.removeFromSuperview()
//            }
//        }
//        func setBar(_ bar: QXNavigationBar) {
//            view.addSubview(bar)
//            bar.fixWidth = view.bounds.width
//            bar.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: bar.intrinsicContentSize.height)
//        }
//        if let e = toBar {
//            setBar(e)
//        }
//        if let e = nowBar {
//            setBar(e)
//        }
//        nowBar?.alpha = 1
//        toBar?.alpha = 0
//        UIView.animate(withDuration: 0.3, animations: {
//            nowBar?.alpha = 0
//            toBar?.alpha = 1
//        }) { (c) in
//            nowBar?.removeFromSuperview()
//        }
//    }
//
//    //MARK:- UINavigationControllerDelegate
//    public private(set) var interactiveTransition: UIPercentDrivenInteractiveTransition?
//    public var pushTransition: QXPushTransition = QXPushTransition()
//    public var popTransition: QXPopTransition = QXPopTransition()
//    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        return interactiveTransition
//    }
//    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        switch operation {
//        case .push:
//            let bar = (toVC as? QXViewController)?.customNavigationBar
//            performBarPushTo(bar, animated: true)
//            return pushTransition
//        case .pop:
//            let bar = (toVC as? QXViewController)?.customNavigationBar
//            performBarPopTo(bar, animated: true)
//            return popTransition
//        default:
//            return nil
//        }
//    }
    
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
            if let e = newValue?.uiColor {
                navigationBar.backgroundColor = e
                navigationBar.barTintColor = e
            } else {
                navigationBar.backgroundColor = nil
                navigationBar.barTintColor = nil
            }
        }
        get {
            if let e = navigationBar.backgroundColor {
                return QXColor.uiColor(e)
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

