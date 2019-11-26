//
//  QXMaskViewController.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/11/4.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXMaskViewController: UIViewController {
    
    public var isDismissOnTapCover: Bool = true
    
    public final lazy var coverButton: UIButton = {
        let e = UIButton()
        e.backgroundColor = UIColor(white: 0, alpha: 0.3)
        e.addTarget(self, action: #selector(coverButtonClick), for: .touchUpInside)
        return e
    }()
    @objc func coverButtonClick() {
        if isDismissOnTapCover {
            dismiss(animated: true, completion: nil)
        }
    }
    
    private var isPresent: Bool = true
    public required init() {
        super.init(nibName: nil, bundle: nil)
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }

    open func viewRect(_ containerBounds: QXRect) -> QXRect {
        let h = containerBounds.h - QXDevice.statusBarHeight - 20 - 20
        let top = QXDevice.statusBarHeight + 20
        return containerBounds.insideRect(.left(20), .right(20), .top(top), .height(h))
    }
    open func viewRectBeforeShow(_ containerBounds: QXRect) -> QXRect {
        let h = containerBounds.h - QXDevice.statusBarHeight - 20 - 20
        let top = containerBounds.h
        return containerBounds.insideRect(.left(20), .right(20), .top(top), .height(h))
    }
    open func presentDuration() -> TimeInterval {
        return 0.3
    }
    open func dismissDuration() -> TimeInterval {
        return 0.3
    }
    open func presentAnimation(_ duration: TimeInterval, animations: @escaping () -> (), completion: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 1, options: .curveLinear, animations: animations, completion: completion)
    }
    open func dismissAnimation(_ duration: TimeInterval, animations: @escaping () -> (), completion: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: animations, completion: completion)
    }
    
}

extension QXMaskViewController: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresent = true
        return self
    }
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresent = false
        return self
    }
    
}

extension QXMaskViewController: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if isPresent {
            return presentDuration()
        } else {
            return dismissDuration()
        }
    }
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromVc = transitionContext.viewController(forKey: .from)!
        let toVc = transitionContext.viewController(forKey: .to)!
        if isPresent {
            containerView.addSubview(coverButton)
            coverButton.frame = containerView.bounds
            containerView.addSubview(toVc.view)
            toVc.view.qxRect = viewRectBeforeShow(containerView.qxBounds)
            coverButton.alpha = 0
            presentAnimation(presentDuration(), animations: {
                toVc.view.qxRect = self.viewRect(containerView.qxBounds)
                self.coverButton.alpha = 1
            }) { (c) in
                transitionContext.completeTransition(c)
            }
        } else {
            dismissAnimation(dismissDuration(), animations: {
                fromVc.view.qxRect = self.viewRectBeforeShow(containerView.qxBounds)
                self.coverButton.alpha = 0
            }) { (c) in
                self.coverButton.removeFromSuperview()
                fromVc.view.removeFromSuperview()
                transitionContext.completeTransition(c)
            }
        }
    }
    
}
