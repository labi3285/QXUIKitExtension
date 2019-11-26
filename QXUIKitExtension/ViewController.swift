//
//  ViewController.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/6/22.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import QXJSON

class ViewController: QXTableViewController<Any> {
    
    final lazy var testCell: QXSettingTitleArrowCell = {
        let e = QXSettingTitleArrowCell()
        e.titleLabel.text = "Test"
        e.subTitleLabel.text = QXDebugText(99)
        e.backButton.respondClick = { [weak self] in
            let vc = DemoTestVc()
            self?.push(vc)
        }
        return e
    }()
    
    final lazy var webCell: QXSettingTitleArrowCell = {
        let e = QXSettingTitleArrowCell()
        e.titleLabel.text = "QXWebView"
        e.backButton.respondClick = { [weak self] in
            let cfg = QXWebViewConfig()
            cfg.javaScriptBridges = [
                "helloIOS": { json in
                    print(json)
                }
            ]
            let vc = QXWebViewController(cfg)
            vc.webView.url = QXURL.file("test.html", in: Bundle.main)
//            vc.webView.url = QXUIKitExtensionResources.shared.url(for: "error-code.html")
//            vc.webView.url = QXURL.url("https://www.baidu.com")
            weak var wk_webView = vc.webView
            vc.navigationBarRightItem = QXBarButtonItem.titleItem("callJS", {
                var json = QXJSON([:])
                json["name"] = "小华";
                json["age"] = 12;
                wk_webView?.callJavaScriptFunction("demoFuncForIOSToCall", json, { (json) in
                    print(json)
                })
            })
            self?.push(vc)
        }
        return e
    }()
    
    final lazy var maskCell: QXSettingTitleArrowCell = {
        let e = QXSettingTitleArrowCell()
        e.titleLabel.text = "QXMaskViewController"
        e.backButton.respondClick = { [weak self] in
            let vc = QXMaskViewController()
            vc.view.backgroundColor = UIColor.red
            self?.present(vc)
        }
        return e
    }()
    final lazy var arrangeCell: QXSettingTitleArrowCell = {
        let e = QXSettingTitleArrowCell()
        e.titleLabel.text = "QXArrangeView"
        e.backButton.respondClick = { [weak self] in
            let vc = DemoArrangeViewVc()
            self?.push(vc)
        }
        return e
    }()
    final lazy var stackCell: QXSettingTitleArrowCell = {
        let e = QXSettingTitleArrowCell()
        e.titleLabel.text = "QXStackView"
        e.backButton.respondClick = { [weak self] in
            let vc = DemoStackViewVc()
            self?.push(vc)
        }
        return e
    }()
        
    final lazy var listCell: QXSettingTitleArrowCell = {
        let e = QXSettingTitleArrowCell()
        e.titleLabel.text = "List"
        e.backButton.respondClick = { [weak self] in
            let vc = DemoListVc()
            self?.push(vc)
        }
        return e
    }()
    final lazy var defaultListCell: QXSettingTitleArrowCell = {
        let e = QXSettingTitleArrowCell()
        e.titleLabel.text = "DefaultList"
        e.backButton.respondClick = { [weak self] in
            let vc = DemoDefaultListVc()
            self?.push(vc)
        }
        return e
    }()
    
    
    final lazy var staticCell: QXSettingTitleArrowCell = {
        let e = QXSettingTitleArrowCell()
        e.titleLabel.text = "QXStatics"
        e.backButton.respondClick = { [weak self] in
            let vc = DemoStaticsVc()
            self?.push(vc)
        }
        return e
    }()
    
    final lazy var settingCell: QXSettingTitleArrowCell = {
        let e = QXSettingTitleArrowCell()
        e.titleLabel.text = "QXSetting"
        e.backButton.respondClick = { [weak self] in
            let vc = DemoSettingsVc()
            self?.push(vc)
        }
        return e
    }()
    
    final lazy var section: QXTableViewSection = {
        let e = QXTableViewSection([
            self.testCell,
            self.webCell,
            self.maskCell,
            self.arrangeCell,
            self.stackCell,
            self.listCell,
            self.defaultListCell,
            self.staticCell,
            self.settingCell,
        ], QXSettingSeparateHeaderView(), QXSettingSeparateFooterView())
        return e
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "首页"
        view.qxBackgroundColor = QXColor.dynamicBackgroundGray
        tableView.sections = [section]
//        isNavigationBarShow = false
        
        navigationBarRightItem = QXBarButtonItem.titleItem("完成", {
            print("xxx")
        })
        
        navigationBarRightItems = [
            QXBarButtonItem.titleItem("AAA", {
                print("xxx")
            }),
            QXBarButtonItem.iconItem("icon_mine_ask1", {
                print("xxx")
            })
        ]
        let btn = QXTitleButton()
        btn.title = "这是按钮"
        btn.respondClick = {
            print("btn xxx")
            btn.title = "这是按钮xxx"
        }
        btn.padding = QXEdgeInsets(5, 5, 5, 5)
        btn.qxDebugRandomColor()
        navigationBarRightItem = QXBarButtonItem.stackItem(btn)
                                
//        let bar = QXNavigationBar()
//        bar.isAutoTitle = true
//        bar.contentView.backgroundColor = UIColor.yellow
//        customNavigationBar = bar

    }

}

