//
//  QXStaticFooterView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXStaticFooterView: QXStaticBaseHeaderFooterView {
    
    public lazy var label: QXLabel = {
        let one = QXLabel()
        one.numberOfLines = 0
        one.padding = QXMargin(5, 15, 10, 15)
        one.font = QXFont(fmt: "14 #999999")
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
