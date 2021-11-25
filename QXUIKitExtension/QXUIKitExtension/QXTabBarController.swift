//
//  QXTabbarController.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/8.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXTabBarController: UITabBarController {
    
    /// 在有tabBarBackgroundImage 的情况下无效
    public var isTabBarLineShow: Bool?
    
    public var tabBarBackgroundColor: QXColor? = QXColor.dynamicBar
    public var tabBarBackgroundImage: QXImage?
    public var tabBarTintColor: QXColor? = QXColor.dynamicAccent
    public var tabBarStyle: UIBarStyle?
    
    public var navigationControllers: [QXNavigationController]? {
        didSet {
            viewControllers = navigationControllers
        }
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTabBar()
    }
    
    public func updateTabBar() {
        if let e = tabBarBackgroundImage {
            let size = view.bounds.size
            tabBar.backgroundImage = UIImage.qxCreate(size: size) { (ctx, rect) in
                UIColor.clear.setFill()
                UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height - 49))
                UIColor.white.setFill()
                if let e = tabBarBackgroundColor?.uiColor {
                    e.setFill()
                    UIRectFill(CGRect(x: 0, y: size.height - 49, width: size.width, height: 49))
                }
                e.uiImage?.draw(in: CGRect(x: 0, y: size.height - 49, width: size.width, height: 49))
            }
            tabBar.shadowImage = UIImage()
        } else if let e = tabBarBackgroundColor {
            tabBar.backgroundColor = e.uiColor
            tabBar.backgroundImage = UIImage()
            if let e = isTabBarLineShow {
                if !e {
                    tabBar.shadowImage = UIImage()
                }
            }
        } else {
            if let e = isTabBarLineShow {
                if !e {
                    tabBar.backgroundImage = UIImage()
                    tabBar.shadowImage = UIImage()
                }
            }
        }
        if let e = tabBarTintColor?.uiColor {
            tabBar.tintColor = e
        }
        if let e = tabBarStyle {
            tabBar.barStyle = e
        }
    }

}
