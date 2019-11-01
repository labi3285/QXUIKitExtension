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
        let one = QXSettingTitleArrowCell()
        one.titleLabel.text = "Test"
        one.backButton.respondClick = { [weak self] in
            let vc = DemoTestVc()
            self?.push(vc)
        }
        return one
    }()
    
    lazy var arrangeCell: QXSettingTitleArrowCell = {
        let one = QXSettingTitleArrowCell()
        one.titleLabel.text = "QXArrangeView"
        one.backButton.respondClick = { [weak self] in
            let vc = DemoArrangeViewVc()
            self?.push(vc)
        }
        return one
    }()
    lazy var stackCell: QXSettingTitleArrowCell = {
        let one = QXSettingTitleArrowCell()
        one.titleLabel.text = "QXStackView"
        one.backButton.respondClick = { [weak self] in
            let vc = DemoStackViewVc()
            self?.push(vc)
        }
        return one
    }()
        
    lazy var listCell: QXSettingTitleArrowCell = {
        let one = QXSettingTitleArrowCell()
        one.titleLabel.text = "List"
        one.backButton.respondClick = { [weak self] in
            let vc = DemoTableVc()
            self?.push(vc)
        }
        return one
    }()
    
    lazy var staticCell: QXSettingTitleArrowCell = {
        let one = QXSettingTitleArrowCell()
        one.titleLabel.text = "QXStatics"
        one.backButton.respondClick = { [weak self] in
            let vc = DemoStaticsVc()
            self?.push(vc)
        }
        return one
    }()
    
    lazy var settingCell: QXSettingTitleArrowCell = {
        let one = QXSettingTitleArrowCell()
        one.titleLabel.text = "QXSetting"
        one.backButton.respondClick = { [weak self] in
            let vc = DemoSettingsVc()
            self?.push(vc)
        }
        return one
    }()
    
    lazy var section: QXTableViewSection = {
        let one = QXTableViewSection([
            self.testCell,
            self.arrangeCell,
            self.stackCell,
            self.listCell,
            self.staticCell,
            self.settingCell,
        ], QXSettingSeparateHeaderView(), QXSettingSeparateFooterView())
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "首页"
        view.qxBackgroundColor = QXColor.backgroundGray
        tableView.sections = [section]
    }

}

