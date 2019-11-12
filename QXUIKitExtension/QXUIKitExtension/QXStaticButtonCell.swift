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
    
    override open func height(_ model: Any?, _ width: CGFloat) -> CGFloat? {
        button.maxWidth = width
        return button.intrinsicContentSize.height
    }
    
    public lazy var button: QXTitleButton = {
        let e = QXTitleButton()
        e.titlePadding = QXEdgeInsets(7, 10, 7, 10)
        e.padding = QXEdgeInsets(10, 15, 10, 15)
        e.backView.qxBorder = QXBorder().setCornerRadius(5)
        e.backView.qxBackgroundColor = QXColor.fmtHex("#3a8ffb")
        e.font = QXFont(16, "#ffffff", true)
        e.highlightAlpha = 0.3
        e.title = "按 钮"
        return e
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
