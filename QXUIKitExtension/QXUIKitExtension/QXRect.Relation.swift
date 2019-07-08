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
 * width/height > left+right = top+bottom > center/centerX/centerY > top/left/bottom/right
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
        
        /// width relation
        case width(CGFloat)
        /// height relation
        case height(CGFloat)
        
        /// center x relation
        case centerX
        /// center y relation
        case centerY
        /// center x/y relation
        case center
        
        /// width/height relation
        case size(CGFloat, CGFloat)
        
        /// offset in any direction relation
        case offset(CGFloat)
        
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
        if helper.width == nil {
            if helper.isCenterX {
                if helper.left == nil && helper.right == nil {
                    helper.width = width
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
        if helper.height == nil {
            if helper.isCenterY {
                if helper.top == nil && helper.bottom == nil {
                    helper.height = height
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
        if let _width = helper.width {
            rect.width = _width
        }
        if let _height = helper.height {
            rect.height = _height
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
        if helper.height == nil {
            helper.height = height
        }
        if helper.width == nil {
            if helper.left == nil && helper.right == nil {
                helper.width = width
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
        if let _width = helper.width {
            rect.width = _width
        }
        if let _height = helper.height {
            rect.height = _height
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
        if helper.width == nil {
            helper.width = width
        }
        if helper.height == nil {
            if helper.top == nil && helper.bottom == nil {
                helper.height = height
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
        if let _width = helper.width {
            rect.width = _width
        }
        if let _height = helper.height {
            rect.height = _height
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
        if helper.height == nil {
            helper.height = height
        }
        if helper.width == nil {
            if helper.left == nil && helper.right == nil {
                helper.width = width
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
        if let _width = helper.width {
            rect.width = _width
        }
        if let _height = helper.height {
            rect.height = _height
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
        if helper.width == nil {
            helper.width = width
        }
        if helper.height == nil {
            if helper.top == nil && helper.bottom == nil {
                helper.height = height
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
        if let _width = helper.width {
            rect.width = _width
        }
        if let _height = helper.height {
            rect.height = _height
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
        var width: CGFloat?
        var height: CGFloat?
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
                    width = value
                case .height(let value):
                    height = value
                case .size(let value0, let value1):
                    width = value0
                    height = value1
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

