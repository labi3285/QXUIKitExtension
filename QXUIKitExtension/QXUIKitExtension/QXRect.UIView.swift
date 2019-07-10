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
    
    /// QXSize for frame.size
    public var qxSize: QXRect.Size {
        set {
            frame = CGRect(x: frame.minX, y: frame.minY, width: CGFloat(newValue.width), height: CGFloat(newValue.height))
        }
        get {
            return bounds.size.qxSize
        }
    }
    
    /// QXPoint for frame.origin
    public var qxOrigin: QXRect.Point {
        set {
            frame = CGRect(x: CGFloat(newValue.x), y: CGFloat(newValue.y), width: frame.width, height: frame.height)
        }
        get {
            return frame.origin.qxPoint
        }
    }
    
}

extension CGSize {
    
    /// QXSize
    public var qxSize: QXRect.Size {
        set {
            width = CGFloat(newValue.width)
            height = CGFloat(newValue.height)
        }
        get {
            return QXRect.Size(CGFloat(width), CGFloat(height))
        }
    }
    
}

extension QXRect.Size {
    
    /// CGSize
    public var size: CGSize {
        set {
            width = CGFloat(newValue.width)
            height = CGFloat(newValue.height)
        }
        get {
            return CGSize(width: CGFloat(width), height: CGFloat(height))
        }
    }
    
}

extension CGPoint {
    
    /// QXPoint
    public var qxPoint: QXRect.Point {
        set {
            x = CGFloat(newValue.x)
            y = CGFloat(newValue.y)
        }
        get {
            return QXRect.Point(CGFloat(x), CGFloat(y))
        }
    }
    
}

extension QXRect.Point {
    
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
            size = newValue.size.size
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
            return CGRect(x: x, y: y, width: width, height: height)
        }
    }
    
}
