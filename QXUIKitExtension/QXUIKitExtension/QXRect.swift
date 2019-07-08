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
    public init(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
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
    public var width: CGFloat {
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
    public var height: CGFloat {
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
    
    /// Size
    public struct Size {
        
        /// width
        public var width: CGFloat
        /// height
        public var height: CGFloat
        
        /// default init
        public init() {
            self.width = 0
            self.height = 0
        }
        
        /// init with width/height
        public init(_ width: CGFloat, _ height: CGFloat) {
            self.width = width
            self.height = height
        }
        
    }
    
    /// Point
    public struct Point {
        
        /// x
        public var x: CGFloat
        /// y
        public var y: CGFloat
        
        /// default init
        public init() {
            self.x = 0
            self.y = 0
        }
        
        /// init with x/y
        public init(_ x: CGFloat, _ y: CGFloat) {
            self.x = x
            self.y = y
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
    public var topLeft: QXRect.Point {
        set {
            left = newValue.x
            top = newValue.y
        }
        get {
            return QXRect.Point(left, top)
        }
    }
    
    /// point at top-center
    public var topCenter: QXRect.Point {
        set {
            centerX = newValue.x
            top = newValue.y
        }
        get {
            return QXRect.Point(centerX, top) }
        }

    /// point at top-right
    public var topRight: QXRect.Point {
        set {
            right = newValue.x
            top = newValue.y
        }
        get {
            return QXRect.Point(right, top)
        }
    }
    
    /// point at left-top
    public var leftTop: QXRect.Point {
        set {
            left = newValue.x
            top = newValue.y
        }
        get {
            return QXRect.Point(left, top)
        }
    }
    
    /// point at left-center
    public var leftCenter: QXRect.Point {
        set {
            left = newValue.x
            centerY = newValue.y
        }
        get {
            return QXRect.Point(left, centerY)
        }
    }
    
    /// point at left-bottom
    public var leftBottom: QXRect.Point {
        set {
            left = newValue.x
            bottom = newValue.y
        }
        get {
            return QXRect.Point(left, bottom)
        }
    }
    
    /// point at right-top
    public var rightTop: QXRect.Point {
        set {
            right = newValue.x
            top = newValue.y
        }
        get {
            return QXRect.Point(right, top)
        }
    }
    
    /// point at right-center
    public var rightCenter: QXRect.Point {
        set {
            right = newValue.x
            centerY = newValue.y
        }
        get {
            return QXRect.Point(right, centerY)
        }
    }
    
    /// point at right-bottom
    public var rightBottom: QXRect.Point {
        set {
            right = newValue.x
            bottom = newValue.y
        }
        get {
            return QXRect.Point(right, bottom)
        }
    }

    /// point at bottom-left
    public var bottomLeft: QXRect.Point {
        set {
            left = newValue.x
            bottom = newValue.y
        }
        get {
            return QXRect.Point(left, bottom)
        }
    }
    
    /// point at bottom-center
    public var bottomCenter: QXRect.Point {
        set {
            centerX = newValue.x
            bottom = newValue.y
        }
        get {
            return QXRect.Point(centerX, bottom)
        }
    }
    
    /// point at bottom-right
    public var bottomRight: QXRect.Point {
        set {
            right = newValue.x
            bottom = newValue.y
        }
        get {
            return QXRect.Point(right, bottom)
        }
    }
    
    /// point at center
    public var center: QXRect.Point {
        set {
            centerX = newValue.x
            centerY = newValue.y
        }
        get {
            return QXRect.Point(centerX, centerY)
        }
    }
    
    /// size
    public var size: Size {
        set {
            width = newValue.width
            height = newValue.height
        }
        get {
            return Size(width, height)
        }
    }
    
    /// point at left-top
    public var origin: Point {
        set {
            x = newValue.x
            y = newValue.y
        }
        get {
            return Point(x, y)
        }
    }
    
    /// absolute rect
    public var absoluteRect: QXRect {
        return QXRect.init(0, 0, width, height)
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
        return "[\(string(x)),\(string(y)),\(string(width)),\(string(height))]"
    }
    
}

extension QXRect.Size: CustomStringConvertible {
    
    public var description: String {
        func string(_ f: CGFloat) -> String {
            if f == CGFloat(Int(f)) {
                return "\(Int(f))"
            } else {
                return "\(f)"
            }
        }
        return "[\(string(width)),\(string(height))]"
    }
    
}

extension QXRect.Point: CustomStringConvertible {
    
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
