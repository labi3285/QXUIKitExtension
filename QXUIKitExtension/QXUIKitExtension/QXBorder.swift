//
//  QXBorder.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/12.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXBorder {
    
    open var color: QXColor?
    @discardableResult
    public func setColor(_ e: QXColor?) -> QXBorder { color = e; return self }
    
    open var lineWidth: CGFloat?
    @discardableResult
    public func setLineWidth(_ e: CGFloat?) -> QXBorder { lineWidth = e; return self }
    
    open var cornerRadius: CGFloat?
    @discardableResult
    public func setCornerRadius(_ e: CGFloat?) -> QXBorder { cornerRadius = e; return self }
    
    public init() {
    }
    
    public init(_ lineWidth: CGFloat, _ cornerRadius: CGFloat, _ fmtHex: String) {
        self.lineWidth = lineWidth
        self.cornerRadius = cornerRadius
        self.color = QXColor.fmtHex(fmtHex)
    }
    
}

extension CALayer {
    
    open var qxBorder: QXBorder? {
        set {
            if let e = newValue?.color?.uiColor.cgColor {
                 borderColor = e
            }
            if let e = newValue?.lineWidth {
                borderWidth = e
            }
            if let e = newValue?.cornerRadius {
                cornerRadius = e
            }
        }
        get {
            let e = QXBorder()
            if let c = borderColor {
                e.color = QXColor.cgColor(c)
            }
            if borderWidth != 0 {
                e.lineWidth = CGFloat(borderWidth)
            }
            if cornerRadius != 0 {
                e.cornerRadius = cornerRadius
            }
            return e
        }
    }
    
}

extension UIView {
    
    open var qxCornerRadius: CGFloat {
        set {
            let e = QXBorder()
            e.cornerRadius = newValue
            layer.qxBorder = e
        }
        get {
            return layer.qxBorder?.cornerRadius ?? 0
        }
    }
    
    open var qxBorder: QXBorder? {
        set {
            layer.qxBorder = newValue
        }
        get {
            return layer.qxBorder
        }
    }
    
}
