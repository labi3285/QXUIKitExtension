//
//  QXRect.swift
//  QXRect
//
//  Created by labi3285 on 2018/6/1.
//  Copyright © 2018年 labi3285. All rights reserved.
//

import UIKit

/// QXRect
public struct QXRect {
    
    //MARK:-
    
    /// default init
    public init() { }
    
    /// init with x/y/width/height
    public init(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat) {
        self.x = x
        self.y = y
        self.w = w
        self.h = h
    }
    
    /// init with size
    public init(_ size: QXSize) {
        self.x = 0
        self.y = 0
        self.w = size.w
        self.h = size.h
    }
    public init(_ size: CGSize) {
        self.x = 0
        self.y = 0
        self.w = size.width
        self.h = size.height
    }
    
    //MARK:-

    /// x at left
    public var x: CGFloat {
        set {
            left = newValue
        }
        get {
            return left
        }
    }
    
    /// y at top
    public var y: CGFloat {
        set {
            top = newValue
        }
        get {
            return top
        }
    }
    
    /// width
    public var w: CGFloat {
        set {
            _width = newValue
            if _centerX != nil {
                if _left != nil && _right != nil {
                    if _anchorX == 0 {
                        _right = nil
                        _centerX = nil
                    } else if _anchorX == 0.5 {
                        _left = nil
                        _right = nil
                    } else if _anchorX == 1 {
                        _left = nil
                        _centerX = nil
                    }
                } else if _left != nil {
                    if _anchorX == 0.5 {
                        _left = nil
                    } else {
                        _centerX = nil
                    }
                } else if _right != nil {
                    if _anchorX == 0.5 {
                        _right = nil
                    } else {
                        _centerX = nil
                    }
                }
            } else {
                if _left != nil && _right != nil {
                    if _anchorX == 0 {
                        _right = nil
                    } else if _anchorX == 1 {
                        _left = nil
                    }
                }
            }
        }
        get {
            if let _width = _width {
                return _width
            } else if let _left = _left, let _right = _right {
                return _right - _left
            } else if let _left = _left, let _centerX = _centerX {
                return (_centerX - _left) * 2
            } else if let _right = _right, let _centerX = _centerX {
                return (_right - _centerX) * 2
            } else {
                return 0
            }
        }
    }
    
    /// height
    public var h: CGFloat {
        set {
            _height = newValue
            if _centerY != nil {
                if _top != nil && _bottom != nil {
                    if _anchorY == 0 {
                        _bottom = nil
                        _centerY = nil
                    } else if _anchorY == 0.5 {
                        _top = nil
                        _bottom = nil
                    } else if _anchorX == 1 {
                        _top = nil
                        _centerY = nil
                    }
                } else if _top != nil {
                    if _anchorY == 0.5 {
                        _top = nil
                    } else {
                        _centerY = nil
                    }
                } else if _bottom != nil {
                    if _anchorY == 0.5 {
                        _bottom = nil
                    } else {
                        _centerY = nil
                    }
                }
            } else {
                if _top != nil && _bottom != nil {
                    if _anchorY == 0 {
                        _bottom = nil
                    } else if _anchorX == 1 {
                        _top = nil
                    }
                }
            }
        }
        get {
            if let _height = _height {
                return _height
            } else if let _top = _top, let _bottom = _bottom {
                return _bottom - _top
            } else if let _top = _top, let _centerY = _centerY {
                return (_centerY - _top) * 2
            } else if let _bottom = _bottom, let _centerY = _centerY {
                return (_bottom - _centerY) * 2
            } else {
                return 0
            }
        }
    }
    
    //MARK:-
    
    /// top
    public var top: CGFloat {
        set {
            _top = newValue
            if _height == nil {
                if _centerY != nil && _bottom != nil {
                    if _anchorY == 0.5 {
                        _bottom = nil
                    } else {
                        _centerY = nil
                    }
                }
            } else {
                _centerY = nil
                _bottom = nil
            }
            _anchorY = 0
        }
        get {
            if let _top = _top {
                return _top
            } else if let _bottom = _bottom, let _height = _height {
                return _bottom - _height
            } else if let _centerY = _centerY, let _height = _height {
                return _centerY - _height * 0.5
            } else if let _centerY = _centerY, let _bottom = _bottom {
                return _bottom - (_bottom - _centerY) * 2
            } else if let _bottom = _bottom {
                return _bottom
            } else {
                return 0
            }
        }
    }
    
    /// left
    public var left: CGFloat {
        set {
            _left = newValue
            if _width == nil {
                if _centerX != nil && _right != nil {
                    if _anchorX == 0.5 {
                        _right = nil
                    } else {
                        _centerX = nil
                    }
                }
            } else {
                _centerX = nil
                _right = nil
            }
            _anchorX = 0
        }
        get {
            if let _left = _left {
                return _left
            } else if let _right = _right, let _width = _width {
                return _right - _width
            } else if let _centerX = _centerX, let _width = _width {
                return _centerX - _width * 0.5
            } else if let _centerX = _centerX, let _right = _right {
                return _right - (_right - _centerX) * 2
            } else if let _right = _right {
                return _right
            } else {
                return 0
            }
        }
    }
    
    /// bottom
    public var bottom: CGFloat {
        set {
            _bottom = newValue
            if _height == nil {
                if _centerY != nil && _top != nil {
                    if _anchorY == 0.5 {
                        _top = nil
                    } else {
                        _centerY = nil
                    }
                }
            } else {
                _centerY = nil
                _top = nil
            }
            _anchorY = 1
        }
        get {
            if let _bottom = _bottom {
                return _bottom
            } else if let _top = _top, let _height = _height {
                return _top + _height
            } else if let _centerY = _centerY, let _height = _height {
                return _centerY + _height * 0.5
            } else if let _centerY = _centerY, let _top = _top {
                return _top + (_centerY - _top) * 2
            } else if let _top = _top {
                return _top
            } else {
                return 0
            }
        }
    }
    
    /// right
    public var right: CGFloat   {
        set {
            _right = newValue
            if _width == nil {
                if _centerX != nil && _left != nil {
                    if _anchorX == 0.5 {
                        _left = nil
                    } else {
                        _centerX = nil
                    }
                }
            } else {
                _centerX = nil
                _left = nil
            }
            _anchorX = 1
        }
        get {
            if let _right = _right {
                return _right
            } else if let _left = _left, let _width = _width {
                return _left + _width
            } else if let _centerX = _centerX, let _width = _width {
                return _centerX + _width * 0.5
            } else if let _centerX = _centerX, let _left = _left {
                return _left + (_centerX - _left) * 2
            } else if let _left = _left {
                return _left
            } else {
                return 0
            }
        }
    }
    
    /// center x
    public var centerX: CGFloat {
        set {
            _centerX = newValue
            if _width == nil {
                if _left != nil && _right != nil {
                    if _anchorX == 0 {
                        _right = nil
                    } else if _anchorX == 1 {
                        _left = nil
                    }
                }
            } else {
                _left = nil
                _right = nil
            }
            _anchorX = 0.5
        }
        get {
            if let _centerX = _centerX {
                return _centerX
            } else if let _left = _left, let _right = _right {
                return _left + (_right - _left) * 0.5
            } else if let _left = _left, let _width = _width {
                return _left + _width * 0.5
            } else if let _right = _right, let _width = _width {
                return _right - _width * 0.5
            } else if let _left = _left {
                return _left
            } else if let _right = _right {
                return _right
            } else {
                return 0
            }
        }
    }
    
    /// center y
    public var centerY: CGFloat {
        set {
            _centerY = newValue
            if _height == nil {
                if _top != nil && _bottom != nil {
                    if _anchorY == 0 {
                        _bottom = nil
                    } else if _anchorY == 1 {
                        _top = nil
                    }
                }
            } else {
                _bottom = nil
                _top = nil
            }
            _anchorY = 0.5
        }
        get {
            if let _centerY = _centerY {
                return _centerY
            } else if let _top = _top, let _bottom = _bottom {
                return _top + (_bottom - _top) * 0.5
            } else if let _top = _top, let _height = _height {
                return _top + _height * 0.5
            } else if let _bottom = _bottom, let _height = _height {
                return _bottom - _height * 0.5
            } else if let _top = _top {
                return _top
            } else if let _bottom = _bottom {
                return _bottom
            } else {
                return 0
            }
        }
    }
    
    //MARK:-
    
    private var _top: CGFloat?
    private var _left: CGFloat?
    private var _bottom: CGFloat?
    private var _right: CGFloat?
    private var _centerX: CGFloat?
    private var _centerY: CGFloat?
    private var _width: CGFloat?
    private var _height: CGFloat?
    private var _anchorX: CGFloat?
    private var _anchorY: CGFloat?
    
}

extension QXRect {
    
    /// point at left-top
    public var topLeft: QXPoint {
        set {
            left = newValue.x
            top = newValue.y
        }
        get {
            return QXPoint(left, top)
        }
    }
    
    /// point at top-center
    public var topCenter: QXPoint {
        set {
            centerX = newValue.x
            top = newValue.y
        }
        get {
            return QXPoint(centerX, top) }
        }

    /// point at top-right
    public var topRight: QXPoint {
        set {
            right = newValue.x
            top = newValue.y
        }
        get {
            return QXPoint(right, top)
        }
    }
    
    /// point at left-top
    public var leftTop: QXPoint {
        set {
            left = newValue.x
            top = newValue.y
        }
        get {
            return QXPoint(left, top)
        }
    }
    
    /// point at left-center
    public var leftCenter: QXPoint {
        set {
            left = newValue.x
            centerY = newValue.y
        }
        get {
            return QXPoint(left, centerY)
        }
    }
    
    /// point at left-bottom
    public var leftBottom: QXPoint {
        set {
            left = newValue.x
            bottom = newValue.y
        }
        get {
            return QXPoint(left, bottom)
        }
    }
    
    /// point at right-top
    public var rightTop: QXPoint {
        set {
            right = newValue.x
            top = newValue.y
        }
        get {
            return QXPoint(right, top)
        }
    }
    
    /// point at right-center
    public var rightCenter: QXPoint {
        set {
            right = newValue.x
            centerY = newValue.y
        }
        get {
            return QXPoint(right, centerY)
        }
    }
    
    /// point at right-bottom
    public var rightBottom: QXPoint {
        set {
            right = newValue.x
            bottom = newValue.y
        }
        get {
            return QXPoint(right, bottom)
        }
    }

    /// point at bottom-left
    public var bottomLeft: QXPoint {
        set {
            left = newValue.x
            bottom = newValue.y
        }
        get {
            return QXPoint(left, bottom)
        }
    }
    
    /// point at bottom-center
    public var bottomCenter: QXPoint {
        set {
            centerX = newValue.x
            bottom = newValue.y
        }
        get {
            return QXPoint(centerX, bottom)
        }
    }
    
    /// point at bottom-right
    public var bottomRight: QXPoint {
        set {
            right = newValue.x
            bottom = newValue.y
        }
        get {
            return QXPoint(right, bottom)
        }
    }
    
    /// point at center
    public var center: QXPoint {
        set {
            centerX = newValue.x
            centerY = newValue.y
        }
        get {
            return QXPoint(centerX, centerY)
        }
    }
    
    /// size
    public var size: QXSize {
        set {
            w = newValue.w
            h = newValue.h
        }
        get {
            return QXSize(w, h)
        }
    }
    
    /// point at left-top
    public var origin: QXPoint {
        set {
            x = newValue.x
            y = newValue.y
        }
        get {
            return QXPoint(x, y)
        }
    }
    
    /// absolute rect
    public var absoluteRect: QXRect {
        return QXRect.init(0, 0, w, h)
    }
    
    public var isZero: Bool {
        return x == 0 && y == 0 && w == 0 && h == 0
    }
    
}

extension QXRect: CustomStringConvertible {
    
    public var description: String {
        func string(_ f: CGFloat) -> String {
            if f == CGFloat(Int(f)) {
                return "\(Int(f))"
            } else {
                return "\(f)"
            }
        }
        return "[\(string(x)),\(string(y)),\(string(w)),\(string(h))]"
    }
    
}

extension QXSize: CustomStringConvertible {
    
    public var description: String {
        func string(_ f: CGFloat) -> String {
            if f == CGFloat(Int64(f)) {
                return "\(Int(f))"
            } else {
                return "\(f)"
            }
        }
        return "[\(w),\(h)]"
    }
    
}

extension QXPoint: CustomStringConvertible {
    
    public var description: String {
        func string(_ f: CGFloat) -> String {
            if f == CGFloat(Int(f)) {
                return "\(Int(f))"
            } else {
                return "\(f)"
            }
        }
        return "[\(string(x)),\(string(y))]"
    }
    
}
