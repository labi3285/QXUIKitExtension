//
//  AppDelegate.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/6/22.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                        
//        QXColor.isSupportDarkMode = false
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
//        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        let vc = ViewController()
        let nav = QXNavigationController(rootViewController: vc)
        nav.tabBarTitle = "Home"
        nav.tabBarIcon = QXImage("icon_mine_ask1")//.setRenderingMode(.alwaysTemplate)
                
        let tabVc = QXTabBarController()
        
        tabVc.navigationControllers = [nav]
        let win = UIWindow.qxInitKeyWindow(tabVc, &window)
        win.qxBackgroundColor = QXColor.dynamicWhite
        
        return true
    }

}

