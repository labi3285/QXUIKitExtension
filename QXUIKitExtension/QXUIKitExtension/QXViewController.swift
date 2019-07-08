//
//  QXViewController.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/6.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

public class QXViewController: UIViewController {
    
    //MARK:- Init
    required init() {
        super.init(nibName: nil, bundle: nil)
        // make sure view init at start
        _ = view
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        QXDebugPrint("deinit")
    }
    
    public override var title: String? {
        didSet {
            super.title = title
            self.navigationBarTitle = title
        }
    }
    
    //MARK:- Data
    
    //MARK:- Life cycle
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavigationBar()
    }

    //MARK:- Navigation
    public var navigationBarBackArrowImage: QXImage?
    public var navigationBarBackItem: QXBarButtonItem?
    
    public var navigationBarTitle: String?
    public var navigationBarTitleFont: QXFont?
    public var navigationBarTitleView: UIView?
    public var navigationBarTintColor: QXColor?
    
    public var navigationBarBackgroundColor: QXColor?
    public var navigationBarBackgroundImage: QXImage?
    public var isNavigationBarLineShow: Bool?
    public var isNavigationBarTransparent: Bool?

    public var isNavigationBarShow: Bool?
    
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
    
    public func updateNavigationBar() {
        if isNavigationRootViewController {
            if isNavigationBarShow == nil {
                isNavigationBarShow = false
            }
            if navigationBarTitleFont == nil {
                navigationBarTitleFont = QXFont(15, "#333333")
            }
            if navigationBarTintColor == nil {
                navigationBarTintColor = QXColor.hex("#333333", 1)
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
            if let e = navigationBarTitle {
                let label = UILabel()
                label.qxFont = navigationBarTitleFont
                label.qxText = e
                label.sizeToFit()
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
        if let e = isNavigationBarShow {
            navigationController?.setNavigationBarHidden(e, animated: false)
        }
        if let e = isNavigationBarTransparent, e == true {
            navigationController?.qxNavigationBackgroundImage = QXImage(QXColor.clear)
        }
    }
    
    //MARK:- Present
    public var isAutoDismissItemAtLeft: Bool = true
    public var isAutoSetDismissItem: Bool = true
    public var dismissItem: QXBarButtonItem = QXBarButtonItem.titleItem(title: "取消", styles: nil)
    
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
