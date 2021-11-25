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
    
    open override func height(_ model: Any?) -> CGFloat? {
        label.fixWidth = context.givenWidth
        return label.intrinsicContentSize.height
    }
    
    public final lazy var label: QXLabel = {
        let e = QXLabel()
        e.numberOfLines = 0
        e.padding = QXEdgeInsets(5, 15, 10, 15)
        e.font = QXFont(14, QXColor.dynamicTip)
        return e
    }()

    public required init() {
        super.init()
        contentView.addSubview(label)
        label.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public required init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }
    
}
