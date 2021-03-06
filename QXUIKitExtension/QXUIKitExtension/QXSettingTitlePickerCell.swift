//
//  QXSettingTitlePickerCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/11/15.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import QXConsMaker

open class QXSettingTitlePickerCell: QXSettingTitleTextFieldCell {

    public required init() {
        super.init()
        textField.placeHolder = "选择"
        let pickerView = QXPickersView([QXPickerView()])
        pickerView.items = [
            QXPickerView.Item(0, "A", nil),
            QXPickerView.Item(1, "B", nil),
            QXPickerView.Item(2, "C", nil),
        ]
        textField.pickerView = pickerView
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public required init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }

}
