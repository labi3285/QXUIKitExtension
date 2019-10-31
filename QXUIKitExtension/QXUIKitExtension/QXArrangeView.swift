//
//  QXArrangeView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/29.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXArrangeView: QXView {
        
    public var viewMarginX: CGFloat = 10
    public var viewMarginY: CGFloat = 10
    public var lineAlignment: QXAlignmentY = .center
    
    public private(set) var views: [QXView] = []
    
    public func setupViews(_ views: QXView...) {
        setupViews(views)
    }
    
    open func applyConfigs(intrinsicWidth: CGFloat, xCount: Int, hwRatio: CGFloat) {
        QXDebugAssert(intrinsicWidth > 0)
        QXDebugAssert(xCount > 0)
        QXDebugAssert(hwRatio > 0)
        self.intrinsicWidth = intrinsicWidth
        let w = (intrinsicWidth - padding.left - padding.right - CGFloat(xCount - 1) * viewMarginX) / CGFloat(xCount)
        let h = w * hwRatio
        for view in views {
            view.intrinsicSize = QXSize(w, h)
        }
    }
    
    open func applyConfigs(viewsWidth: CGFloat, viewsHeight: CGFloat) {
        QXDebugAssert(viewsWidth > 0)
        QXDebugAssert(viewsHeight > 0)
        for view in views {
            view.intrinsicSize = QXSize(viewsWidth, viewsHeight)
        }
    }

    public func setupViews(_ views: [QXView]) {
        for view in subviews {
            view.removeFromSuperview()
        }
        self.views = views
        for view in views {
            addSubview(view)
        }
        qxSetNeedsLayout()
    }
    
//    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
//        if let _ = super.hitTest(point, with: event) {
//              for view in subviews {
//                  if view.isUserInteractionEnabled {
//                      let point = view.convert(point, from: self)
//                      if view.point(inside: point, with: event) {
//                          return view.hitTest(point, with: event)
//                      }
//                  }
//              }
//              return nil
//        }
//        return nil
//    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        for e in _viewFrames(bounds.width) {
            e.view.frame = e.frame
        }
    }
    
    private func _viewFrames(_ width: CGFloat) -> [(view: QXView, frame: CGRect)] {
        let showViews = views.compactMap({ $0.isDisplay ? $0 : nil })
        let whs = showViews.map({ $0.intrinsicContentSize })
        var x: CGFloat = padding.left
        var linesSizes: [[CGSize]] = []
        var lineSizes: [CGSize] = []
        for e in whs {
            if x + e.width <= width - padding.right {
                x += e.width + viewMarginX
                lineSizes.append(e)
            } else {
                if lineSizes.count > 0 {
                    linesSizes.append(lineSizes)
                }
                x = padding.left
                lineSizes = [e]
                x += e.width + viewMarginX
            }
        }
        if lineSizes.count > 0 {
            linesSizes.append(lineSizes)
        }
        var y: CGFloat = padding.top
        var frames: [CGRect] = []
        for arr in linesSizes {
            var maxH: CGFloat = 0
            for e in arr {
                maxH = max(maxH, e.height)
            }
            x = padding.left
            for e in arr {
                let offsetY: CGFloat
                switch lineAlignment {
                case .top:
                    offsetY = 0
                case .center:
                    offsetY = (maxH - e.height) / 2
                case .bottom:
                    offsetY = maxH - e.height
                }
                frames.append(CGRect(x: x, y: y + offsetY, width: e.width, height: e.height))
                x += e.width + viewMarginX
            }
            y += maxH + viewMarginY
        }
        var viewFrames: [(view: QXView, frame: CGRect)] = []
        for (i, e) in frames.enumerated() {
            viewFrames.append((showViews[i], e))
        }
        return viewFrames
    }
    
    public var intrinsicWidth: CGFloat?
    open override var intrinsicContentSize: CGSize {
        if views.count == 0 || !isDisplay {
            return CGSize.zero
        }
        let w = intrinsicWidth ?? CGFloat.greatestFiniteMagnitude
        var maxX: CGFloat = 0
        var maxY: CGFloat = 0
        for e in _viewFrames(w) {
            maxX = max(maxX, e.frame.maxX)
            maxY = max(maxY, e.frame.maxY)
        }
        return CGSize(width: maxX + padding.right, height: maxY + padding.bottom)
    }
    
}
