//
//  AppDelegate.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/6/22.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                
        let vc = ViewController()
        let nav = QXNavigationController(rootViewController: vc)
        nav.tabBarTitle = "Home"
        nav.tabBarIcon = QXImage("icon_mine_ask1").setRenderingMode(.alwaysOriginal)
                
        let tabVc = QXTabBarController()
        tabVc.tabBarTintColor = QXColor.red
        tabVc.tabBarBackgroundColor = QXColor.white
        tabVc.isTabBarLineShow = false
        
        tabVc.navigationControllers = [nav]
        let win = UIWindow.qxInitKeyWindow(tabVc, &window)
        win.backgroundColor = UIColor.white
        
        return true
    }

}

