//
//  QXViewController.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/6.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import QXConsMaker

open class QXViewController: UIViewController, UINavigationBarDelegate {
    
    public var respondRefresh: (() -> Void)?
    
    //MARK:- Init
    public init() {
        super.init(nibName: nil, bundle: nil)
        automaticallyAdjustsScrollViewInsets = false
        edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        _ = self.view
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        QXDebugPrint("deinit")
    }
    
    override open var title: String? {
        didSet {
            super.title = title
            if _isNavigationBarInited {
                updateNavigationBar(false)
            }
        }
    }
    
    //MARK:- Data
    
    //MARK:- Life cycle
    override open func loadView() {
        super.loadView()
        view.qxBackgroundColor = QXColor.dynamicWhite
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    open func didSetup() {
        
    }
    
    open func viewWillFirstAppear(_ animated: Bool) {
        
    }
    open func viewDidFirstAppear(_ animated: Bool) {
        
    }
    open func viewWillFirstDisappear(_ animated: Bool) {
        
    }
    open func viewDidFirstDisappear(_ animated: Bool) {
        
    }
    
    public private(set) var isSetup: Bool = false
    private var _isFirstWillAppear: Bool = true
    private var _isFirstDidAppear: Bool = true
    private var _isFirstWillDisappear: Bool = true
    private var _isFirstDidDisappear: Bool = true
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !isSetup { didSetup(); isSetup = true }
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if _isFirstWillAppear { viewWillFirstAppear(animated); _isFirstWillAppear = false }
        _isNavigationBarInited = true
        updateNavigationBar(animated)
    }
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if _isFirstDidAppear { viewDidFirstAppear(animated); _isFirstDidAppear = false }
    }
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if _isFirstWillDisappear { viewWillFirstDisappear(animated); _isFirstWillDisappear = false }
    }
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if _isFirstDidDisappear { viewDidFirstDisappear(animated); _isFirstDidDisappear = false }
    }
    @objc open func applicationDidBecomeActive() {

    }
    
    //MARK:- Navigation
    
    /// 开发中
    var customNavigationBar: QXNavigationBar?
    
    public var navigationBarBackArrowImage: QXImage = QXUIKitExtensionResources.shared.image("icon_back")
        .setRenderingMode(.alwaysTemplate)
    public var navigationBarBackTitle: String?
    public var navigationBarBackFont: QXFont = QXFont(16, QXColor.dynamicAccent) {
        didSet {
            navigationItem.backBarButtonItem?
                .setTitleTextAttributes(navigationBarBackFont.nsAttributtes, for: .normal)
        }
    }
    public var navigationBarItemFont: QXFont = QXFont(16, QXColor.dynamicAccent, bold: true) {
        didSet {
            navigationItem.rightBarButtonItem?
                .setTitleTextAttributes(navigationBarItemFont.nsAttributtes, for: .normal)
        }
    }
    
    public var navigationBarLeftItem: QXBarButtonItem? {
        set {
            if let e = newValue {
                navigationBarLeftItems = [e]
            } else {
                navigationBarLeftItems = []
            }
        }
        get {
            return navigationBarLeftItems.first
        }
    }
    public var navigationBarLeftItems: [QXBarButtonItem] {
        set {
            for e in newValue {
                e.setTitleTextAttributes(navigationBarItemFont.nsAttributtes, for: .normal)
            }
            navigationItem.leftBarButtonItems = newValue.reversed()
        }
        get {
            return navigationItem.leftBarButtonItems as? [QXBarButtonItem] ?? []
        }
    }

    public var navigationBarRightItem: QXBarButtonItem? {
        set {
            if let e = newValue {
                navigationBarRightItems = [e]
            } else {
                navigationBarRightItems = []
            }
        }
        get {
            return navigationBarRightItems.first
        }
    }
    public var navigationBarRightItems: [QXBarButtonItem] {
        set {
            for e in newValue {
                e.setTitleTextAttributes(navigationBarItemFont.nsAttributtes, for: .normal)
            }
            navigationItem.rightBarButtonItems = newValue.reversed()
        }
        get {
            return navigationItem.rightBarButtonItems as? [QXBarButtonItem] ?? []
        }
    }
    
    
    public var navigationBarTitle: String? { didSet { if _isNavigationBarInited { updateNavigationBar(false) } } }
    public var navigationBarTitleFont: QXFont = QXFont(16, QXColor.dynamicTitle)
        { didSet { if _isNavigationBarInited { updateNavigationBar(false) } } }
    public var navigationBarTitleView: QXView? { didSet { if _isNavigationBarInited { updateNavigationBar(false) } } }
    public var navigationBarTintColor: QXColor = QXColor.dynamicAccent
        { didSet { if _isNavigationBarInited { updateNavigationBar(false) } } }
    
    public var navigationBarBackgroundColor: QXColor = QXColor.dynamicBar
        { didSet { if _isNavigationBarInited { updateNavigationBar(false) } } }
    public var navigationBarBackgroundImage: QXImage?
        { didSet { if _isNavigationBarInited { updateNavigationBar(false) } } }
    public var isNavigationBarLineShow: Bool = true
        { didSet { if _isNavigationBarInited { updateNavigationBar(false) } } }
    public var isNavigationBarTransparent: Bool = false
        { didSet { if _isNavigationBarInited { updateNavigationBar(false) } } }

    public var isNavigationBarShow: Bool = true { didSet { if _isNavigationBarInited { updateNavigationBar(false) } } }
    
    open func shouldPop() -> Bool {
        return true
    }
    open func shouldDismiss() -> Bool {
        return true
    }
    
    open func updateAppearance() {
        
    }
    
    //MARK:- Present
    // nil 表示不显示
    public var isNavigationBarAutoDismissItemAtLeft: Bool? = true { didSet { if _isNavigationBarInited { updateNavigationBar(false) } } }
    public var navigationBarAutoDismissImage: QXImage?
        { didSet { if _isNavigationBarInited { updateNavigationBar(false) } } }
    public var navigationBarAutoDismissTitle: String? = "取消"
        { didSet { if _isNavigationBarInited { updateNavigationBar(false) } } }
    public var navigationBarAutoDismissFont: QXFont?
        { didSet { if _isNavigationBarInited { updateNavigationBar(false) } } }
    
    public private(set) weak var viewControllerBefore: QXViewController?
        
    public func push(_ vc: QXViewController, animated: Bool = true, file: StaticString = #file, line: UInt = #line) {
        if let nav = navigationController {
            var next: UIViewController = self
            while let e = next.parent, (!(e is UINavigationController) && !(e is UITabBarController)) {
                next = next.parent!
            }
            let fromVc = next as? QXViewController ?? self
            if let navBar = vc.customNavigationBar {
                navBar.qxTintColor = vc.navigationBarTintColor
                if let button = navBar.autoCheckOrSetBackButton(image: vc.navigationBarBackArrowImage, title: vc.navigationBarBackTitle ?? fromVc.navigationBarTitle ?? fromVc.title, font: vc.navigationBarBackFont) {
                    button.respondClick = { [weak vc] in
                        if let e = vc {
                            if e.shouldPop() {
                                e.pop()
                            }
                        }
                    }
                }
            }
            if let t = vc.navigationBarBackTitle ?? fromVc.navigationBarTitle ?? fromVc.title {
                let e = QXBarButtonItem.backItem(t)
                let font = vc.navigationBarBackFont
                e.setTitleTextAttributes(font.nsAttributtes, for: .normal)
                fromVc.navigationItem.backBarButtonItem = e
            } else {
                fromVc.navigationItem.backBarButtonItem = nil
            }
            navigationController?.navigationBar.backIndicatorImage = vc.navigationBarBackArrowImage.uiImage
            navigationController?.navigationBar.backIndicatorTransitionMaskImage = vc.navigationBarBackArrowImage.uiImage
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
    public func present(_ vc: UIViewController, animated: Bool = true) {
        super.present(vc, animated: animated)
    }
    public func dismiss() {
        super.dismiss(animated: true, completion: nil)
    }
    public func dismiss(animated: Bool) {
        super.dismiss(animated: animated, completion: nil)
    }
    public func dismiss(completion: @escaping (() -> Void)) {
        super.dismiss(animated: true, completion: completion)
    }
    
    public func updateNavigationBar(_ animated: Bool) {
        if let vc = parent {
            if !vc.isKind(of: UINavigationController.self) && !vc.isKind(of: UITabBarController.self) {
                return
            }
        }
        if let navBar = customNavigationBar {
            navigationController?.setNavigationBarHidden(true, animated: animated)
            navBar.qxTintColor = navigationBarTintColor
            if let e = navigationBarTitleView {
                navBar.titleView = e
            } else {
                _ = navBar.autoCheckOrSetTitleView(title: navigationBarTitle ?? title, font:  navigationBarTitleFont)
            }
            if let e = navigationBarBackgroundImage {
                navBar.layer.contents = e.uiImage?.cgImage
            } else {
                navBar.qxBackgroundColor = navigationBarBackgroundColor
            }
            if isNavigationBarLineShow {
                if navBar.lineView == nil {
                    navBar.lineView = QXLineView.breakLine
                }
            } else {
                navBar.lineView = nil
            }
            
            if navigationItem.leftBarButtonItem == nil
                && navigationItem.leftBarButtonItems == nil
                && presentingViewController != nil
                && isNavigationRootViewController {
                navBar.isDismissAtLeft = true
                if let button = navBar.autoCheckOrSetDismissButton(image: navigationBarAutoDismissImage, title: navigationBarAutoDismissTitle, font: navigationBarAutoDismissFont ?? QXFont(16, navigationBarTintColor)) {
                    button.respondClick = { [weak self] in
                        if let s = self {
                            if s.shouldDismiss() {
                                s.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
            navBar.qxSetNeedsLayout()
            
        } else {
            navigationController?.setNavigationBarHidden(!isNavigationBarShow, animated: animated)
            if let e = navigationBarTitleView {
                navigationItem.titleView = e
            } else {
                if let e = navigationBarTitle ?? title {
                    let label = UILabel()
                    label.qxFont = navigationBarTitleFont
                    label.qxText = e
                    label.HEIGHT.EQUAL(44).MAKE()
                    navigationItem.titleView = label
                } else {
                    navigationItem.title = title
                }
            }
            navigationController?.navigationBar.tintColor = navigationBarTintColor.uiColor
            if let e = navigationBarBackgroundImage {
                navigationController?.qxNavigationBackgroundImage = e
            } else {
                navigationController?.qxNavigationBackgroundColor = navigationBarBackgroundColor
            }
            navigationController?.qxIsShadowed = isNavigationBarLineShow
            if isNavigationBarTransparent {
                navigationController?.qxNavigationBackgroundImage = QXImage(QXColor.clear)
            }
            if presentingViewController != nil && isNavigationRootViewController {
                if navigationItem.leftBarButtonItem == nil && navigationItem.leftBarButtonItems == nil {
                    if let image = navigationBarAutoDismissImage, let title = navigationBarAutoDismissTitle {
                        let btn = QXStackButton()
                        btn.minHeight = 35
                        let imageView = QXImageView()
                        imageView.image = image
                        let label = QXLabel()
                        label.font = navigationBarAutoDismissFont ?? QXFont(16, navigationBarTintColor)
                        label.text = title
                        btn.views = [imageView, label]
                        btn.sizeToFit()
                        let item = QXBarButtonItem(customView: btn)
                        btn.respondClick = { [weak self] in
                            if let s = self {
                                if s.shouldDismiss() {
                                    s.dismiss(animated: true, completion: nil)
                                }
                            }
                        }
                        navigationItem.leftBarButtonItem = item
                    } else if let title = navigationBarAutoDismissTitle {
                        let btn = QXTitleButton()
                        btn.minHeight = 35
                        btn.font = navigationBarAutoDismissFont ?? QXFont(16, navigationBarTintColor)
                        btn.title = title
                        btn.sizeToFit()
                        let item = QXBarButtonItem(customView: btn)
                        btn.respondClick = { [weak self] in
                            self?.dismiss(animated: true, completion: nil)
                        }
                        navigationItem.leftBarButtonItem = item
                    } else if let image = navigationBarAutoDismissImage {
                        let btn = QXImageButton()
                        btn.image = image
                        btn.sizeToFit()
                        let item = QXBarButtonItem(customView: btn)
                        btn.respondClick = { [weak self] in
                            self?.dismiss(animated: true, completion: nil)
                        }
                        navigationItem.leftBarButtonItem = item
                    }
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


