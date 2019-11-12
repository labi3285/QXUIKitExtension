//
//  QXSettingTextFooterView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/25.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import QXConsMaker

open class QXSettingTextFooterView: QXSettingSeparateFooterView {
    
    override open func height(_ model: Any?, _ width: CGFloat) -> CGFloat? {
        label.maxWidth = width
        return label.intrinsicContentSize.height
    }
    
    public lazy var label: QXRichLabel = {
        let e = QXRichLabel()
        e.numberOfLines = 0
        e.padding = QXEdgeInsets(5, 15, 10, 15)
        e.font = QXFont(fmt: "12 #999999")
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
