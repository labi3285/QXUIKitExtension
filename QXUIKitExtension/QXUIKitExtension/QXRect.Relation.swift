//
//  QXRect.Relation.swift
//  QXRect
//
//  Created by labi3285 on 2018/6/4.
//  Copyright © 2018年 labi3285. All rights reserved.
//

import UIKit

/**
 * Conflict Priority:
 * w/h > left+right = top+bottom > center/centerX/centerY > top/left/bottom/right
 */

extension QXRect {
    
    /// Relation
    public enum Relation {
        
        /// right margin relation
        case right(CGFloat)
        /// left margin relation
        case left(CGFloat)
        /// bottom margin relation
        case bottom(CGFloat)
        /// top margin relation
        case top(CGFloat)
        
        /// w relation
        case width(CGFloat)
        /// h relation
        case height(CGFloat)
        
        /// center x relation
        case centerX
        /// center y relation
        case centerY
        /// center x/y relation
        case center
        
        /// w/h relation
        case size(CGFloat, CGFloat)
        
        /// offset in any direction relation
        case offset(CGFloat)
        
        public static func size(_ size: QXSize) -> Relation {
            return .size(size.w, size.h)
        }
        public static func size(_ size: CGSize) -> Relation {
            return .size(size.width, size.height)
        }
        
    }
    
}

extension QXRect {
    
    /// rect inside
    public func insideRect(_ relations: QXRect.Relation...) -> QXRect {
        return insideRect(relations)
    }
    
    /// rect at top
    public func topRect(_ relations: QXRect.Relation...) -> QXRect {
        return topRect(relations)
    }
    
    /// rect at left
    public func leftRect(_ relations: QXRect.Relation...) -> QXRect {
        return leftRect(relations)
    }
    
    /// rect at bottom
    public func bottomRect(_ relations: QXRect.Relation...) -> QXRect {
        return bottomRect(relations)
    }
    
    /// rect at right
    public func rightRect(_ relations: QXRect.Relation...) -> QXRect {
        return rightRect(relations)
    }
    
}

extension QXRect {
    
    /// rect inside
    public func insideRect(_ relations: [QXRect.Relation]) -> QXRect {
        var helper = RelationsHelper(relations: relations)
        if helper.isCenter {
            if helper.left != nil || helper.right != nil {
                helper.isCenterY = true
            }
            if helper.top != nil || helper.bottom != nil {
                helper.isCenterX = true
            }
        }
        if helper.w == nil {
            if helper.isCenterX {
                if helper.left == nil && helper.right == nil {
                    helper.w = w
                } else if helper.left != nil && helper.right != nil {
                    helper.isCenterX = false
                }
            } else {
                if helper.left == nil {
                    helper.left = 0
                }
                if helper.right == nil {
                    helper.right = 0
                }
            }
        } else {
            if helper.isCenterX {
                helper.left = nil
                helper.right = nil
            } else {
                if helper.left != nil && helper.right != nil {
                    helper.left = nil
                    helper.right = nil
                    helper.isCenterX = true
                } else if helper.left == nil && helper.right == nil {
                    helper.isCenterX = true
                }
            }
        }
        if helper.h == nil {
            if helper.isCenterY {
                if helper.top == nil && helper.bottom == nil {
                    helper.h = h
                } else if helper.top != nil && helper.bottom != nil {
                    helper.isCenterY = false
                }
            } else {
                if helper.top == nil {
                    helper.top = 0
                }
                if helper.bottom == nil {
                    helper.bottom = 0
                }
            }
        } else {
            if helper.isCenterY {
                helper.top = nil
                helper.bottom = nil
            } else {
                if helper.top != nil && helper.bottom != nil {
                    helper.top = nil
                    helper.bottom = nil
                    helper.isCenterY = true
                } else if helper.top == nil && helper.bottom == nil {
                    helper.isCenterY = true
                }
            }
        }
        var rect = QXRect()
        if let _top = helper.top {
            rect.top = top + _top
        }
        if let _left = helper.left {
            rect.left = left + _left
        }
        if let _bottom = helper.bottom {
            rect.bottom = bottom - _bottom
        }
        if let _right = helper.right {
            rect.right = right - _right
        }
        if let _w = helper.w {
            rect.w = _w
        }
        if let _h = helper.h {
            rect.h = _h
        }
        if helper.isCenterX {
            rect.centerX = centerX
        }
        if helper.isCenterY {
            rect.centerY = centerY
        }
        return rect
    }
    
    /// rect at top
    public func topRect(_ relations: [QXRect.Relation]) -> QXRect {
        var helper = RelationsHelper(relations: relations)
        if let bottom = helper.bottom {
            if helper.offset == nil {
                helper.offset = bottom
            }
        }
        if helper.isCenter {
            helper.isCenterX = true
        }
        if helper.h == nil {
            helper.h = h
        }
        if helper.w == nil {
            if helper.left == nil && helper.right == nil {
                helper.w = w
                helper.isCenterX = true
            } else if helper.left == nil {
                if !helper.isCenterX {
                    helper.left = 0
                }
            } else if helper.right == nil {
                if !helper.isCenterX {
                    helper.right = 0
                }
            } else {
                if helper.isCenterX {
                    helper.isCenterX = false
                }
            }
        } else {
            if helper.left == nil && helper.right == nil {
                helper.isCenterX = true
            } else if helper.left == nil {
                if helper.isCenterX {
                    helper.right = nil
                }
            } else if helper.right == nil {
                if helper.isCenterX {
                    helper.left = nil
                }
            } else {
                helper.isCenterX = true
                helper.left = nil
                helper.right = nil
            }
        }
        var rect = QXRect()
        if let _left = helper.left {
            rect.left = left + _left
        }
        if let _right = helper.right {
            rect.right = right - _right
        }
        if let _offset = helper.offset {
            rect.bottom = top - _offset
        } else {
            rect.bottom = top
        }
        if let _w = helper.w {
            rect.w = _w
        }
        if let _h = helper.h {
            rect.h = _h
        }
        if helper.isCenterX {
            rect.centerX = centerX
        }
        return rect
    }
    
    /// rect at left
    public func leftRect(_ relations: [QXRect.Relation]) -> QXRect {
        var helper = RelationsHelper(relations: relations)
        if let right = helper.right {
            if helper.offset == nil {
                helper.offset = right
            }
        }
        if helper.isCenter {
            helper.isCenterY = true
        }
        if helper.w == nil {
            helper.w = w
        }
        if helper.h == nil {
            if helper.top == nil && helper.bottom == nil {
                helper.h = h
                helper.isCenterY = true
            } else if helper.top == nil {
                if !helper.isCenterY {
                    helper.top = 0
                }
            } else if helper.bottom == nil {
                if !helper.isCenterY {
                    helper.bottom = 0
                }
            } else {
                if helper.isCenterY {
                    helper.isCenterY = false
                }
            }
        } else {
            if helper.top == nil && helper.bottom == nil {
                helper.isCenterY = true
            } else if helper.top == nil {
                if helper.isCenterY {
                    helper.bottom = nil
                }
            } else if helper.bottom == nil {
                if helper.isCenterY {
                    helper.top = nil
                }
            } else {
                helper.isCenterY = true
                helper.top = nil
                helper.bottom = nil
            }
        }
        var rect = QXRect()
        if let _top = helper.top {
            rect.top = top + _top
        }
        if let _bottom = helper.bottom {
            rect.bottom = bottom - _bottom
        }
        if let _offset = helper.offset {
            rect.right = left - _offset
        } else {
            rect.right = left
        }
        if let _w = helper.w {
            rect.w = _w
        }
        if let _h = helper.h {
            rect.h = _h
        }
        if helper.isCenterY {
            rect.centerY = centerY
        }
        return rect
    }
    
    /// rect at bottom
    public func bottomRect(_ relations: [QXRect.Relation]) -> QXRect {
        var helper = RelationsHelper(relations: relations)
        if let top = helper.top {
            if helper.offset == nil {
                helper.offset = top
            }
        }
        if helper.isCenter {
            helper.isCenterX = true
        }
        if helper.h == nil {
            helper.h = h
        }
        if helper.w == nil {
            if helper.left == nil && helper.right == nil {
                helper.w = w
                helper.isCenterX = true
            } else if helper.left == nil {
                if !helper.isCenterX {
                    helper.left = 0
                }
            } else if helper.right == nil {
                if !helper.isCenterX {
                    helper.right = 0
                }
            } else {
                if helper.isCenterX {
                    helper.isCenterX = false
                }
            }
        } else {
            if helper.left == nil && helper.right == nil {
                helper.isCenterX = true
            } else if helper.left == nil {
                if helper.isCenterX {
                    helper.right = nil
                }
            } else if helper.right == nil {
                if helper.isCenterX {
                    helper.left = nil
                }
            } else {
                helper.isCenterX = true
                helper.left = nil
                helper.right = nil
            }
        }
        var rect = QXRect()
        if let _left = helper.left {
            rect.left = left + _left
        }
        if let _right = helper.right {
            rect.right = right - _right
        }
        if let _offset = helper.offset {
            rect.top = bottom + _offset
        } else {
            rect.top = bottom
        }
        if let _w = helper.w {
            rect.w = _w
        }
        if let _h = helper.h {
            rect.h = _h
        }
        if helper.isCenterX {
            rect.centerX = centerX
        }
        return rect
    }
    
    /// rect at right
    public func rightRect(_ relations: [QXRect.Relation]) -> QXRect {
        var helper = RelationsHelper(relations: relations)
        if let left = helper.left {
            if helper.offset == nil {
                helper.offset = left
            }
        }
        if helper.isCenter {
            helper.isCenterY = true
        }
        if helper.w == nil {
            helper.w = w
        }
        if helper.h == nil {
            if helper.top == nil && helper.bottom == nil {
                helper.h = h
                helper.isCenterY = true
            } else if helper.top == nil {
                if !helper.isCenterY {
                    helper.top = 0
                }
            } else if helper.bottom == nil {
                if !helper.isCenterY {
                    helper.bottom = 0
                }
            } else {
                if helper.isCenterY {
                    helper.isCenterY = false
                }
            }
        } else {
            if helper.top == nil && helper.bottom == nil {
                helper.isCenterY = true
            } else if helper.top == nil {
                if helper.isCenterY {
                    helper.bottom = nil
                }
            } else if helper.bottom == nil {
                if helper.isCenterY {
                    helper.top = nil
                }
            } else {
                helper.isCenterY = true
                helper.top = nil
                helper.bottom = nil
            }
        }
        var rect = QXRect()
        if let _top = helper.top {
            rect.top = top + _top
        }
        if let _bottom = helper.bottom {
            rect.bottom = bottom - _bottom
        }
        if let _offset = helper.offset {
            rect.left = right + _offset
        } else {
            rect.left = right
        }
        if let _w = helper.w {
            rect.w = _w
        }
        if let _h = helper.h {
            rect.h = _h
        }
        if helper.isCenterY {
            rect.centerY = centerY
        }
        return rect
    }
    
}

extension QXRect {
    
    fileprivate struct RelationsHelper {
        var top: CGFloat?
        var left: CGFloat?
        var bottom: CGFloat?
        var right: CGFloat?
        var w: CGFloat?
        var h: CGFloat?
        var offset: CGFloat?
        var isCenterX: Bool = false
        var isCenterY: Bool = false
        var isCenter: Bool = false
        var anchorX: CGFloat = 0.5
        var anchorY: CGFloat = 0.5
        init(relations: [Relation]) {
            for relation in relations {
                switch relation {
                case .left(let value):
                    left = value
                case .right(let value):
                    right = value
                case .top(let value):
                    top = value
                case .bottom(let value):
                    bottom = value
                case .width(let value):
                    w = value
                case .height(let value):
                    h = value
                case .size(let value0, let value1):
                    w = value0
                    h = value1
                case .centerX:
                    isCenterX = true
                case .centerY:
                    isCenterY = true
                case .center:
                    isCenter = true
                case .offset(let value):
                    offset = value
                }
            }
        }
    }
    
}

