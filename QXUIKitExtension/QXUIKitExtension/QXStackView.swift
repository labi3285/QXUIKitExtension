//
//  QXStackView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/8/15.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

public class QXFlexView: QXView {
    
}

open class QXStackView: QXView {
    
    public var isVertical: Bool = false
    public var alignmentX: QXAlignmentX = .left
    public var alignmentY: QXAlignmentY = .top
    
    public var padding: QXMargin = QXMargin.zero
    public var viewMargin: CGFloat = 0
    public let views: [QXView]
    public let collapseOrder: [Int]
    public var collapseMinSize: QXSize = QXSize(30, 30)
    
    public convenience init(_ views: QXView...) {
        var orders: [Int] = []
        for (i, _) in views.enumerated() {
            orders.append(views.count - 1 - i)
        }
        self.init(views, collapseOrder: orders)
    }
    
    public required init(_ views: [QXView], collapseOrder: [Int]) {
        self.views = views
        self.collapseOrder = collapseOrder
        super.init(frame: CGRect.zero)
        for view in views {
            if !(view is QXFlexView) {
                addSubview(view)
            }
        }
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if isVertical {
            let size = qxIntrinsicContentSize
            var collapseInfo: [Int: QXSize] = [:]
            var flexInfo: [Int: CGFloat] = [:]
            if size.h > bounds.height {
                var needCollapseH = size.h - bounds.height
                for i in collapseOrder {
                    let view = views[i]
                    if view.isDisplay && !(view is QXFlexView) {
                        let size = view.qxIntrinsicContentSize
                        if size.h > needCollapseH {
                            collapseInfo[i] = QXSize(size.w, size.h - needCollapseH)
                            break
                        } else {
                            needCollapseH -= size.h - collapseMinSize.h
                            collapseInfo[i] = QXSize(size.w, collapseMinSize.h)
                        }
                    }
                }
            } else {
                var idxs: [Int] = []
                for (i, view) in views.enumerated() {
                    if view is QXFlexView {
                        idxs.append(i)
                    }
                }
                if idxs.count > 0 {
                    let h = (bounds.height - size.h) / CGFloat(idxs.count)
                    for i in idxs {
                        flexInfo[i] = h
                    }
                }
            }
            let contentH = min(size.h - padding.top - padding.bottom, bounds.height - padding.top - padding.bottom)
            var offsetY: CGFloat = 0
            switch alignmentY {
            case .top:
                offsetY = padding.top
            case .center:
                offsetY = (bounds.height - padding.top - padding.bottom - contentH) / 2 + padding.top
            case .bottom:
                offsetY = bounds.height - contentH - padding.bottom
            }
            for (i, view) in views.enumerated() {
                if view.isDisplay {
                    var wh = view.qxIntrinsicContentSize
                    if let e = collapseInfo[i] {
                        wh = e
                    }
                    let w = min(wh.w, bounds.width - padding.left - padding.right)
                    var offsetX: CGFloat = 0
                    switch alignmentX {
                    case .left:
                        offsetX = padding.left
                    case .center:
                        offsetX = (bounds.width - padding.left - padding.right - w) / 2 + padding.left
                    case .right:
                        offsetX = bounds.width - w - padding.right
                    }
                    view.frame = CGRect(x: offsetX, y: offsetY, width: w, height: wh.h)
                    offsetY += wh.h + viewMargin
                }
                if let h = flexInfo[i] {
                    offsetY += h
                }
            }
        } else {
            let size = qxIntrinsicContentSize
            var collapseInfo: [Int: QXSize] = [:]
            var flexInfo: [Int: CGFloat] = [:]
            if size.w >= bounds.width {
                var needCollapseW = size.w - bounds.width
                for i in collapseOrder {
                    let view = views[i]
                    if view.isDisplay && !(view is QXFlexView) {
                        let size = view.qxIntrinsicContentSize
                        if size.w > needCollapseW {
                            collapseInfo[i] = QXSize(size.w - needCollapseW, size.h)
                            break
                        } else {
                            needCollapseW -= size.w - collapseMinSize.w
                            collapseInfo[i] = QXSize(collapseMinSize.w, size.h)
                        }
                    }
                }
            } else {
                var idxs: [Int] = []
                for (i, view) in views.enumerated() {
                    if view is QXFlexView {
                        idxs.append(i)
                    }
                }
                if idxs.count > 0 {
                    let w = (bounds.width - size.w) / CGFloat(idxs.count)
                    for i in idxs {
                        flexInfo[i] = w
                    }
                }
            }
            let contentW = min(size.w - padding.left - padding.right, bounds.width - padding.left - padding.right)
            var offsetX: CGFloat = 0
            switch alignmentX {
            case .left:
                offsetX = padding.left
            case .center:
                offsetX = (bounds.width - padding.left - padding.right - contentW) / 2 + padding.left
            case .right:
                offsetX = bounds.width - contentW - padding.right
            }
            for (i, view) in views.enumerated() {
                if view.isDisplay && !(view is QXFlexView) {
                    var wh = view.qxIntrinsicContentSize
                    if let e = collapseInfo[i] {
                        wh = e
                    }
                    let h = min(wh.h, bounds.height - padding.top - padding.bottom)
                    var offsetY: CGFloat = 0
                    switch alignmentY {
                    case .top:
                        offsetY = padding.top
                    case .center:
                        offsetY = (bounds.height - padding.top - padding.bottom - h) / 2 + padding.top
                    case .bottom:
                        offsetY = bounds.height - h - padding.bottom
                    }
                    view.frame = CGRect(x: offsetX, y: offsetY, width: wh.w, height: h)
                    offsetX += wh.w + viewMargin
                }
                if let w = flexInfo[i] {
                    offsetX += w
                }
            }
        }

    }
    
    open override var intrinsicContentSize: CGSize {
        if views.count == 0 || !isDisplay {
            return CGSize.zero
        }
        var w: CGFloat = 0
        var h: CGFloat = 0
        var showCount: Int = 0
        if isVertical {
            for view in views {
                if view.isDisplay {
                    let size = view.qxIntrinsicContentSize
                    h += size.h
                    w = max(w, size.w)
                    showCount += 1
                }
            }
            if showCount == 0 {
                return CGSize.zero
            }
            h += padding.top + padding.bottom + viewMargin * CGFloat(showCount - 1)
            w += padding.left + padding.right
        } else {
            for view in views {
                if view.isDisplay && !(view is QXFlexView) {
                    let size = view.qxIntrinsicContentSize
                    w += size.w
                    h = max(h, size.h)
                    showCount += 1
                }
            }
            if showCount == 0 {
                return CGSize.zero
            }
            w += padding.left + padding.right + viewMargin * CGFloat(showCount - 1)
            h += padding.top + padding.bottom
        }
        return CGSize(width: w, height: h)
    }
    
}
