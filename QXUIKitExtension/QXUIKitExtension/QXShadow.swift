//
//  QXShadow.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/12.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXShadow {
    
    open var color: QXColor?
    @discardableResult
    public func setColor(_ e: QXColor?) -> QXShadow { color = e; return self }
    
    open var alpha: CGFloat?
    @discardableResult
    public func setAlpha(_ e: CGFloat?) -> QXShadow { alpha = e; return self }

    open var offset: QXSize?
    @discardableResult
    public func setOffset(_ e: QXSize?) -> QXShadow { offset = e; return self }

    open var radius: CGFloat?
    @discardableResult
    public func setRadius(_ e: CGFloat?) -> QXShadow { radius = e; return self }

    open var path: CGPath?
    @discardableResult
    public func setPath(_ e: CGPath?) -> QXShadow { path = e; return self }
    
    public init() {
    }
    
    public static var shadow: QXShadow {
        return QXShadow()
            .setColor(QXColor.black)
            .setAlpha(0.15)
            .setOffset(QXSize(1, 1))
            .setRadius(1)
    }
}

extension CALayer {
    
    open var qxShadow: QXShadow? {
        set {
            shadowColor = newValue?.color?.uiColor.cgColor
            if let e = newValue?.alpha {
                shadowOpacity = Float(e)
            }
            if let e = newValue?.path {
                shadowPath = e
            }
            if let e = newValue?.radius {
                shadowRadius = e
            }
            if let e = newValue?.offset {
                shadowOffset = e.cgSize
            }
        }
        get {
            let e = QXShadow()
            if let c = shadowColor {
                e.color = QXColor.cgColor(c)
            }
            if shadowOpacity != 0 {
                e.alpha = CGFloat(shadowOpacity)
            }
            e.path = shadowPath
            if shadowRadius != 0 {
                e.radius = shadowRadius
            }
            if shadowOffset != CGSize.zero {
                e.offset = shadowOffset.qxSize
            }
            return e
        }
    }
    
}

extension UIView {
    
    open var qxShadow: QXShadow? {
        set {
            layer.qxShadow = newValue
        }
        get {
            return layer.qxShadow
        }
    }
    
}
