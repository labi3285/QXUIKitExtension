//
//  QXSettingTitleTextFieldCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import QXConsMaker

open class QXSettingTitleTextFieldCell: QXSettingCell {

    public lazy var titleLabel: QXLabel = {
        let e = QXLabel()
        e.numberOfLines = 1
        e.font = QXFont(fmt: "16 #333333")
        return e
    }()
    public lazy var textField: QXTextField = {
        let e = QXTextField()
        e.intrinsicSize = QXSize(9999, 99)
        e.font = QXFont(fmt: "16 #333333")
        e.placeHolderfont = QXFont(fmt: "16 #999999")
        e.uiTextField.textAlignment = .right
        e.placeHolder = "输入内容"
        return e
    }()
    public lazy var layoutView: QXStackView = {
        let e = QXStackView()
        e.alignmentY = .center
        e.alignmentX = .left
        e.viewMargin = 10
        e.padding = QXEdgeInsets(5, 15, 5, 15)
        e.setupViews([self.titleLabel, QXFlexView(), self.textField])
        return e
    }()

    required public init() {
        super.init()
        contentView.addSubview(layoutView)
        layoutView.IN(contentView).LEFT.TOP.RIGHT.BOTTOM.MAKE()
        fixHeight = 50
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    required public init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }

}
