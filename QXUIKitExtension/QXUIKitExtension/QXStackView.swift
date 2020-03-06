//
//  QXStackView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/8/15.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXStackView: QXView {
    
    public var isVertical: Bool = false
    public var alignmentX: QXAlignmentX = .left
    public var alignmentY: QXAlignmentY = .top
    
    public var viewMargin: CGFloat = 0
    public private(set) var compressOrder: [Int] = []
    public var compressMinSize: QXSize = QXSize(30, 30)
    
    /// 是否允许背景的点击，允许后背景不能穿透
    public var isBackUserInteractionEnabled: Bool = false
    
    public convenience init(views: [QXViewProtocol]) {
        self.init()
        self.views = views
    }
    public convenience init(views: [QXViewProtocol], viewMargin: CGFloat) {
        self.init()
        self.viewMargin = viewMargin
        self.views = views
    }
    public convenience init(views: [QXViewProtocol], isVertical: Bool, viewMargin: CGFloat) {
        self.init()
        self.isVertical = isVertical
        self.viewMargin = viewMargin
        self.views = views
    }
    
    open var views: [QXViewProtocol] = [] {
        didSet {
            for view in subviews {
                 view.removeFromSuperview()
             }
             for e in views {
                 if let e = e as? QXView {
                     e.respondNeedsLayout = { [weak self] in
                         self?.qxSetNeedsLayout()
                     }
                 }
             }
             var sortInfos: [(i: Int, compressResistance: CGFloat)] = []
             for (i, v) in views.enumerated() {
                 if isVertical {
                     sortInfos.append((i, v.compressResistanceY))
                 } else {
                     sortInfos.append((i, v.compressResistanceX))
                 }
             }
             sortInfos = sortInfos.reversed().sorted(by: { $0.compressResistance < $1.compressResistance })
             self.compressOrder = sortInfos.map({ $0.i })
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
        if isVertical {
            let size = viewsfixSizeWithoutFlexs()
            var compressInfo: [Int: QXSize] = [:]
            var divideInfo: [Int: CGFloat] = [:]
            var flexInfo: [Int: CGFloat] = [:]
            if size.h > bounds.height {
                var needCollapseH = size.h - bounds.height
                for i in compressOrder {
                    let view = views[i]
                    if let view = view as? QXView, view.isDisplay {
                        let size = view.natureSize
                        if size.h > needCollapseH {
                            compressInfo[i] = QXSize(size.w, size.h - needCollapseH)
                            break
                        } else {
                            var h = compressMinSize.h
                            if h > size.h {
                                h = size.h
                            }
                            if let e = view.minHeight {
                                h = max(e, h)
                            }
                            needCollapseH -= size.h - h
                            compressInfo[i] = QXSize(size.w, h)
                        }
                    }
                }
            } else {
                var divides: [(Int, CGFloat)] = []
                var totalDivide: CGFloat = 0
                for (i, view) in views.enumerated() {
                    if let e = view.divideRatioY {
                        divides.append((i, e))
                        totalDivide += e
                    }
                }
                if divides.count > 0 && totalDivide > 0 {
                    let h = bounds.height - size.h
                    for e in divides {
                        divideInfo[e.0] = h * e.1 / totalDivide
                    }
                }
                if divideInfo.count == 0 {
                    var flexs: [(Int, CGFloat)] = []
                    var total: CGFloat = 0
                    for (i, view) in views.enumerated() {
                        if let e = view as? QXFlexSpace {
                            flexs.append((i, e.ratio))
                            total += e.ratio
                        }
                    }
                    if flexs.count > 0 && total > 0 {
                        let h = bounds.height - size.h
                        for e in flexs {
                            flexInfo[e.0] = h * e.1 / total
                        }
                    }
                }
            }
            let contentH = min(size.h - padding.top - padding.bottom, bounds.height - padding.top - padding.bottom)
            var offsetY: CGFloat = padding.top
            switch alignmentY {
            case .top:
                offsetY = padding.top
            case .center:
                if divideInfo.count == 0 && flexInfo.count == 0 {
                    offsetY = (bounds.height - padding.top - padding.bottom - contentH) / 2 + padding.top
                }
            case .bottom:
                if divideInfo.count == 0 && flexInfo.count == 0 {
                    offsetY = bounds.height - contentH - padding.bottom
                }
            }
            for (i, view) in views.enumerated() {
                if view.isDisplay {
                    var wh = view.natureSize
                    if let e = compressInfo[i] {
                        wh = e
                    }
                    if let e = divideInfo[i] {
                        wh.h = e
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
                    view.updateRect(QXRect(offsetX, offsetY, w, wh.h))
                    offsetY += wh.h + viewMargin
                }
                if let h = flexInfo[i] {
                    offsetY += h
                }
            }
        } else {
            let size = viewsfixSizeWithoutFlexs()
            var compressInfo: [Int: QXSize] = [:]
            var divideInfo: [Int: CGFloat] = [:]
            var flexInfo: [Int: CGFloat] = [:]
            if size.w >= bounds.width {
                var needCollapseW = size.w - bounds.width
                for i in compressOrder {
                    let view = views[i]
                    if let view = view as? QXView, view.isDisplay {
                        let size = view.natureSize
                        if size.w > needCollapseW {
                            compressInfo[i] = QXSize(size.w - needCollapseW, size.h)
                            break
                        } else {
                            var w = compressMinSize.w
                            if w > size.w {
                                w = size.w
                            }
                            if let e = view.minWidth {
                                w = max(e, w)
                            }
                            needCollapseW -= size.w - w
                            compressInfo[i] = QXSize(w, size.h)
                        }
                    }
                }
            } else {
                var divides: [(Int, CGFloat)] = []
                var totalDivide: CGFloat = 0
                for (i, view) in views.enumerated() {
                    if let e = view.divideRatioX {
                        divides.append((i, e))
                        totalDivide += e
                    }
                }
                if divides.count > 0 && totalDivide > 0 {
                    let w = bounds.width - size.w
                    for e in divides {
                        divideInfo[e.0] = w * e.1 / totalDivide
                    }
                }
                if divideInfo.count == 0 {
                    var flexs: [(Int, CGFloat)] = []
                    var totalFlex: CGFloat = 0
                    for (i, view) in views.enumerated() {
                        if let e = view as? QXFlexSpace {
                            flexs.append((i, e.ratio))
                            totalFlex += e.ratio
                        } else if let e = view.divideRatioX {
                            divides.append((i, e))
                            totalDivide += e
                        }
                    }
                    if flexs.count > 0 && totalFlex > 0 {
                        let w = bounds.width - size.w
                        for e in flexs {
                            flexInfo[e.0] = w * e.1 / totalFlex
                        }
                    }
                }
            }
            let contentW = min(size.w - padding.left - padding.right, bounds.width - padding.left - padding.right)
            var offsetX: CGFloat = padding.left
            switch alignmentX {
            case .left:
                break
            case .center:
                if divideInfo.count == 0 && flexInfo.count == 0 {
                    offsetX = (bounds.width - padding.left - padding.right - contentW) / 2 + padding.left
                }
            case .right:
                if divideInfo.count == 0 && flexInfo.count == 0 {
                    offsetX = bounds.width - contentW - padding.right
                }
            }
            for (i, view) in views.enumerated() {
                if !(view is QXFlexSpace) && view.isDisplay {
                    var wh = view.natureSize
                    if let e = compressInfo[i] {
                        wh = e
                    }
                    if let e = divideInfo[i] {
                        wh.w = e
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
                    view.updateRect(QXRect(offsetX, offsetY, wh.w, h))
                    offsetX += wh.w + viewMargin
                }
                if let w = flexInfo[i] {
                    offsetX += w
                }
            }
        }

    }
    
    open override func natureContentSize() -> QXSize {
        if views.count == 0 {
            return QXSize.zero
        }
        let wh = viewsfixSizeWithoutFlexs()
        var w: CGFloat = wh.w
        var h: CGFloat = wh.h
        
        if let e = maxWidth {
            w = min(e, w)
        } else {
            if !isVertical {
                if let _ = views.first(where: { $0 is QXFlexSpace }) {
                    w = QXView.extendLength
                }
            }
        }
        if let e = maxHeight {
            h = min(e, h)
        } else {
            if isVertical {
               if let _ = views.first(where: { $0 is QXFlexSpace }) {
                   h = QXView.extendLength
               }
            }
        }
        return QXSize(w, h)
    }

    private func viewsfixSizeWithoutFlexs() -> QXSize {
        var w: CGFloat = 0
        var h: CGFloat = 0
        var showCount: Int = 0
        if isVertical {
            for view in views {
                if !(view is QXFlexSpace) && view.isDisplay {
                    let size = view.natureSize
                    if view.divideRatioY == nil {
                        h += size.h
                    }
                    w = max(w, size.w)
                    showCount += 1
                }
            }
            if showCount == 0 {
                return QXSize.zero
            }
            h += padding.top + padding.bottom + viewMargin * CGFloat(showCount - 1)
            w += padding.left + padding.right
        } else {
            for view in views {
                if !(view is QXFlexSpace) && view.isDisplay {
                    let size = view.natureSize
                    if view.divideRatioX == nil {
                        w += size.w
                    }
                    h = max(h, size.h)
                    showCount += 1
                }
            }
            if showCount == 0 {
                return QXSize.zero
            }
            w += padding.left + padding.right + viewMargin * CGFloat(showCount - 1)
            h += padding.top + padding.bottom
        }
        return QXSize(w, h)
    }
    
}
