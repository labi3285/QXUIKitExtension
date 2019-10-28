//
//  QXSettingTextCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/25.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import QXConsMaker

open class QXSettingTextCell: QXSettingCell {
    
    open override func height(_ model: Any?, _ width: CGFloat) -> CGFloat? {
        label.intrinsicWidth = width
        return label.intrinsicContentSize.height
    }

    public lazy var label: QXLabel = {
        let one = QXLabel()
        one.numberOfLines = 0
        one.font = QXFont(fmt: "15 #333333")
        one.padding = QXEdgeInsets(10, 15, 10, 15)
        return one
    }()

    required public init() {
        super.init()
        contentView.addSubview(label)
        label.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    required public init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }
    
}
