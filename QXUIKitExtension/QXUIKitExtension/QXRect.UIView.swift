//
//  UIKit_ext.swift
//  QXRect
//
//  Created by labi3285 on 2018/6/3.
//  Copyright © 2018年 labi3285. All rights reserved.
//

import UIKit

extension UIView {
    
    /// QXRect for frame
    public var qxRect: QXRect {
        set {
            frame = newValue.cgRect
        }
        get {
            return frame.qxRect
        }
    }
    
    /// QXRect for bounds
    public var qxBounds: QXRect {
        set {
            bounds = newValue.cgRect
        }
        get {
            return bounds.qxRect
        }
    }
    
    /// QXSize for frame.size
    public var qxSize: QXSize {
        set {
            frame = CGRect(x: frame.minX, y: frame.minY, width: CGFloat(newValue.w), height: CGFloat(newValue.h))
        }
        get {
            return bounds.size.qxSize
        }
    }
    
    /// QXPoint for frame.origin
    public var qxOrigin: QXPoint {
        set {
            frame = CGRect(x: CGFloat(newValue.x), y: CGFloat(newValue.y), width: frame.width, height: frame.height)
        }
        get {
            return frame.origin.qxPoint
        }
    }
    
}

extension QXSize {
    
    /// CGSize
    public var cgSize: CGSize {
        set {
            w = CGFloat(newValue.width)
            h = CGFloat(newValue.height)
        }
        get {
            return CGSize(width: CGFloat(w), height: CGFloat(h))
        }
    }
    
}

extension QXPoint {
    
    /// CGPoint
    public var cgPoint: CGPoint {
        set {
            x = CGFloat(newValue.x)
            y = CGFloat(newValue.y)
        }
        get {
            return CGPoint(x: CGFloat(x), y: CGFloat(y))
        }
    }
}

extension CGRect {
    
    /// QXRect
    public var qxRect: QXRect {
        set {
            origin = newValue.origin.cgPoint
            size = newValue.size.cgSize
        }
        get {
            var rect = QXRect()
            rect.center = CGPoint(x: minX + width * 0.5, y: minY + height * 0.5).qxPoint
            rect.size = size.qxSize
            return rect
        }
    }
    
}

extension QXRect {
    
    /// CGRect
    public var cgRect: CGRect {
        set {
            center = CGPoint(x: newValue.minX + newValue.width * 0.5, y: newValue.minY + newValue.height * 0.5).qxPoint
            size = newValue.size.qxSize
        }
        get {
            return CGRect(x: x, y: y, width: w, height: h)
        }
    }
    
}

extension CGRect {
    
    public func qxSubRect(_ edgeInsets: UIEdgeInsets) -> CGRect {
        return CGRect(x: edgeInsets.left, y: edgeInsets.top, width: width - edgeInsets.left - edgeInsets.right, height: height - edgeInsets.top - edgeInsets.bottom)
    }
    
}
extension QXRect {
    
    public func subRect(_ padding: QXEdgeInsets) -> QXRect {
        return QXRect(padding.left, padding.top, w - padding.left - padding.right, h - padding.top - padding.bottom)
    }
    
}
