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
        e.lineWidth = 0.6
        e.lineColor = QXColor.fmtHex("#999999")
        return e
    }
}

open class QXLineView: QXView {
    
    public var lineWidth: CGFloat = 1
    public var lineColor: QXColor = QXColor.black
    public var lineCap: CGLineCap = .round
    public var lineDash: (phase: CGFloat, lengths: [CGFloat])?
    
    
    public var isVertical: Bool = false
    public var margin: QXMargin = QXMargin.zero
    
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
                    return CGSize(width: e, height: lineWidth + margin.top + margin.bottom)
                }
            } else if let e = intrinsicHeight {
                if isVertical {
                    return CGSize(width: lineWidth + margin.left + margin.right, height: e)
                } else {
                    return CGSize(width: CGFloat.greatestFiniteMagnitude, height: e)
                }
            } else {
                if isVertical {
                    return CGSize(width: lineWidth + margin.left + margin.right, height: CGFloat.greatestFiniteMagnitude)
                } else {
                    return CGSize(width: CGFloat.greatestFiniteMagnitude, height: lineWidth + margin.top + margin.bottom)
                }
            }
        }
        return CGSize.zero
    }
    
    open override func draw(_ rect: CGRect) {
        if let ctx = UIGraphicsGetCurrentContext() {
            if isVertical {
                let y = margin.top
                let x = margin.left + (rect.width - margin.left - margin.right) / 2
                let h = rect.height - margin.top - margin.bottom
                ctx.move(to: CGPoint(x: x, y: y))
                ctx.addLine(to: CGPoint(x: x, y: y + h))
            } else {
                let x = margin.left
                let y = margin.top + (rect.height - margin.top - margin.bottom) / 2
                let w = rect.width - margin.left - margin.right
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
