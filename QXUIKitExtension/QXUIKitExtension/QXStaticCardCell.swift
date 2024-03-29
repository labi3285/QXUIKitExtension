//
//  QXStaticCardCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/12/2.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import QXConsMaker

open class QXStaticCardCell: QXStaticCell {

    open override func height(_ model: Any?) -> CGFloat? {
        let cardW = ((context?.givenWidth ?? 0)) - layoutView.padding.left - layoutView.padding.right
        let contentW = cardW - cardView.padding.left - cardView.padding.right
        for e in cardView.views {
            if let e = e as? QXView {
                if e.fixWidth == nil {
                    e.fixWidth = contentW
                }
            }
        }
        layoutView.fixWidth = (context?.givenWidth ?? 0)
        cardView.fixWidth = cardW
        return layoutView.natureSize.h
    }
    
    public final lazy var cardView: QXStackView = {
        let e = QXStackView()
        e.qxBackgroundColor = QXColor.dynamicBody
        e.isVertical = true
        e.padding = QXEdgeInsets(10, 10, 10, 10)
        e.qxBorder = QXBorder().setCornerRadius(5)
        e.qxShadow = QXShadow.shadow
        return e
    }()
    public final lazy var layoutView: QXStackView = {
        let e = QXStackView()
        e.alignmentY = .center
        e.alignmentX = .left
        e.viewMargin = 10
        e.padding = QXEdgeInsets(5, 15, 5, 15)
        e.views = [self.cardView]
        return e
    }()
    
    public required init() {
        super.init()
        contentView.addSubview(layoutView)
        layoutView.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public required init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }
    
}
