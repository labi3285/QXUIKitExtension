//
//  DemoSettingsVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/25.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

class DemoSettingsVc: QXTableViewController<Any, QXLoadStatusView> {
    
    lazy var headerView: QXSettingTextHeaderView = {
        let one = QXSettingTextHeaderView()
        one.label.text = "头部"
        return one
    }()
    
    lazy var baseCell: QXSettingCell = {
        let one = QXSettingCell()
        return one
    }()
    lazy var titleCell: QXSettingTitleCell = {
        let one = QXSettingTitleCell()
        one.titleLabel.text = "标题"
        return one
    }()
    lazy var textCell: QXSettingTextCell = {
        let one = QXSettingTextCell()
        one.label.text = "文本" + QXDebugText(99)
        return one
    }()
    lazy var textFieldCell: QXSettingTextFieldCell = {
        let one = QXSettingTextFieldCell()
        one.textField.placeHolder = "输入内容"
        return one
    }()
    lazy var titleTextFieldCell: QXSettingTitleTextFieldCell = {
        let one = QXSettingTitleTextFieldCell()
        one.titleLabel.text = "输入框"
        one.textField.placeHolder = "输入内容"
        return one
    }()
    lazy var textViewCell: QXSettingTextViewCell = {
        let one = QXSettingTextViewCell()
        one.textView.placeHolder = "输入内容"
        return one
    }()
    
    lazy var arrowCell: QXSettingTitleArrowCell = {
        let one = QXSettingTitleArrowCell()
        one.titleLabel.text = "箭头"
        return one
    }()
    lazy var switchCell: QXSettingTitleSwitchCell = {
        let one = QXSettingTitleSwitchCell()
        one.titleLabel.text = "开关"
        return one
    }()
    
    lazy var footerView: QXSettingTextFooterView = {
        let one = QXSettingTextFooterView()
        one.label.text = "尾部"
        return one
    }()
    
    lazy var section: QXTableViewSection = {
        let one = QXTableViewSection([
            self.baseCell,
            self.titleCell,
            self.arrowCell,
            self.switchCell,
            self.titleTextFieldCell,

            self.textCell,
            self.textFieldCell,
            self.textViewCell,
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

