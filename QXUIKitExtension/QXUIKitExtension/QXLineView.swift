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
        e.lineColor = QXColor.lineGray
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
    
    public var intrinsicWidth: CGFloat?
    public var intrinsicHeight: CGFloat?
    open override var intrinsicContentSize: CGSize {
        if isDisplay {
            if let e = intrinsicSize {
                return e.cgSize
            } else if let e = intrinsicWidth {
                if isVertical {
                    return CGSize(width: e, height: CGFloat.greatestFiniteMagnitude)
                } else {
                    return CGSize(width: e, height: lineWidth + padding.top + padding.bottom)
                }
            } else if let e = intrinsicHeight {
                if isVertical {
                    return CGSize(width: lineWidth + padding.left + padding.right, height: e)
                } else {
                    return CGSize(width: CGFloat.greatestFiniteMagnitude, height: e)
                }
            } else {
                if isVertical {
                    return CGSize(width: lineWidth + padding.left + padding.right, height: CGFloat.greatestFiniteMagnitude)
                } else {
                    return CGSize(width: CGFloat.greatestFiniteMagnitude, height: lineWidth + padding.top + padding.bottom)
                }
            }
        }
        return CGSize.zero
    }
    
    var a: Bool = false
    
    open override func draw(_ rect: CGRect) {
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
