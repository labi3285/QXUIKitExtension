//
//  QXProgressView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2021/6/30.
//  Copyright © 2021 labi3285_lab. All rights reserved.
//

import UIKit

open class QXProgressView: QXView {
    
    /// 进度（nil则为0）
    open var progress: QXProgress? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// 进度条颜色（背景用backColor）
    open var color: QXColor = QXColor.dynamicAccent
    
    public override init() {
        super.init()
        backColor = QXColor.clear
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)        
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc open func applicationDidBecomeActive() {
        setNeedsDisplay()
    }
    
    /// 是否垂直方向
    open var isVertical: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// 从右往左，从下往上
    open var isReversed: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    open override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        ctx.setLineWidth(0)
        let p = progress?.progress ?? 0
        color.uiColor.setFill()
        if isVertical {
            let w = rect.width
            let h = rect.height * p
            if isReversed {
                UIRectFill(CGRect(x: 0, y: rect.height - h, width: w, height: h))
            } else {
                UIRectFill(CGRect(x: 0, y: 0, width: w, height: h))
            }
        } else {
            let w = rect.width * p
            let h = rect.height
            if isReversed {
                UIRectFill(CGRect(x: rect.width - w, y: 0, width: w, height: h))
            } else {
                UIRectFill(CGRect(x: 0, y: 0, width: w, height: h))
            }
        }
    }
    
}
