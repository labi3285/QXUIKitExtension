//
//  QXArrangeView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/29.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXArrangeView: QXView {
        
    public var alignmentX: QXAlignmentX = .left

    public var viewMarginX: CGFloat = 10
    public var viewMarginY: CGFloat = 10
    public var lineAlignment: QXAlignmentY = .center
    
    /// 是否允许背景的点击，允许后背景不能穿透
    public var isBackUserInteractionEnabled = false
    
    public convenience init(views: [QXViewProtocol]) {
        self.init()
        self.views = views
    }
    public convenience init(views: [QXViewProtocol], viewMarginX: CGFloat, viewMarginY: CGFloat) {
        self.init()
        self.viewMarginX = viewMarginX
        self.viewMarginY = viewMarginY
        self.views = views
    }
        
    open var views: [QXViewProtocol] = [] {
        didSet {
            for view in subviews {
                view.removeFromSuperview()
            }
            for view in views {
                view.addAsQXSubview(self)
            }
            qxSetNeedsLayout()
        }
    }
    
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let view = super.hitTest(point, with: event) {
            if view === self && !isBackUserInteractionEnabled {
                return nil
            } else {
                return view
            }
        } else {
            return nil
        }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        for e in _viewRects(bounds.width) {
            e.view.updateRect(e.rect)
        }
    }
    
    private func _viewRects(_ width: CGFloat) -> [(view: QXViewProtocol, rect: QXRect)] {
        let showViews = views.compactMap({ $0.isDisplay ? $0 : nil })
        var x: CGFloat = padding.left
        var linesSizes: [[(size: QXSize?, space: CGFloat?, flex: CGFloat?)]] = []
        var lineSizes: [(size: QXSize?, space: CGFloat?, flex: CGFloat?)] = []
        for e in showViews {
            let wh = e.natureSize
            // 0.3 为误差范围
            if x + wh.w <= width - padding.right + 0.3 {
                if e is UIView {
                    x += wh.w + viewMarginX
                    lineSizes.append((wh, nil, nil))
                } else if let e = e as? QXSpace {
                    x += wh.w
                    lineSizes.append((nil, e.w, nil))
                } else if let e = e as? QXFlexSpace {
                    lineSizes.append((nil, nil, e.ratio))
                }
            } else {
                if lineSizes.count > 0 {
                    linesSizes.append(lineSizes)
                }
                if e is UIView {
                    x = padding.left + wh.w + viewMarginX
                    lineSizes = [(wh, nil, nil)]
                } else if let e = e as? QXSpace {
                    x = padding.left + e.w
                    lineSizes = [(nil, e.w, nil)]
                } else if let e = e as? QXFlexSpace {
                    lineSizes = [(nil, nil, e.ratio)]
                }
            }
        }
        if lineSizes.count > 0 {
            linesSizes.append(lineSizes)
        }
        var y: CGFloat = padding.top
        var rects: [QXRect] = []
        for arr in linesSizes {
            var maxH: CGFloat = 0
            for e in arr {
                if let e = e.size {
                    maxH = max(maxH, e.h)
                }
            }
            var lineViewsW: CGFloat = 0
            var totalFlex: CGFloat = 0
            for (i, e) in arr.enumerated() {
                if let e = e.size {
                    if i == arr.count - 1 {
                        lineViewsW += e.w
                    } else {
                        lineViewsW += e.w + viewMarginX
                    }
                } else if let e = e.space {
                    lineViewsW += e
                } else if let e = e.flex {
                    totalFlex += e
                }
            }
            let lineFlexSpace = width - lineViewsW - padding.left - padding.right
            x = padding.left
            switch alignmentX {
            case .left:
                break
            case .center:
                if arr.first(where: {$0.flex != nil}) == nil {
                    x += lineFlexSpace / 2
                } else {
                    break
                }
            case .right:
                if arr.first(where: {$0.flex != nil}) == nil {
                    x += lineFlexSpace
                } else {
                    break
                }
            }
            for e in arr {
                if let e = e.size {
                    let dy: CGFloat
                    switch lineAlignment {
                    case .top:
                        dy = 0
                    case .center:
                        dy = (maxH - e.h) / 2
                    case .bottom:
                        dy = maxH - e.h
                    }
                    rects.append(QXRect(x, y + dy, e.w, e.h))
                    x += e.w + viewMarginX
                } else if let e = e.space {
                    rects.append(QXRect(x, y, e, 0))
                    x += e
                } else if let e = e.flex {
                    let w = lineFlexSpace * e / totalFlex
                    rects.append(QXRect(x, y, w, 0))
                    x += w
                }
            }
            y += maxH + viewMarginY
        }
        var viewRects: [(view: QXViewProtocol, rect: QXRect)] = []
        for (i, e) in rects.enumerated() {
            viewRects.append((showViews[i], e))
        }
        return viewRects
    }
        
    open override func natureContentSize() -> QXSize {
        if views.count == 0 {
            return QXSize.zero
        }
        let w = maxWidth ?? fixWidth ?? QXView.extendLength
        var maxX: CGFloat = 0
        var maxY: CGFloat = 0
        for e in _viewRects(w) {
            maxX = max(maxX, e.rect.right)
            maxY = max(maxY, e.rect.bottom)
        }
        return QXSize(maxX + padding.right, maxY + padding.bottom)
    }
    
}
