//
//  QXSegmentView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/12/3.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXSegmentIndicatorView: UIView {
    
    public var widthHandler: ((_ segmentWidth: CGFloat) -> CGFloat)?
    
    open func width(_ segmentWidth: CGFloat) -> CGFloat {
        if let e = widthHandler {
            return e(segmentWidth)
        }
        var w = segmentWidth
        w -= 10 * 2
        w =  max(w, 40)
        return w
    }
    
    open func didUpdateRect(_ rect: QXRect) {
        
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        qxBackgroundColor = QXColor.dynamicAccent
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

open class QXSegmentView<Model>: QXView {
    
    fileprivate var respondClick: (() -> Void)?
    
    public var attributesNormal: [NSAttributedString.Key: Any]
        = QXFont(17, QXColor.dynamicAccent).nsAttributtes
    public var attributesSelected: [NSAttributedString.Key: Any]
        = QXFont(17, QXColor.dynamicTitle).nsAttributtes
    
    public var modelToStringParser: ((_ model: Model) -> String)?
    public var modelToNSAttributtedStringParser: ((_ model: Model, _ isSelected: Bool) -> NSAttributedString)?

    open func update(model: Model, isSelected: Bool) {
        if let e = modelToNSAttributtedStringParser {
            if isSelected {
                uiButton.setAttributedTitle(e(model, isSelected), for: .selected)
            } else {
                uiButton.setAttributedTitle(e(model, isSelected), for: .normal)
            }
        } else if let e = modelToStringParser {
            if isSelected {
                uiButton.setAttributedTitle(NSAttributedString(string: e(model), attributes: attributesSelected), for: .selected)
            } else {
                uiButton.setAttributedTitle(NSAttributedString(string: e(model), attributes: attributesNormal), for: .normal)
            }
        } else {
            if isSelected {
                uiButton.setAttributedTitle(NSAttributedString(string: "\(model)", attributes: attributesSelected), for: .selected)
            } else {
                uiButton.setAttributedTitle(NSAttributedString(string: "\(model)", attributes: attributesNormal), for: .normal)
            }
        }
    }
    
    public let model: Model
    open var isSelected: Bool = false {
        didSet {
            isUserInteractionEnabled = !isSelected
            uiButton.isSelected = isSelected
            update(model: model, isSelected: isSelected)
        }
    }
    
    public final lazy var uiButton: UIButton = {
        let e = UIButton()
        e.addTarget(self, action: #selector(click), for: .touchUpInside)
        return e
    }()
    @objc func click() {
        respondClick?()
    }
        
    public required init(_ model: Model) {
        self.model = model
        super.init()
        addSubview(uiButton)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        uiButton.qxRect = qxBounds.rectByReduce(padding)
    }
    open override func natureContentSize() -> QXSize {
        return uiButton.qxIntrinsicContentSize.sizeByAdd(padding)
    }
    
}

open class QXSegmentsView<Model>: QXView {
    
    open var segmentViews: [QXSegmentView<Model>] = [] {
        didSet {
            for e in oldValue {
                e.removeFromSuperview()
            }
            for e in segmentViews {
                e.respondClick = { [weak self, weak e] in
                    guard let ws = self, let btn = e else {
                        return
                    }
                    ws._selectIndex = ws.segmentViews.firstIndex(where: { $0 === btn }) ?? 0
                    ws.respondSelect?(ws._selectIndex, btn.model)
                    ws._checkOrChangeIndex(animated: true)
                }
                uiScrollView.addSubview(e)
            }
            setNeedsLayout()
        }
    }
    
    public var respondSelect: ((_ index: Int, _ model: Model) -> Void)?
    
    open func adjustOffset(animated: Bool) {
        if segmentViews.count == 0 {
             return
        }
        if _selectIndex < segmentViews.count {
            let e = segmentViews[_selectIndex]
            _adjustOffset(e, animated: animated)
        }
    }

    public var selectIndex: Int {
        set {
            scrollTo(index: newValue, animated: false)
        }
        get {
            return _selectIndex
        }
    }
    
    public func scrollTo(index: Int, animated: Bool) {
        _selectIndex = index
        _checkOrChangeIndex(animated: animated)
    }
    
    open var indicatorView: QXSegmentIndicatorView? {
        didSet {
            if let e = oldValue {
                e.removeFromSuperview()
            }
            if let e = indicatorView {
                uiScrollView.addSubview(e)
            }
        }
    }
    
    public enum IndicatorPossition {
        case top
        case bottom
        case back
        case front
    }
    public var indicatorPosition: IndicatorPossition = .bottom
    public var indicatorHeight: CGFloat = 2
    public var indicatorSegmentMargin: CGFloat = 0
    public var indicatorAlignmentX: QXAlignmentX = .center

    public var segmentAlignmentX: QXAlignmentX = .center
    public var segmentAlignmentY: QXAlignmentY = .center
    public var segmentMargin: CGFloat = 10
    
    public var edgesAutoScrollSpace: CGFloat = 60
    
    public final lazy var uiScrollView: UIScrollView = {
        let e = UIScrollView()
        e.showsHorizontalScrollIndicator = false
        e.showsVerticalScrollIndicator = false
        e.alwaysBounceHorizontal = false
        e.alwaysBounceVertical = false
        return e
    }()
        
    public override init() {
        super.init()
        addSubview(uiScrollView)
        padding = QXEdgeInsets(5, 15, 5, 15)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        let segsWH = _segmentsSize()
        let scrollW = bounds.width
        let scrollH = bounds.height
        let segsGH: CGFloat
        let segsY: CGFloat
        if indicatorView == nil {
            segsY = padding.top
            segsGH = bounds.height - padding.top - padding.bottom
        } else {
            switch indicatorPosition {
            case .top:
                segsY = padding.top + indicatorHeight + indicatorSegmentMargin
                segsGH = bounds.height - padding.top - padding.bottom - indicatorSegmentMargin - indicatorHeight
            case .back, .front:
                segsY = padding.top
                segsGH = bounds.height - padding.top - padding.bottom
            case .bottom:
                segsY = padding.top
                segsGH = bounds.height - padding.top - padding.bottom - indicatorSegmentMargin - indicatorHeight
            }
        }
        var divideInfo: [Int: CGFloat] = [:]
        if segsWH.w <= scrollW {
            var divides: [(Int, CGFloat)] = []
            var totalDivide: CGFloat = 0
            for (i, e) in segmentViews.enumerated() {
                if let e = e.divideRatioX {
                    divides.append((i, e))
                    totalDivide += e
                }
            }
            if divides.count > 0 && totalDivide > 0 {
                let space = scrollW - segsWH.w
                for e in divides {
                    divideInfo[e.0] = space * e.1 / totalDivide
                }
            }
        }
        let contentW = min(segsWH.w, scrollW - padding.left - padding.right)
        var offsetX: CGFloat = padding.left
        switch segmentAlignmentX {
        case .left:
            break
        case .center:
            if divideInfo.count == 0 {
                offsetX = padding.left + (scrollW - padding.left - padding.right - contentW) / 2
            }
        case .right:
            if divideInfo.count == 0 {
                offsetX = scrollW - contentW - padding.right
            }
        }
        for (i, e) in segmentViews.enumerated() {
            if e.isDisplay {
                var wh = e.natureSize
                if let e = divideInfo[i] {
                    wh.w = e
                }
                let h = min(wh.h, segsGH)
                let offsetY: CGFloat
                switch segmentAlignmentY {
                case .top:
                    offsetY = segsY
                case .center:
                    offsetY = segsY + (segsGH - h) / 2
                case .bottom:
                    offsetY = segsY + segsGH - h
                }
                e.updateRect(QXRect(offsetX, offsetY, wh.w, h))
                offsetX += wh.w + segmentMargin
            }
        }
        uiScrollView.frame = CGRect(x: 0, y: 0, width: scrollW, height: scrollH)
        uiScrollView.contentSize = CGSize(width: max(scrollW, segsWH.w + padding.left + padding.right), height: segsGH)
        _checkOrChangeIndex(animated: false)
    }
    
    open override func natureContentSize() -> QXSize {
        let segsWH = _segmentsSize()
        let w: CGFloat = segsWH.w + padding.left + padding.right
        var h: CGFloat = segsWH.h + padding.top + padding.bottom
        if let _ = indicatorView {
            switch indicatorPosition {
            case .top, .bottom:
                h += indicatorSegmentMargin + indicatorHeight
            case .back, .front:
                break
            }
        }
        return QXSize(w, h)
    }
    
    private var _selectIndex: Int = 0
    private func _checkOrChangeIndex(animated: Bool) {
        if segmentViews.count == 0 {
            return
        }
        for e in segmentViews {
            e.isSelected = false
        }
        if _selectIndex < segmentViews.count {
            let e = segmentViews[_selectIndex]
            e.isSelected = true
            if animated {
                UIView.animate(withDuration: 0.15, animations: {
                    self._indicatorRectUpdate(e)
                }) { (c) in
                    self._adjustOffset(e, animated: animated)
                }
            } else {
                _indicatorRectUpdate(e)
                _adjustOffset(e, animated: animated)
            }
        } else {
            QXDebugFatalError("index out of range")
        }
    }
    private func _adjustOffset(_ segmentView: QXView, animated: Bool) {
        let left = segmentView.frame.origin.x
        let right = segmentView.frame.origin.x + segmentView.frame.size.width
        if left - uiScrollView.contentOffset.x < edgesAutoScrollSpace {
            let r = CGRect(x: max(left - edgesAutoScrollSpace, 0), y: 0, width: 1, height: 1)
            uiScrollView.scrollRectToVisible(r, animated: animated)
        }
        if right - uiScrollView.contentOffset.x >= uiScrollView.bounds.width - edgesAutoScrollSpace {
            let r = CGRect(x: min(right + edgesAutoScrollSpace, uiScrollView.contentSize.width - 1), y: 0, width: 1, height: 1)
            uiScrollView.scrollRectToVisible(r, animated: animated)
        }
    }
    
    private func _indicatorRectUpdate(_ segmentView: QXView) {
        if let e = indicatorView {
            let r = segmentView.qxRect
            let x: CGFloat
            let y: CGFloat
            let w = e.width(r.w)
            let h = indicatorHeight
            switch indicatorAlignmentX {
            case .left:
                x = r.x
            case .center:
                x = r.x + (r.w - w) / 2
            case .right:
                x = r.x + r.w - w
            }
            switch indicatorPosition {
            case .top:
                y = r.top - indicatorSegmentMargin - indicatorHeight
            case .bottom:
                y = r.bottom + indicatorSegmentMargin
            case .front:
                y = (bounds.height - h) / 2
                uiScrollView.bringSubviewToFront(e)
            case .back:
                y = (bounds.height - h) / 2
                uiScrollView.sendSubviewToBack(e)
            }
            let rect = QXRect(x, y, w, h)
            e.qxRect = rect
            e.didUpdateRect(rect)
        }
    }
    
    private func _segmentsSize() -> QXSize {
        var w: CGFloat = 0
        var h: CGFloat = 0
        var count: Int = 0
        for e in segmentViews {
            if e.isDisplay {
                let wh = e.natureSize
                if e.divideRatioX == nil {
                    w += wh.w
                }
                h = max(h, wh.h)
                count += 1
            }
        }
        w += segmentMargin * CGFloat(max(count - 1, 0))
        return QXSize(w, h)
    }
    
}
