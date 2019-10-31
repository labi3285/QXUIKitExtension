//
//  QXSettingHeaderView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXSettingSeparateHeaderView: QXStaticBaseHeaderFooterView {
        
    public lazy var breakLine: QXLineView = {
        let one = QXLineView.breakLine
        one.isVertical = false
        one.isHidden = false
        one.isUserInteractionEnabled = false
        return one
    }()
    open override func layoutSubviews() {
        super.layoutSubviews()
        let h = breakLine.intrinsicContentSize.height
        breakLine.frame = CGRect(x: 0, y: contentView.frame.height - h, width: contentView.frame.width, height: h)
        bringSubviewToFront(breakLine)
        fixHeight = 10
    }
        
    required public init() {
        super.init()
        contentView.addSubview(breakLine)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    required public init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }
    
}
