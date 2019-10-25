//
//  QXSettingTextFiledCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXSettingTextFieldCell: QXSettingCell {

    public lazy var textField: QXTextField = {
        let one = QXTextField()
        one.intrinsicSize = QXSize(9999, 99)
        one.font = QXFont(fmt: "16 #333333")
        one.placeHolderfont = QXFont(fmt: "16 #999999")
        one.placeHolder = "输入内容"
        return one
    }()
    public lazy var layoutView: QXStackView = {
        let one = QXStackView()
        one.alignmentY = .center
        one.alignmentX = .left
        one.viewMargin = 10
        one.padding = QXMargin(5, 15, 5, 15)
        one.setupViews([self.textField])
        return one
    }()

    required public init() {
        super.init()
        contentView.addSubview(layoutView)
        layoutView.IN(contentView).LEFT.TOP.RIGHT.BOTTOM.MAKE()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    required public init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }

}
