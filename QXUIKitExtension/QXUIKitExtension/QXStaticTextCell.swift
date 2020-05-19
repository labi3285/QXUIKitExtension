//
//  QXTableViewStaticTextCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import QXConsMaker

open class QXStaticTextCell: QXStaticCell {
    
    open override func contextDidSetup() {
        super.contextDidSetup()
        label.fixWidth = context.givenWidth
    }
    
    open override func height(_ model: Any?) -> CGFloat? {
        label.fixWidth = context.givenWidth
        return label.intrinsicContentSize.height
    }

    public final lazy var label: QXRichLabel = {
        let e = QXRichLabel()
        e.numberOfLines = 0
        e.font = QXFont(15, QXColor.dynamicText)
        e.padding = QXEdgeInsets(5, 15, 5, 15)
        e.isCopyEnabled = true
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
