//
//  DemoSettingsVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/25.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

class DemoSettingsVc: QXTableViewController<Any> {
    
    lazy var headerView: QXSettingTextHeaderView = {
        let e = QXSettingTextHeaderView()
        e.label.text = "头部"
        return e
    }()
    
    lazy var baseCell: QXSettingCell = {
        let e = QXSettingCell()
        return e
    }()
    lazy var titleCell: QXSettingTitleCell = {
        let e = QXSettingTitleCell()
        e.titleLabel.text = "标题"
        return e
    }()
    lazy var textCell: QXSettingTextCell = {
        let e = QXSettingTextCell()
        e.label.text = "文本" + QXDebugText(99)
        return e
    }()
    lazy var arrowCell: QXSettingTitleArrowCell = {
        let e = QXSettingTitleArrowCell()
        e.titleLabel.text = "箭头"
        return e
    }()
    lazy var iconArrowCell: QXSettingIconTitleArrowCell = {
        let e = QXSettingIconTitleArrowCell()
        e.titleLabel.text = "箭头"
        return e
    }()
    lazy var switchCell: QXSettingTitleSwitchCell = {
        let e = QXSettingTitleSwitchCell()
        e.titleLabel.text = "开关"
        return e
    }()
    lazy var selectCell: QXSettingTitleSelectCell = {
        let e = QXSettingTitleSelectCell()
        e.titleLabel.text = "选项"
        e.backButton.respondClick = { [weak self] in
            if let s = self {
                s.selectCell.isSelected = !s.selectCell.isSelected
            }
        }
        return e
    }()
    lazy var textFieldCell: QXSettingTextFieldCell = {
        let e = QXSettingTextFieldCell()
        e.textField.placeHolder = "输入内容"
        return e
    }()
    lazy var titleTextFieldCell: QXSettingTitleTextFieldCell = {
        let e = QXSettingTitleTextFieldCell()
        e.titleLabel.text = "输入框"
        e.textField.placeHolder = "输入内容"
        return e
    }()
    lazy var textViewCell: QXSettingTextViewCell = {
        let e = QXSettingTextViewCell()
        e.textView.placeHolder = "输入内容"
        return e
    }()
    
    lazy var footerView: QXSettingTextFooterView = {
        let e = QXSettingTextFooterView()
        e.label.text = "尾部"
        return e
    }()
    
    lazy var section: QXTableViewSection = {
        let e = QXTableViewSection([
            self.baseCell,
            self.titleCell,
            self.arrowCell,
            self.iconArrowCell,
            self.selectCell,
            self.switchCell,
            self.titleTextFieldCell,

            self.textCell,
            self.textFieldCell,
            self.textViewCell,
            
        ], self.headerView, self.footerView)
        return e
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.qxBackgroundColor = QXColor.backgroundGray
        tableView.sections = [section]        
    }

}

