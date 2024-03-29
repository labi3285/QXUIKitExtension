//
//  QXSettingTextHeaderView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/25.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import QXConsMaker

open class QXSettingTextHeaderView: QXSettingSeparateHeaderView {
    
    open override func height(_ model: Any?) -> CGFloat? {
        label.fixWidth = (context?.givenWidth ?? 0)
        return label.natureSize.h
    }
    
    public final lazy var label: QXRichLabel = {
        let e = QXRichLabel()
        e.numberOfLines = 0
        e.padding = QXEdgeInsets(10, 15, 5, 15)
        e.font = QXFont(12, QXColor.dynamicTip)
        return e
    }()

    public required init() {
        super.init()
        contentView.addSubview(label)
        label.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        fixHeight = nil
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public required init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }
    
}
