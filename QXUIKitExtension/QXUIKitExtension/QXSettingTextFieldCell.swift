//
//  QXSettingTextFiledCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import QXConsMaker

open class QXSettingTextFieldCell: QXSettingCell {

    public lazy var textField: QXTextField = {
        let one = QXTextField()
        one.intrinsicSize = QXSize(9999, 99)
        one.font = QXFont(fmt: "16 #333333")
        one.placeHolderfont = QXFont(fmt: "16 #999999")
        one.placeHolder = "输入内容"
        one.padding = QXEdgeInsets(5, 15, 5, 15)
        return one
    }()

    required public init() {
        super.init()
        contentView.addSubview(textField)
        textField.IN(contentView).LEFT.TOP.RIGHT.BOTTOM.MAKE()
        fixHeight = 50
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    required public init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }

}
