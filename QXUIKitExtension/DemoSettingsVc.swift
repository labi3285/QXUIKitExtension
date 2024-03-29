//
//  DemoSettingsVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/25.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

class DemoSettingsVc: QXTableViewController<Any> {
    
    final lazy var headerView: QXSettingTextHeaderView = {
        let e = QXSettingTextHeaderView()
        e.label.text = "头部"
        return e
    }()

    final lazy var textCell: QXSettingTextCell = {
        let e = QXSettingTextCell()
        e.label.text = "文本" + QXDebugText(99)
        return e
    }()
    final lazy var arrowCell: QXSettingTitleArrowCell = {
        let e = QXSettingTitleArrowCell()
        e.titleLabel.text = "箭头"
        return e
    }()
    final lazy var iconArrowCell: QXSettingIconTitleArrowCell = {
        let e = QXSettingIconTitleArrowCell()
        e.titleLabel.text = "箭头"
        return e
    }()
    final lazy var titleSelectArrowCell: QXSettingTitleCheckArrowCell = {
        let e = QXSettingTitleCheckArrowCell()
        e.titleLabel.text = "箭头"
        e.backButton.respondClick = { [weak self] in
            if let s = self {
                s.titleSelectArrowCell.isChecked = !s.titleSelectArrowCell.isChecked
            }
        }
        return e
    }()
    final lazy var switchCell: QXSettingTitleSwitchCell = {
        let e = QXSettingTitleSwitchCell()
        e.titleLabel.text = "开关"
        return e
    }()
    final lazy var selectCell: QXSettingTitleCheckCell = {
        let e = QXSettingTitleCheckCell()
        e.titleLabel.text = "选项"
        e.backButton.respondClick = { [weak self] in
            if let s = self {
                s.selectCell.isChecked = !s.selectCell.isChecked
            }
        }
        return e
    }()
    final lazy var textFieldCell: QXSettingTextFieldCell = {
        let e = QXSettingTextFieldCell()
        e.textField.placeHolder = "输入内容"
        e.textField.filter = QXTextFilter.double(min: 0.0001, max: 333.3333, dec: 4)
        return e
    }()
    final lazy var titleTextFieldCell: QXSettingTitleTextFieldCell = {
        let e = QXSettingTitleTextFieldCell()
        e.titleLabel.text = "输入框"
        e.textField.filter = .phone
        e.textField.text = "13200000001"
        print(e.textField.text)
        e.textField.placeHolder = "输入内容"
        return e
    }()
    final lazy var textViewCell: QXSettingTextViewCell = {
        let e = QXSettingTextViewCell()
        e.textView.alignmentX = .right
//        e.textView.
        e.textView.placeHolder = "输入内容"
        return e
    }()
    
    final lazy var cityPickerView: QXPickersView = {
        let a = QXPickerView()
        a.suffixView = {
            let e = QXLabel()
            e.text = "省"
            return e
        }()
        
        let b = QXPickerView()
        b.suffixView = {
            let e = QXLabel()
            e.text = "市"
            return e
        }()
        let c = QXPickerView()
        c.suffixView = {
            let e = QXLabel()
            e.text = "区"
            return e
        }()
        let e = QXPickersView([a, b, c])
        var aa: [QXPickerView.Item] = []
        for i in 0..<5 {
            let item = QXPickerView.Item(i, "a\(i)", nil)
            var bb: [QXPickerView.Item] = []
            for j in 0..<5 {
                let item = QXPickerView.Item(j, "b\(i)\(j)", nil)
                var cc: [QXPickerView.Item] = []
                for k in 0..<5 {
                    let item = QXPickerView.Item(k, "c\(i)\(j)\(k)", nil)
                    cc.append(item)
                }
                item.children = cc
                bb.append(item)
            }
            item.children = bb
            aa.append(item)
        }
        e.items = aa
        return e
    }()
    final lazy var cityPickerCell: QXSettingTitlePickerCell = {
        let e = QXSettingTitlePickerCell()
        e.titleLabel.text = "选择城市"
        e.textField.pickerView = self.cityPickerView
        e.textField.bringInPickedItems = [
            QXPickerView.Item(1, "a1"),
            QXPickerView.Item(1, "b11"),
            QXPickerView.Item(1, "c111"),
        ]
        return e
    }()
    final lazy var datePickerCell: QXSettingTitlePickerCell = {
        let e = QXSettingTitlePickerCell()
        e.titleLabel.text = "选择时间"
//        let picker = QXYearPickersView(minDate: QXDate(year: 1970), maxDate: QXDate(year: 2020), isCleanShow: true)
//        let picker = QXMonthPickersView(minDate: QXDate(month: 1), maxDate: QXDate(month: 12), isCleanShow: true)
//        let picker = QXDayPickersView(minDate: QXDate(day: 1), maxDate: QXDate(day: 31), isCleanShow: true)
//        let picker = QXHourPickersView(minDate: QXDate(hour: 1), maxDate: QXDate(hour: 24), isCleanShow: true)
//        let picker = QXMinutePickersView(minDate: QXDate(minute: 1), maxDate: QXDate(minute: 60))
//        let picker = QXSecondPickersView(minDate: QXDate(second: 1), maxDate: QXDate(second: 60), isCleanShow: true)

                
//        let picker = QXYearMonthDayPickersView(minDate: QXDate(year: 2000, month: 1, day: 1),
//                                                      maxDate: QXDate(year: 2020, month: 12, day: 31), isCleanShow: true)
        
//        let picker = QXYearMonthPickersView(minDate: QXDate(year: 2000, month: 1),
//                                                   maxDate: QXDate(year: 2020, month: 12), isCleanShow: true)
        
                                                   
//        let picker = QXMonthDayPickersView(minDate: QXDate(month: 1, day: 1),
//                                                  maxDate: QXDate(month: 12, day: 31), isCleanShow: true)
        
        let picker = QXHourMinuteSecondPickersView(minDate: QXDate(hour: 1, minute: 0, second: 0),
                                                          maxDate: QXDate(hour: 23, minute: 30, second: 30), isCleanShow: false)
        e.textField.pickedTextParser = { strs in
            return strs?.joined(separator: ":")
        }
        e.textField.pickerView = picker
        
        e.textField.bringInDate = QXDate.now
        return e
    }()
        
    final lazy var footerView: QXSettingTextFooterView = {
        let e = QXSettingTextFooterView()
        e.label.text = "尾部"
        return e
    }()

    final lazy var section: QXTableViewSection = {
        let e = QXTableViewSection([
            self.textViewCell,
            self.textFieldCell,
            self.xxxPickerCell,
            self.selectCell,
            self.cityPickerCell,
            self.datePickerCell,
            self.arrowCell,
            QXFlexSpace(),
            self.iconArrowCell,
            self.titleSelectArrowCell,
            self.switchCell,
            self.titleTextFieldCell,
            QXFlexSpace(),
            self.textCell,
        ], self.headerView, self.footerView)
        return e
    }()
    
    final lazy var xxxPickerView: QXPickersView = {
        let a = QXPickerView()
//        a.suffixView = {
//            let e = QXLabel()
//            e.text = "省"
//            return e
//        }()
        let e = QXPickersView([a], isCleanShow: true)
        var aa: [QXPickerView.Item] = []
        for i in 0..<5 {
            let item = QXPickerView.Item(i, "a\(i)", nil)
            aa.append(item)
        }
        e.items = aa
        return e
    }()
    final lazy var xxxPickerCell: QXSettingTitlePickerCell = {
        let e = QXSettingTitlePickerCell()
        e.titleLabel.text = "选择城市"
        e.textField.pickerView = self.xxxPickerView
        e.textField.bringInPickedItems = [
            QXPickerView.Item(1, "a1")
        ]
        return e
    }()
    
    override func didSetup() {
        super.didSetup()
        tableView.sections = [section]
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        tableView.isSortMode = true
        view.qxBackgroundColor = QXColor.dynamicBackgroundGray
        navigationBarBackgroundColor = QXColor.red
    }

}

