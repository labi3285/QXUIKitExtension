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
    
    lazy var pickerView: QXPickerKeyboardView = {
        
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
        
        let e = QXPickerKeyboardView([a, b, c], isLazyMode: false)

        var aa: [QXPickerView.Item] = []
        for i in 0..<5 {
            let item = QXPickerView.Item(i, "a\(i)", nil)
            var bb: [QXPickerView.Item] = []
            for j in 0..<5 {
                let item = QXPickerView.Item(j, "b\(i)\(j)", nil)
                var cc: [QXPickerView.Item] = []
                for k in 0..<5 {
                    let item = QXPickerView.Item.init(k, "c\(i)\(j)\(k)", nil)
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
    lazy var pickCityCell: QXSettingTitlePickerCell = {
        let e = QXSettingTitlePickerCell()
        e.titleLabel.text = "选择城市"
        e.textField.pickerView = self.pickerView
        e.textField.bringInPickedItems = [
            QXPickerView.Item.init(1, "a1"),
            QXPickerView.Item.init(1, "b11"),
            QXPickerView.Item.init(1, "c111"),
        ]
        return e
    }()
    lazy var pickYearCell: QXSettingTitlePickerCell = {
        let e = QXSettingTitlePickerCell()
        e.titleLabel.text = "选择时间"
//        let picker = QXYearPickerKeyboardView(minDate: QXDate(year: 1970), maxDate: QXDate(year: 2020))
//        let picker = QXMonthPickerKeyboardView(minDate: QXDate(month: 1), maxDate: QXDate(month: 12))
//        let picker = QXDayPickerKeyboardView(minDate: QXDate(day: 1), maxDate: QXDate(day: 31))
//        let picker = QXHourPickerKeyboardView(minDate: QXDate(hour: 1), maxDate: QXDate(hour: 24))
//        let picker = QXMinutePickerKeyboardView(minDate: QXDate(minute: 1), maxDate: QXDate(minute: 60))
//        let picker = QXSecondPickerKeyboardView(minDate: QXDate(second: 1), maxDate: QXDate(second: 60))

                
//        let picker = QXYearMonthDayPickerKeyboardView(minDate: QXDate(year: 2000, month: 1, day: 1),
//                                                      maxDate: QXDate(year: 2020, month: 12, day: 31))
        
//        let picker = QXYearMonthPickerKeyboardView(minDate: QXDate(year: 2000, month: 1),
//                                                   maxDate: QXDate(year: 2020, month: 12))
        
                                                   
//        let picker = QXMonthDayPickerKeyboardView(minDate: QXDate(month: 1, day: 1),
//                                                  maxDate: QXDate(month: 12, day: 31))
        
        let picker = QXHourMinuteSecondPickerKeyboardView(minDate: QXDate(hour: 1, minute: 0, second: 0),
                                                          maxDate: QXDate(hour: 23, minute: 30, second: 30))
        
        e.textField.pickedSeparator = ":"
        e.textField.pickerView = picker
        
        e.textField.bringInDate = QXDate.now
        return e
    }()
        
    lazy var footerView: QXSettingTextFooterView = {
        let e = QXSettingTextFooterView()
        e.label.text = "尾部"
        return e
    }()
    
    lazy var section: QXTableViewSection = {
        let e = QXTableViewSection([
            self.pickCityCell,
            self.pickYearCell,

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
        view.qxBackgroundColor = QXColor.dynamicBackgroundGray
        tableView.sections = [section]
        
        
        
    }

}

