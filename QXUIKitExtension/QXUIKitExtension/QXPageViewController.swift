//
//  QXPageViewController.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/12/4.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXPageViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    public var respondIndex: ((_ idx: Int) -> Void)?
    
    public let viewControllers: [UIViewController]
    
    open var currentIndex: Int {
        set {
            scrollTo(index: newValue, animated: false)
        }
        get {
            return _currentIndex
        }
    }
    
    open var enableScroll: Bool = true {
        didSet {
            for view in uiPageViewController.view.subviews {
                if let scrollView = view as? UIScrollView {
                    scrollView.isScrollEnabled = enableScroll
                }
            }
        }
    }
    
    required public init(_ viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        super.init(nibName: nil, bundle: nil)
        let vc = viewControllers[0]
        title = vc.title
        uiPageViewController.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public final lazy var uiPageViewController: UIPageViewController = {
        let one = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        one.delegate = self
        one.dataSource = self
        return one
    }()
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        for vc in viewControllers {
            if vc.isViewLoaded {
                vc.beginAppearanceTransition(false, animated: false)
                vc.viewWillDisappear(animated)
            }
        }
    }
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        for vc in viewControllers {
            if vc.isViewLoaded {
                vc.endAppearanceTransition()
                vc.viewDidDisappear(animated)
            }
        }
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(uiPageViewController.view)
        addChild(uiPageViewController)
        uiPageViewController.view.IN(view).LEFT.RIGHT.TOP.BOTTOM.MAKE()
    }
    
    private var _currentIndex: Int = 0
    public var currentVc: UIViewController! {
        return viewControllers[_currentIndex]
    }
    
    open func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if _currentIndex > 0 {
            return viewControllers[_currentIndex - 1]
        }
        return nil
    }
    open func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if _currentIndex < viewControllers.count - 1 {
            return viewControllers[_currentIndex + 1]
        }
        return nil
    }
    open func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let vc = pageViewController.viewControllers?.first {
            _currentIndex = _indexOf(viewController: vc)
            _updatePage(index: _currentIndex, vc: vc)
            title = vc.title
        }
    }
    
    private func _updatePage(index: Int, vc: UIViewController) {
        respondIndex?(index)
    }
    
}

extension QXPageViewController {
    
    /// 滚到下一个
    public func tryScrollToNext(animated: Bool) {
        if _currentIndex < viewControllers.count - 1 {
            scrollTo(index: _currentIndex + 1, animated: animated)
        }
    }
    
    /// 滚到上一个
    public func tryScrollToPrevious(animated: Bool) {
        if _currentIndex > 0 {
            scrollTo(index: _currentIndex - 1, animated: animated)
        }
    }
    
    /// 滚到某个索引
    public func scrollTo(index: Int, animated: Bool) {
        let vc = viewControllers[index]
        scrollTo(viewController: vc, animated: animated)
    }
    
    /// 滚到某个控制器
    public func scrollTo(viewController: UIViewController, animated: Bool) {
        if viewController === currentVc { return }
        let lastIdx = _indexOf(viewController: currentVc)
        let idx = _indexOf(viewController: viewController)
        let dir: UIPageViewController.NavigationDirection = idx > lastIdx ? .forward : .reverse
        UIApplication.shared.keyWindow?.isUserInteractionEnabled = false
        uiPageViewController.setViewControllers([viewController], direction: dir, animated: animated) { (c) in
            UIApplication.shared.keyWindow?.isUserInteractionEnabled = true
            self._currentIndex = idx
            self.title = viewController.title
        }
    }
    
    fileprivate func _indexOf(viewController: UIViewController) -> Int {
        for (i, vc) in viewControllers.enumerated() {
            if vc === viewController {
                return i
            }
        }
        fatalError("控制器必须是viewControllers中的一个")
    }
    
}
