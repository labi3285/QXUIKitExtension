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
    
    open override var isEnabled: Bool {
        didSet {
            textField.isEnabled = isEnabled
            super.isEnabled = isEnabled
        }
    }

    public final lazy var textField: QXTextField = {
        let e = QXTextField()
        e.extendSize = true
        e.font = QXFont(16, QXColor.dynamicInput)
        e.placeHolderfont = QXFont(16, QXColor.dynamicPlaceHolder)
        e.placeHolder = "输入内容"
        e.padding = QXEdgeInsets(5, 15, 5, 15)
        return e
    }()

    public required init() {
        super.init()
        contentView.qxBackgroundColor = QXColor.dynamicWhite
        contentView.addSubview(textField)
        textField.IN(contentView).LEFT.TOP.RIGHT.BOTTOM.MAKE()
        fixHeight = 50
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public required init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }

}
