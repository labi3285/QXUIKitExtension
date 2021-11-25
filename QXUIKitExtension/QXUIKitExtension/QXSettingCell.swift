//
//  QXStaticItemCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXSettingCell: QXStaticCell {
    
    override open func contextDidSetup() {
        super.contextDidSetup()
        breakLine.isHidden = context.isLastCellInSection || isBreakLineHidden
    }
        
    public var isBreakLineHidden: Bool = false
    public final lazy var breakLine: QXLineView = {
        let e = QXLineView.breakLine
        e.isVertical = false
        e.padding = QXEdgeInsets(0, 0, 0, 15)
        e.isUserInteractionEnabled = false
        return e
    }()
    
    public required init() {
        super.init()
        contentView.addSubview(breakLine)
        contentView.qxBackgroundColor = QXColor.dynamicBody
        fixHeight = 50
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public required init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        let h = breakLine.intrinsicContentSize.height
        breakLine.frame = CGRect(x: 0, y: contentView.frame.height - h, width: contentView.frame.width, height: h)
        bringSubviewToFront(breakLine)
    }
    
}


