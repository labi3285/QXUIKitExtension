//
//  QXBorderView.swift
//  Project
//
//  Created by labi3285 on 2020/1/20.
//  Copyright © 2020 labi3285_lab. All rights reserved.
//

import UIKit

open class QXBorderView: QXView {
    
    open var borderColor: QXColor = QXColor.black
    open var borderWidth: CGFloat = 1
    open var cornerRadius: CGFloat = 4 {
        didSet {
            qxBorder
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
        }
    }
    open var borderLineDash: [CGFloat]? = [3, 3]
    
    public override init() {
        super.init()
        backgroundColor = UIColor.clear
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        let _rect = CGRect(x: borderWidth / 2, y: borderWidth / 2, width: rect.width - borderWidth, height: rect.height - borderWidth)
        let path = UIBezierPath(roundedRect: _rect, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        ctx.setLineWidth(borderWidth)
        ctx.setStrokeColor(borderColor.uiColor.cgColor)
        if let lineDash = borderLineDash {
            ctx.setLineDash(phase: 0, lengths: lineDash)
        }
        ctx.addPath(path.cgPath)
        ctx.strokePath()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
}

open class QXBorderButton: QXButton {
    
    open var borderColor: QXColor = QXColor.black
    open var borderWidth: CGFloat = 1
    open var cornerRadius: CGFloat = 4 {
        didSet {
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
        }
    }
    open var borderLineDash: [CGFloat]? = [3, 3]
    
    public override init() {
        super.init()
        backgroundColor = UIColor.clear
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        let _rect = CGRect(x: borderWidth / 2, y: borderWidth / 2, width: rect.width - borderWidth, height: rect.height - borderWidth)
        let path = UIBezierPath(roundedRect: _rect, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        ctx.setLineWidth(borderWidth)
        ctx.setStrokeColor(borderColor.uiColor.cgColor)
        if let lineDash = borderLineDash {
            ctx.setLineDash(phase: 0, lengths: lineDash)
        }
        ctx.addPath(path.cgPath)
        ctx.strokePath()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
}
