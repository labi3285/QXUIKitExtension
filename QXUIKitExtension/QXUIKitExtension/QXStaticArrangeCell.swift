//
//  QXStaticArrangeCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2020/1/15.
//  Copyright © 2020 labi3285_lab. All rights reserved.
//

import UIKit

open class QXStaticArrangeCell: QXStaticCell {
    
    open override func height(_ model: Any?) -> CGFloat? {
        arrangeView.fixWidth = context.givenWidth
        return arrangeView.natureSize.h
    }
    
    public final lazy var arrangeView: QXArrangeView = {
        let e = QXArrangeView()
        e.lineAlignment = .top
        e.padding = QXEdgeInsets(5, 15, 5, 15)
        return e
    }()
        
    public required init() {
        super.init()
        contentView.addSubview(arrangeView)
        arrangeView.IN(contentView).LEFT.TOP.RIGHT.BOTTOM.MAKE()
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
