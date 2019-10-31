//
//  QXStaticItemCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXSettingCell: QXStaticBaseCell {
    
    open override func initializedWithTable() {
        super.initializedWithTable()
        breakLine.isHidden = isLastCellInSection || isBreakLineHidden
    }
    
    public var isBreakLineHidden: Bool = false
    public lazy var breakLine: QXLineView = {
        let one = QXLineView.breakLine
        one.isVertical = false
        one.padding = QXEdgeInsets(0, 0, 0, 15)
        one.isUserInteractionEnabled = false
        return one
    }()

    required public init() {
        super.init()
        contentView.addSubview(breakLine)
        contentView.qxBackgroundColor = QXColor.white
        fixHeight = 50
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    required public init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        let h = breakLine.intrinsicContentSize.height
        breakLine.frame = CGRect(x: 0, y: contentView.frame.height - h, width: contentView.frame.width, height: h)
        bringSubviewToFront(breakLine)
    }
    
}


