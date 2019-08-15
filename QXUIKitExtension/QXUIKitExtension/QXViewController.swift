//
//  QXViewController.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/6.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

extension UIViewController {
  
    
}

open class QXViewController: UIViewController {
    
    public var respondRefresh: (() -> ())?
    
    public var padding: QXPadding = QXPadding.zero
    public lazy var contentView: QXView = {
        let one = QXView()
        return one
    }()

    //MARK:- Init
    required public init() {
        super.init(nibName: nil, bundle: nil)
        // make sure view init at start
        _ = view
        automaticallyAdjustsScrollViewInsets = false
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        QXDebugPrint("deinit")
    }
    
    open override var title: String? {
        didSet {
            super.title = title
            self.navigationBarTitle = title
            if _isNavigationBarInited {
                updateNavigationBar()
            }
        }
    }
    
    //MARK:- Data
    
    //MARK:- Life cycle
    open override func loadView() {
        super.loadView()
        view.addSubview(contentView)
        
    }
    
    open func viewWillFirstAppear(_ animated: Bool) {
        
    }
    open func viewDidFirstAppear(_ animated: Bool) {
        
    }
    open func viewWillFirstDisappear(_ animated: Bool) {
        
    }
    open func viewDidFirstDisappear(_ animated: Bool) {
        
    }
    
    private var _isFirstWillAppear: Bool = true
    private var _isFirstDidAppear: Bool = true
    private var _isFirstWillDisappear: Bool = true
    private var _isFirstDidDisappear: Bool = true

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if _isFirstWillAppear { viewWillFirstAppear(animated); _isFirstWillAppear = false }
        _isNavigationBarInited = true
        updateNavigationBar()
    }
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if _isFirstDidAppear { viewDidFirstAppear(animated); _isFirstDidAppear = false }
    }
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if _isFirstWillDisappear { viewWillFirstDisappear(animated); _isFirstWillDisappear = false }
    }
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if _isFirstDidDisappear { viewDidFirstDisappear(animated); _isFirstDidDisappear = false }
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentView.frame = CGRect(x: padding.left, y: padding.top, width: view.frame.width - padding.left - padding.right, height: view.frame.height - padding.top - padding.bottom)
    }
    
    //MARK:- Navigation
    public var navigationBarBackArrowImage: QXImage? { didSet { if _isNavigationBarInited { updateNavigationBar() } } }
    public var navigationBarBackItem: QXBarButtonItem? { didSet { if _isNavigationBarInited { updateNavigationBar() } } }
    
    public var navigationBarTitle: String? { didSet { if _isNavigationBarInited { updateNavigationBar() } } }
    public var navigationBarTitleFont: QXFont? { didSet { if _isNavigationBarInited { updateNavigationBar() } } }
    public var navigationBarTitleView: UIView? { didSet { if _isNavigationBarInited { updateNavigationBar() } } }
    public var navigationBarTintColor: QXColor? { didSet { if _isNavigationBarInited { updateNavigationBar() } } }
    
    public var navigationBarBackgroundColor: QXColor? { didSet { if _isNavigationBarInited { updateNavigationBar() } } }
    public var navigationBarBackgroundImage: QXImage? { didSet { if _isNavigationBarInited { updateNavigationBar() } } }
    public var isNavigationBarLineShow: Bool? { didSet { if _isNavigationBarInited { updateNavigationBar() } } }
    public var isNavigationBarTransparent: Bool? { didSet { if _isNavigationBarInited { updateNavigationBar() } } }

    public var isNavigationBarShow: Bool = true { didSet { if _isNavigationBarInited { updateNavigationBar() } } }
    
    //MARK:- Present
    public var isNavigationBarAutoDismissItemAtLeft: Bool = true { didSet { if _isNavigationBarInited { updateNavigationBar() } } }
    public var navigationBarAutoDismissItem: QXBarButtonItem? = QXBarButtonItem.titleItem(title: "取消", styles: nil) { didSet { if _isNavigationBarInited { updateNavigationBar() } } }
    
    public private(set) weak var viewControllerBefore: QXViewController?
        
    public func push(_ vc: QXViewController, animated: Bool = true, file: StaticString = #file, line: UInt = #line) {
        if let nav = navigationController {
            navigationItem.backBarButtonItem = vc.navigationBarBackItem
            navigationController?.navigationBar.backIndicatorImage = vc.navigationBarBackArrowImage?.uiImage
            navigationController?.navigationBar.backIndicatorTransitionMaskImage = vc.navigationBarBackArrowImage?.uiImage
            vc.hidesBottomBarWhenPushed = true
            vc.viewControllerBefore = self
            nav.pushViewController(vc, animated: animated)
        } else {
            QXDebugFatalError("vc is not in UINavigationController", file: file, line: line)
        }
    }
    public func pop(animated: Bool = true, file: StaticString = #file, line: UInt = #line) {
        if let nav = navigationController {
            nav.popViewController(animated: animated)
        } else {
            QXDebugFatalError("vc is not in UINavigationController", file: file, line: line)
        }
    }
    public func popTo(_ vc: QXViewController, animated: Bool = true, file: StaticString = #file, line: UInt = #line) {
        if let nav = navigationController {
            nav.popToViewController(vc, animated: animated)
        } else {
            QXDebugFatalError("vc is not in UINavigationController", file: file, line: line)
        }
    }
    public func popToRoot(animated: Bool = true, file: StaticString = #file, line: UInt = #line) {
        if let nav = navigationController {
            nav.popToRootViewController(animated: animated)
        } else {
            QXDebugFatalError("vc is not in UINavigationController", file: file, line: line)
        }
    }
    
    public func present(_ vc: QXNavigationController, animated: Bool = true) {
        super.present(vc, animated: animated)
    }
    
    public func updateNavigationBar() {
        if isNavigationRootViewController {
            if navigationBarTintColor == nil {
                navigationBarTintColor = QXColor.hex("#333333", 1)
            }
            if navigationBarTitleFont == nil {
                navigationBarTitleFont = QXFont(size: 15, color: navigationBarTintColor ?? QXColor.hex("#333333", 1))
            }
            if navigationBarBackgroundColor == nil {
                navigationBarBackgroundColor = QXColor.white
            }
            if isNavigationBarLineShow == nil {
                isNavigationBarLineShow = true
            }
            if isNavigationBarTransparent == nil {
                isNavigationBarTransparent = false
            }
        }
        if let e = navigationBarTitleView {
            navigationItem.titleView = e
        } else {
            if let e = navigationBarTitle ?? title {
                let label = UILabel()
                if let f = navigationBarTitleFont {
                    label.qxFont = f
                } else {
                    label.qxFont = QXFont(size: 15, color: navigationBarTintColor ?? QXColor.black)
                }
                label.qxText = e
                label.HEIGHT.EQUAL(44).MAKE()
                navigationItem.titleView = label
            } else {
                navigationItem.title = title
            }
        }
        if let e = navigationBarTintColor {
            navigationController?.navigationBar.tintColor = e.uiColor
        }
        if let e = navigationBarBackgroundImage {
            navigationController?.qxNavigationBackgroundImage = e
        } else if let e = navigationBarBackgroundColor {
            navigationController?.qxNavigationBackgroundColor = e
        }
        if let e = isNavigationBarLineShow {
            navigationController?.qxIsShadowed = e
        }
        navigationController?.setNavigationBarHidden(!isNavigationBarShow, animated: false)
        if let e = isNavigationBarTransparent, e == true {
            navigationController?.qxNavigationBackgroundImage = QXImage(QXColor.clear)
        }
        if presentingViewController != nil && isNavigationRootViewController {
            if let e = navigationBarAutoDismissItem {
                if e.respondClick == nil {
                    e.respondClick = { [weak self] in
                        self?.dismiss(animated: true, completion: nil)
                    }
                }
                if isNavigationBarAutoDismissItemAtLeft {
                    navigationItem.leftBarButtonItem = e
                } else {
                    navigationItem.rightBarButtonItem = e
                }
            }
        }
    }
    private var _isNavigationBarInited: Bool = false
        
    //MARK:- Other
    public var topViewController: UIViewController? { return qxTopViewController }
    public var isNavigationRootViewController: Bool { return qxIsNavigationRootViewController }
    
}

extension UIViewController {
    
    public var qxTopViewController: UIViewController? {
        if let vc = self as? UITabBarController {
            return vc.selectedViewController?.qxTopViewController
        } else if let vc = self as? UINavigationController {
            return vc.visibleViewController?.qxTopViewController
        } else if let vc = self.presentedViewController {
            return vc.qxTopViewController
        }
        return self
    }
    
    public var qxIsNavigationRootViewController: Bool {
        if let vc = navigationController?.viewControllers.first {
            if vc === self {
                return true
            }
        }
        return false
    }
    
}
