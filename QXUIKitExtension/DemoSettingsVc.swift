//
//  DemoSettingsVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/25.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

class DemoSettingsVc: QXTableViewController<Any, QXLoadStatusView> {
    
    lazy var arrowCell: QXSettingTitleArrowCell = {
        let one = QXSettingTitleArrowCell()
        one.titleLabel.text = "设置相关UI"
        return one
    }()
    
    lazy var textFieldCell: QXSettingTextViewCell = {
        let one = QXSettingTextViewCell()
        one.textView.text = QXDebugText(99)
        one.textView.placeHolder = "输入内容"
        return one
    }()
    
    lazy var textViewCell: QXSettingTextViewCell = {
        let one = QXSettingTextViewCell()
        one.textView.text = QXDebugText(99)
        one.textView.placeHolder = "输入内容"
        return one
    }()
    
    lazy var textCell: QXSettingTextCell = {
        let one = QXSettingTextCell()
        one.label.text = QXDebugText(99)
        return one
    }()
    
    lazy var switchCell: QXSettingTitleSwitchCell = {
        let one = QXSettingTitleSwitchCell()
        one.titleLabel.text = "开关"
        return one
    }()
    
    lazy var headerView: QXSettingTextHeaderView = {
        let one = QXSettingTextHeaderView()
        one.label.text = QXDebugRandomText(999)
        return one
    }()
    lazy var footerView: QXSettingTextFooterView = {
        let one = QXSettingTextFooterView()
        one.label.text = QXDebugRandomText(999)
        return one
    }()
    lazy var section: QXTableViewSection = {
        let one = QXTableViewSection([
            self.arrowCell,
            self.textViewCell,
            self.textCell,
            self.switchCell
        ], self.headerView, self.footerView)
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "首页"
        view.qxBackgroundColor = QXColor.backgroundGray
        tableView.sections = [section]
    }

}

