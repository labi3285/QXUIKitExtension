//
//  QXBoarderView.swift
//  Project
//
//  Created by labi3285 on 2020/1/20.
//  Copyright © 2020 labi3285_lab. All rights reserved.
//

import UIKit

open class QXBoarderView: QXView {
    
    open var boarderColor: QXColor = QXColor.black
    open var boarderWidth: CGFloat = 1
    open var cornerRadius: CGFloat = 4 {
        didSet {
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
        }
    }
    open var boarderLineDash: [CGFloat]? = [3, 3]
    
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
        let _rect = CGRect(x: boarderWidth / 2, y: boarderWidth / 2, width: rect.width - boarderWidth, height: rect.height - boarderWidth)
        let path = UIBezierPath(roundedRect: _rect, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        ctx.setLineWidth(boarderWidth)
        ctx.setStrokeColor(boarderColor.uiColor.cgColor)
        if let lineDash = boarderLineDash {
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

open class QXBoarderButton: QXButton {
    
    open var boarderColor: QXColor = QXColor.black
    open var boarderWidth: CGFloat = 1
    open var cornerRadius: CGFloat = 4 {
        didSet {
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
        }
    }
    open var boarderLineDash: [CGFloat]? = [3, 3]
    
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
        let _rect = CGRect(x: boarderWidth / 2, y: boarderWidth / 2, width: rect.width - boarderWidth, height: rect.height - boarderWidth)
        let path = UIBezierPath(roundedRect: _rect, byRoundingCorners: UIRectCorner.allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        ctx.setLineWidth(boarderWidth)
        ctx.setStrokeColor(boarderColor.uiColor.cgColor)
        if let lineDash = boarderLineDash {
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
