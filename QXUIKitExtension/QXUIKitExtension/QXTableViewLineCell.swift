//
//  QXTableViewLineCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/11/12.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXTableViewLine {
    
    open var lineWidth: CGFloat = 0.5
    open var lineColor: QXColor = QXColor.lineGray
    open var lineCap: CGLineCap = .round
    open var lineDash: (phase: CGFloat, lengths: [CGFloat])?
    open var padding: QXEdgeInsets = QXEdgeInsets(5, 15, 5, 15)

}

class QXTableViewLineCell: QXTableViewCell {
    
    override open func initializedWithTable() {
        super.initializedWithTable()
        lineView.fixWidth = cellWidth
    }
        
    override var model: Any? {
        didSet {
            super.model = model
            if let e = model as? QXTableViewLine {
                lineView.padding = e.padding
                lineView.lineWidth = e.lineWidth
                lineView.lineColor = e.lineColor
                lineView.lineCap = e.lineCap
                lineView.lineDash = e.lineDash
            }
        }
    }
    public lazy var lineView: QXLineView = {
        let e = QXLineView()
        return e
    }()
    required init(_ reuseId: String) {
        super.init(reuseId)
        contentView.addSubview(lineView)
        lineView.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        backButton.isDisplay = false
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
