//
//  ViewController.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/6/22.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

class ViewController: QXTableViewController<Any> {
    
    lazy var testCell: QXSettingTitleArrowCell = {
        let e = QXSettingTitleArrowCell()
        e.titleLabel.text = "Test"
        e.backButton.respondClick = { [weak self] in
            
            let vc = QXMaskViewController()
            vc.view.backgroundColor = UIColor.red

            self?.present(vc)
            
//            let vc = DemoTestVc()
//            self?.push(vc)
        }
        return e
    }()
    
    lazy var arrangeCell: QXSettingTitleArrowCell = {
        let e = QXSettingTitleArrowCell()
        e.titleLabel.text = "QXArrangeView"
        e.backButton.respondClick = { [weak self] in
            let vc = DemoArrangeViewVc()
            self?.push(vc)
        }
        return e
    }()
    lazy var stackCell: QXSettingTitleArrowCell = {
        let e = QXSettingTitleArrowCell()
        e.titleLabel.text = "QXStackView"
        e.backButton.respondClick = { [weak self] in
            let vc = DemoStackViewVc()
            self?.push(vc)
        }
        return e
    }()
        
    lazy var listCell: QXSettingTitleArrowCell = {
        let e = QXSettingTitleArrowCell()
        e.titleLabel.text = "List"
        e.backButton.respondClick = { [weak self] in
            let vc = DemoTableVc()
            self?.push(vc)
        }
        return e
    }()
    
    lazy var staticCell: QXSettingTitleArrowCell = {
        let e = QXSettingTitleArrowCell()
        e.titleLabel.text = "QXStatics"
        e.backButton.respondClick = { [weak self] in
            let vc = DemoStaticsVc()
            self?.push(vc)
        }
        return e
    }()
    
    lazy var settingCell: QXSettingTitleArrowCell = {
        let e = QXSettingTitleArrowCell()
        e.titleLabel.text = "QXSetting"
        e.backButton.respondClick = { [weak self] in
            let vc = DemoSettingsVc()
            self?.push(vc)
        }
        return e
    }()
    
    lazy var section: QXTableViewSection = {
        let e = QXTableViewSection([
            self.testCell,
            self.arrangeCell,
            self.stackCell,
            self.listCell,
            self.staticCell,
            self.settingCell,
        ], QXSettingSeparateHeaderView(), QXSettingSeparateFooterView())
        return e
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "首页"
        view.qxBackgroundColor = QXColor.backgroundGray
        tableView.sections = [section]
        
        view.backgroundColor = UIColor.yellow
        
//        let bar = QXNavigationBar()
//        bar.isAutoTitle = true
//        bar.contentView.backgroundColor = UIColor.yellow
//        customNavigationBar = bar

    }

}

