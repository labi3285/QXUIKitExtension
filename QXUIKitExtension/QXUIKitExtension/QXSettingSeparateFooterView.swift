//
//  QXSettingSeparateFooterView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXSettingSeparateFooterView: QXStaticHeaderFooterView {
    
    public final lazy var breakLine: QXLineView = {
        let e = QXLineView.breakLine
        e.isVertical = false
        e.isHidden = false
        e.isUserInteractionEnabled = false
        return e
    }()
    override open func layoutSubviews() {
        super.layoutSubviews()
        let h = breakLine.intrinsicContentSize.height
        breakLine.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: h)
        bringSubviewToFront(breakLine)
    }
        
    public required init() {
        super.init()
        contentView.addSubview(breakLine)
        fixHeight = 10
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public required init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }
    
}
