//
//  QXPageIndicatorView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/12/5.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXPageIndicatorView: QXView {

    open var current: Int = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    open var count: Int = 0 {
        didSet {
            isHidden = count <= 1
            qxSetNeedsLayout()
        }
    }
    
    open var alignmentX: QXAlignmentX = .center
    open var alignmentY: QXAlignmentY = .center

    open var margin: CGFloat = 5

    open var currentImage: QXImage = QXImage.shapRoundFill(radius: 3, color: QXColor.darkFmtHex("#666666", "#999999"))
    open var otherImage: QXImage = QXImage.shapRoundFill(radius: 3, color: QXColor.darkFmtHex("#999999", "#ffffff"))

    public override init() {
        super.init()
        qxBackgroundColor = QXColor.clear
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func natureContentSize() -> QXSize {
        var w = (currentImage.size ?? QXSize.zero).w + ((otherImage.size ?? QXSize.zero).w + margin) * CGFloat(max(0, count - 1))
        w += padding.left + padding.right
        let h = padding.top + max((currentImage.size ?? QXSize.zero).h, (otherImage.size ?? QXSize.zero).h) + padding.bottom
        return QXSize(w, h)
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        if count <= 1 || rect.width == 0 || rect.height == 0 {
            return
        }
        let nw = (currentImage.size ?? QXSize.zero).w + ((otherImage.size ?? QXSize.zero).w + margin) * CGFloat(max(0, count - 1))
        let gh = rect.height - padding.top - padding.bottom
        let gw = rect.width - padding.left - padding.right
        var cw: CGFloat = (currentImage.size ?? QXSize.zero).w
        var ow: CGFloat = (otherImage.size ?? QXSize.zero).w
        var m: CGFloat = margin
        var ch: CGFloat = (currentImage.size ?? QXSize.zero).h
        var oh: CGFloat = (otherImage.size ?? QXSize.zero).h
        if nw > gw && gw > 0 {
            let r = gw / nw
            cw = cw * r
            ow = ow * r
            m = m * r
            ch = ch * r
            oh = oh * r
        }
        ch = min(gh, ch)
        oh = min(gh, oh)
        
        let tw = cw + (ow + m) * CGFloat(max(0, count - 1))
        let dx: CGFloat
        switch alignmentX {
        case .left:
            dx = padding.left
        case .center:
            dx = padding.left + (gw - tw) / 2
        case .right:
            dx = padding.left + gw - tw
        }
        let dcy: CGFloat
        let doy: CGFloat
        switch alignmentY {
        case .top:
            dcy = padding.top
            doy = padding.top
        case .center:
            dcy = padding.top + (gh - ch) / 2
            doy = padding.top + (gh - oh) / 2
        case .bottom:
            dcy = padding.top + gh - ch
            doy = padding.top + gh - oh
        }
        if let ctx = UIGraphicsGetCurrentContext() {
            ctx.setLineWidth(0)
            var x: CGFloat = 0
            for i in 0..<count {
                if current == i {
                    let rect = CGRect(x: dx + x, y: dcy, width: cw, height: ch)
                    if let wh = currentImage.size {
                        let r = CGRect(x: rect.minX + (rect.width - wh.w) / 2,
                                       y: rect.minY + (rect.height - wh.h) / 2,
                                       width: wh.w,
                                       height: wh.h)
                        currentImage.uiImage?.draw(in: r)
                    }
                    x += cw
                } else {
                    let rect = CGRect(x: dx + x, y: doy, width: ow, height: oh)
                    if let wh = otherImage.size {
                        let r = CGRect(x: rect.minX + (rect.width - wh.w) / 2,
                                       y: rect.minY + (rect.height - wh.h) / 2,
                                       width: wh.w,
                                       height: wh.h)
                        otherImage.uiImage?.draw(in: r)
                    }
                    x += ow
                }
                x += m
            }
        }
    }

}
