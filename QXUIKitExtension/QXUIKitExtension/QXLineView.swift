//
//  QXLineView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/8/20.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

extension QXLineView {
    
    public static var breakLine: QXLineView {
        let e = QXLineView()
        e.lineWidth = 0.5
        e.lineColor = QXColor.dynamicLine
        return e
    }
}

open class QXLineView: QXView {
    
    public var lineWidth: CGFloat = 1
    public var lineColor: QXColor = QXColor.black
    public var lineCap: CGLineCap = .round
    public var lineDash: (phase: CGFloat, lengths: [CGFloat])?
    
    public var isVertical: Bool = false
    
    public override init() {
        super.init()
        backgroundColor = UIColor.clear
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func natureContentSize() -> QXSize {
        if let e = fixWidth ?? maxWidth {
            if isVertical {
                return QXSize(e, QXView.extendLength)
            } else {
                return QXSize(e, lineWidth + padding.top + padding.bottom)
            }
        } else if let e = fixHeight ?? maxHeight {
            if isVertical {
                return QXSize(lineWidth + padding.left + padding.right, e)
            } else {
                return QXSize(QXView.extendLength, e)
            }
        } else {
            if isVertical {
                return QXSize(lineWidth + padding.left + padding.right, QXView.extendLength)
            } else {
                return QXSize(QXView.extendLength, lineWidth + padding.top + padding.bottom)
            }
        }
    }
    
    override open func draw(_ rect: CGRect) {
        if let ctx = UIGraphicsGetCurrentContext() {
            if isVertical {
                let y = padding.top
                let x = padding.left + (rect.width - padding.left - padding.right) / 2
                let h = rect.height - padding.top - padding.bottom
                ctx.move(to: CGPoint(x: x, y: y))
                ctx.addLine(to: CGPoint(x: x, y: y + h))
            } else {
                let x = padding.left
                let y = padding.top + (rect.height - padding.top - padding.bottom) / 2
                let w = rect.width - padding.left - padding.right
                ctx.move(to: CGPoint(x: x, y: y))
                ctx.addLine(to: CGPoint(x: x + w, y: y))
            }
            ctx.setStrokeColor(lineColor.uiColor.cgColor)
            ctx.setLineCap(lineCap)
            if let e = lineDash {
                ctx.setLineDash(phase: e.phase, lengths: e.lengths)
            }
            ctx.setLineWidth(lineWidth)
            ctx.strokePath()
        }
    }
    
}
