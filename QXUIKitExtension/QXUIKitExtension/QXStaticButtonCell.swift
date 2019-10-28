//
//  QXStaticButtonCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import QXConsMaker

open class QXStaticButtonCell: QXStaticBaseCell {
    
    open override func height(_ model: Any?, _ width: CGFloat) -> CGFloat? {
        button.intrinsicWidth = width
        return button.intrinsicContentSize.height
    }
    
    public lazy var button: QXTitleButton = {
        let one = QXTitleButton()
        one.titlePadding = QXEdgeInsets(7, 10, 7, 10)
        one.padding = QXEdgeInsets(10, 15, 10, 15)
        one.backView.qxBorder = QXBorder().setCornerRadius(5)
        one.backView.qxBackgroundColor = QXColor.fmtHex("#3a8ffb")
        one.font = QXFont(16, "#ffffff", true)
        one.highlightAlpha = 0.3
        one.title = "按 钮"
        return one
    }()

    required public init() {
        super.init()
        contentView.addSubview(button)
        button.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    required public init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }
    
}
