//
//  QXStaticFooterView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import QXConsMaker

open class QXStaticFooterView: QXStaticHeaderFooterView {
    
    override open func height(_ model: Any?, _ width: CGFloat) -> CGFloat? {
        label.maxWidth = width
        return label.intrinsicContentSize.height
    }
    
    public final lazy var label: QXLabel = {
        let e = QXLabel()
        e.numberOfLines = 0
        e.padding = QXEdgeInsets(5, 15, 10, 15)
        e.font = QXFont(14, QXColor.dynamicTip)
        return e
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
