//
//  QXStaticButtonCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXStaticButtonCell: QXStaticBaseCell {
    
    
    open override class func height(_ model: Any?, _ width: CGFloat) -> CGFloat? {
        return 50
    }
    
    public lazy var button: QXTitleButton = {
        let one = QXTitleButton()
        one.padding = QXMargin(10, 15, 10, 15)
        one.border = QXBorder.border
        one.title = "按钮 固定高度"
        return one
    }()

    required public init() {
        super.init()
        contentView.addSubview(button)
        button.IN(contentView).CENTER.MAKE()
//        button.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    required public init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }
    
}
