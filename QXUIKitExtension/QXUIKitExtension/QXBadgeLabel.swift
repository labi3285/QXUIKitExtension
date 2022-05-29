//
//  QXBadgeLabel.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2022/4/29.
//  Copyright © 2022 labi3285_lab. All rights reserved.
//

import UIKit

open class QXBadgeLabel: QXLabel {
    
    open var count: Int = 0 {
        didSet {
            if count > 99 {
                text = "+99"
                isHidden = false
            } else if count > 0 {
                text = "\(count)"
                isHidden = false
            } else {
                text = ""
                isHidden = true
            }
        }
    }
    
    open var color: QXColor? {
        set {
            backColor = newValue
        }
        get {
            return backColor
        }
    }
    
    public override init() {
        super.init()
        backColor = QXColor.red
        font = QXFont(10, QXColor.white)
        alignmentX = .center
        alignmentY = .center
        border = QXBorder().setCornerRadius(7)
        clipsToBounds = true
        fixHeight = 14
        minWidth = 14
        padding = QXEdgeInsets(0, 4, 0, 4)
        isHidden = false
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
