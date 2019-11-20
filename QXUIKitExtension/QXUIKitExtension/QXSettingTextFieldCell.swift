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

    public lazy var textField: QXTextField = {
        let e = QXTextField()
        e.extendSize = true
        e.font = QXFont(size: 16, color: QXColor.dynamicInput)
        e.placeHolderfont = QXFont(size: 16, color: QXColor.dynamicPlaceHolder)
        e.placeHolder = "输入内容"
        e.padding = QXEdgeInsets(5, 15, 5, 15)
        return e
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
