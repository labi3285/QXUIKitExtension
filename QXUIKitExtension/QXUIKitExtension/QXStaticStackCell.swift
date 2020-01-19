//
//  QXStaticStackCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2020/1/15.
//  Copyright © 2020 labi3285_lab. All rights reserved.
//

import UIKit

open class QXStaticStackCell: QXStaticCell {
    
    override open func height(_ model: Any?, _ width: CGFloat) -> CGFloat? {
        stackView.fixWidth = width
        return stackView.natureSize.h
    }
    
    public final lazy var stackView: QXStackView = {
        let e = QXStackView()
        e.alignmentY = .center
        e.alignmentX = .left
        e.viewMargin = 10
        e.padding = QXEdgeInsets(5, 15, 5, 15)
        return e
    }()
        
    public required init() {
        super.init()
        contentView.addSubview(stackView)
        stackView.IN(contentView).LEFT.TOP.RIGHT.BOTTOM.MAKE()
        backButton.isDisplay = true
        fixHeight = nil
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public required init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }
    
}
