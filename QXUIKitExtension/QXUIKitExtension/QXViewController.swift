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
    
    public var respondRefresh: (() -> ())?
    
    //MARK:- Init
    required public init() {
        super.init(nibName: nil, bundle: nil)
        // make sure view init at start
        _ = view
        automaticallyAdjustsScrollViewInsets = false
        edgesForExtendedLayout = UIRectEdge(rawValue: 0)
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
            if _isNavigationBarInited {
                updateNavigationBar()
            }
        }
    }
    
    //MARK:- Data
    
    //MARK:- Life cycle
    open override func loadView() {
        super.loadView()
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
    
    //MARK:- Navigation
    public var customNavigationBar: QXNavigationBar?
    
    public var navigationBarBackArrowImage: QXImage? = QXUIKitExtensionResources.shared.image("icon_back")
        .setRenderingMode(.alwaysTemplate)
    public var navigationBarBackTitle: String?
    public var navigationBarBackFont: QXFont?

    public var navigationBarTitle: String? { didSet { if _isNavigationBarInited { updateNavigationBar() } } }
    public var navigationBarTitleFont: QXFont? { didSet { if _isNavigationBarInited { updateNavigationBar() } } }
    public var navigationBarTitleView: QXView? { didSet { if _isNavigationBarInited { updateNavigationBar() } } }
    public var navigationBarTintColor: QXColor = QXColor.hex("#333333", 1)
        { didSet { if _isNavigationBarInited { updateNavigationBar() } } }
    
    public var navigationBarBackgroundColor: QXColor = QXColor.white
        { didSet { if _isNavigationBarInited { updateNavigationBar() } } }
    public var navigationBarBackgroundImage: QXImage?
        { didSet { if _isNavigationBarInited { updateNavigationBar() } } }
    public var isNavigationBarLineShow: Bool = true
        { didSet { if _isNavigationBarInited { updateNavigationBar() } } }
    public var isNavigationBarTransparent: Bool = false
        { didSet { if _isNavigationBarInited { updateNavigationBar() } } }

    public var isNavigationBarShow: Bool = true { didSet { if _isNavigationBarInited { updateNavigationBar() } } }
    
    open func shouldPop() -> Bool {
        return true
    }
    open func shouldDismiss() -> Bool {
        return true
    }
    
    //MARK:- Present
    // nil 表示不显示
    public var isNavigationBarAutoDismissItemAtLeft: Bool? = true { didSet { if _isNavigationBarInited { updateNavigationBar() } } }
    public var navigationBarAutoDismissImage: QXImage?
        { didSet { if _isNavigationBarInited { updateNavigationBar() } } }
    public var navigationBarAutoDismissTitle: String? = "取消"
        { didSet { if _isNavigationBarInited { updateNavigationBar() } } }
    public var navigationBarAutoDismissFont: QXFont?
        { didSet { if _isNavigationBarInited { updateNavigationBar() } } }
    
    public private(set) weak var viewControllerBefore: QXViewController?
        
    public func push(_ vc: QXViewController, animated: Bool = true, file: StaticString = #file, line: UInt = #line) {
        if let nav = navigationController {
            if let navBar = vc.customNavigationBar {
                navBar.qxTintColor = vc.navigationBarTintColor
                if let button = navBar.autoCheckOrSetBackButton(image: vc.navigationBarBackArrowImage, title: vc.navigationBarBackTitle ?? navigationBarTitle ?? title, font: navigationBarBackFont ?? QXFont.init(size: 16, color: navigationBarTintColor)) {
                    button.respondClick = { [weak vc] in
                        if let e = vc {
                            if e.shouldPop() {
                                e.pop()
                            }
                        }
                    }
                }
            }
            if let t = vc.navigationBarBackTitle ?? navigationBarTitle ?? title {
                navigationItem.backBarButtonItem = QXBarButtonItem.backItem(title: t, styles: QXControlStateStyles(font: navigationBarBackFont ?? QXFont.init(size: 17, color: navigationBarTintColor)))
            } else {
                navigationItem.backBarButtonItem = nil
            }
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
        if let navBar = customNavigationBar {
            navigationController?.setNavigationBarHidden(true, animated: true)
            navBar.qxTintColor = navigationBarTintColor
            if let e = navigationBarTitleView {
                navBar.titleView = e
            } else {
                _ = navBar.autoCheckOrSetTitleView(title: navigationBarTitle ?? title, font:  navigationBarTitleFont ?? QXFont(size: 15, color: navigationBarTintColor))
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
            
            if let isLeft = isNavigationBarAutoDismissItemAtLeft, presentingViewController != nil, isNavigationRootViewController {
                navBar.isDismissAtLeft = isLeft
                if let button = navBar.autoCheckOrSetDismissButton(image: navigationBarAutoDismissImage, title: navigationBarAutoDismissTitle, font: navigationBarAutoDismissFont ?? QXFont.init(size: 16, color: navigationBarTintColor)) {
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
            navigationController?.setNavigationBarHidden(!isNavigationBarShow, animated: false)
            if let e = navigationBarTitleView {
                navigationItem.titleView = e
            } else {
                if let e = navigationBarTitle ?? title {
                    let label = UILabel()
                    if let f = navigationBarTitleFont {
                        label.qxFont = f
                    } else {
                        label.qxFont = QXFont(size: 15, color: navigationBarTintColor)
                    }
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
                if let isLeft = isNavigationBarAutoDismissItemAtLeft {
                    if let image = navigationBarAutoDismissImage, let title = navigationBarAutoDismissTitle {
                        let btn = QXStackButton()
                        btn.intrinsicMinHeight = 35
                        let imageView = QXImageView()
                        imageView.image = image
                        let label = QXLabel()
                        label.font = navigationBarAutoDismissFont ?? QXFont(size: 16, color: navigationBarTintColor)
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
                        if isLeft {
                            navigationItem.leftBarButtonItem = item
                        } else {
                            navigationItem.rightBarButtonItem = item
                        }
                    } else if let title = navigationBarAutoDismissTitle {
                        let btn = QXTitleButton()
                        btn.intrinsicMinHeight = 35
                        btn.font = navigationBarAutoDismissFont ?? QXFont(size: 16, color: navigationBarTintColor)
                        btn.title = title
                        btn.sizeToFit()
                        let item = QXBarButtonItem(customView: btn)
                        btn.respondClick = { [weak self] in
                            self?.dismiss(animated: true, completion: nil)
                        }
                        if isLeft {
                            navigationItem.leftBarButtonItem = item
                        } else {
                            navigationItem.rightBarButtonItem = item
                        }
                    } else if let image = navigationBarAutoDismissImage {
                        let btn = QXImageButton()
                        btn.image = image
                        btn.sizeToFit()
                        let item = QXBarButtonItem(customView: btn)
                        btn.respondClick = { [weak self] in
                            self?.dismiss(animated: true, completion: nil)
                        }
                        if isLeft {
                            navigationItem.leftBarButtonItem = item
                        } else {
                            navigationItem.rightBarButtonItem = item
                        }
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
