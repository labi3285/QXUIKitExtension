//
//  QXTransition.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/11/4.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXPushTransition: NSObject {
    
    public var duration: TimeInterval = 2

    open func pushFrameAnimations(fromVc: UIViewController, toVc: UIViewController, containerView: UIView, complete: @escaping (_ finished: Bool) -> ()) {
        let w = containerView.bounds.width
        let h = containerView.bounds.height
        fromVc.view.frame = CGRect(x: 0, y: 0, width: w, height: h)
        toVc.view.frame = CGRect(x: w, y: 0, width: w, height: h)
        UIView.animate(withDuration: duration, animations: {
            fromVc.view.frame = CGRect(x: -w / 3, y: 0, width: w, height: h)
            toVc.view.frame = CGRect(x: 0, y: 0, width: w, height: h)
        }) { (c) in
           complete(c)
        }
    }
    
}
extension QXPushTransition: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromVc = transitionContext.viewController(forKey: .from)!
        let toVc = transitionContext.viewController(forKey: .to)!
        containerView.addSubview(toVc.view)
        pushFrameAnimations(fromVc: fromVc, toVc: toVc, containerView: containerView) { (c) in
            transitionContext.completeTransition(c)
        }
    }
    
}

open class QXPopTransition: NSObject {
    
    public var duration: TimeInterval = 2
    
    open func popFrameAnimations(fromVc: UIViewController, toVc: UIViewController, containerView: UIView, complete: @escaping (_ finished: Bool) -> ()) {
        let w = containerView.bounds.width
        let h = containerView.bounds.height
        toVc.view.frame = CGRect(x: -w / 3, y: 0, width: w, height: h)
        UIView.animate(withDuration: duration, animations: {
            toVc.view.frame = CGRect(x: 0, y: 0, width: w, height: h)
            fromVc.view.frame = CGRect(x: w, y: 0, width: w, height: h)
        }) { (c) in
           complete(c)
        }
    }
    public func popCancelled(fromVc: UIViewController, toVc: UIViewController, containerView: UIView) {
        let w = containerView.bounds.width
        let h = containerView.bounds.height
        toVc.view.frame = CGRect(x: -w / 3, y: 0, width: w, height: h)
        fromVc.view.frame = CGRect(x: 0, y: 0, width: w, height: h)
    }
    
}
extension QXPopTransition: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromVc = transitionContext.viewController(forKey: .from)!
        let toVc = transitionContext.viewController(forKey: .to)!
        containerView.insertSubview(toVc.view, belowSubview: fromVc.view)
        popFrameAnimations(fromVc: fromVc, toVc: toVc, containerView: containerView) { (c) in
            if transitionContext.transitionWasCancelled {
                self.popCancelled(fromVc: fromVc, toVc: toVc, containerView: containerView)
                transitionContext.completeTransition(false)
            } else {
                fromVc.view.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        }
    }
}

