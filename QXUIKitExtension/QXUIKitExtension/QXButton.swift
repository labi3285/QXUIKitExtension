//
//  QXButton.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/13.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXButton: QXView {
    
    open var isEnabled: Bool =  true { didSet { update() } }
    open var isSelected: Bool = false { didSet { update() } }

    open var respondTouchUpInside: (() -> ())?
    open var respondTouchUpOutside: (() -> ())?

    open var respondTouchDown: (() -> ())?
    open var respondTouchMoved: (() -> ())?
    open var respondTouchEnded: (() -> ())?
    open var respondTouchCancelled: (() -> ())?
    
    open var shadow: QXShadow? { set { contentView.qxShadow = newValue } get { return contentView.qxShadow } }
    open var border: QXBorder? { set { contentView.qxBorder = newValue } get { return contentView.qxBorder } }

    open override var backgroundColor: UIColor? {
        didSet {
            contentView.backgroundColor = backgroundColor
        }
    }
    
    open var backgroundColorHighlighted: QXColor?
    open var shadowHighlighted: QXShadow?
    open var borderHighlighted: QXBorder?

    open var backgroundColorSelected: QXColor?
    open var shadowSelected: QXShadow?
    open var borderSelected: QXBorder?
 
    open var backgroundColorDisabled: QXColor?
    open var shadowDisabled: QXShadow?
    open var borderDisabled: QXBorder?
    
    open var respondClick: (() -> ())?
    /// 触发点击的容忍距离
    open var clickMoveTolerance: CGFloat = 20
    /// 点击的高光效果持续时间，默认0.3秒, nil 表示不会延时
    open var clickHighlightDelaySecs: Double? = 0.3
    
    /// 高亮的alpha，nil表示不生效
    open var highlightAlpha: CGFloat?
    /// 无效的alpha，nil表示不生效
    open var disableAlpha: CGFloat? = 0.3
    
    /// 是否高亮
    public private(set) var isHighlighted: Bool = false

    
    /// 外间隙
    open var margin: QXMargin = QXMargin.zero
    
    public lazy var contentView: UIView = {
        let one = UIView()
        one.isUserInteractionEnabled = false
        return one
    }()
    
    public init() {
        super.init(frame: CGRect.zero)
        addSubview(contentView)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = CGRect(x: margin.left, y: margin.top, width: bounds.width - margin.left - margin.right, height: bounds.height - margin.top - margin.bottom)
    }
    
    open override var intrinsicContentSize: CGSize {
        if isDisplay {
            if let e = intrinsicSize {
                return e.cgSize
            } else {
                return CGSize.zero
            }
        } else {
            return CGSize.zero
        }
    }
    
    open func update() {
        if isEnabled {
            isUserInteractionEnabled = true
            if isHighlighted {
                handleHighlighted()
            } else {
                if isSelected {
                    handleSelected()
                } else {
                    handleNormalize()
                }
            }
        } else {
            isUserInteractionEnabled = false
            handleDisabled(isSelected: isSelected)
        }
        invalidateIntrinsicContentSize()
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    open func handlePrepareOrigins() {
        _originBackgoundColor = contentView.qxBackgroundColor
        _originShadow = shadow
        _originBorder = border
        _originAlpha = alpha
    }
    open func handleNormalize() {
        if !_isOriginPrepared {
            handlePrepareOrigins()
            _isOriginPrepared = true
        }
        contentView.qxBackgroundColor = _originBackgoundColor
        contentView.qxShadow = _originShadow
        contentView.qxBorder = _originBorder
        contentView.alpha = _originAlpha ?? 1
    }
    open func handleHighlighted() {
        contentView.qxBackgroundColor = backgroundColorHighlighted ?? _originBackgoundColor
        contentView.qxShadow = shadowHighlighted ?? _originShadow
        contentView.qxBorder = borderHighlighted ?? _originBorder
        if let a = highlightAlpha {
            contentView.alpha = a
        }
        invalidateIntrinsicContentSize()
        setNeedsLayout()
        setNeedsDisplay()
    }
    open func handleSelected() {
        if !_isOriginPrepared {
            handlePrepareOrigins()
            _isOriginPrepared = true
        }
        contentView.qxBackgroundColor = backgroundColorSelected ?? _originBackgoundColor
        contentView.qxShadow = shadowSelected ?? _originShadow
        contentView.qxBorder = borderSelected ?? _originBorder
    }
    open func handleDisabled(isSelected: Bool) {
        if !_isOriginPrepared {
            handlePrepareOrigins()
            _isOriginPrepared = true
        }
        contentView.qxBackgroundColor = backgroundColorDisabled ?? _originBackgoundColor
        contentView.qxShadow = shadowDisabled ?? _originShadow
        contentView.qxBorder = borderDisabled ?? _originBorder
        if let a = disableAlpha {
            contentView.alpha = a
        } else {
            contentView.alpha = 1
        }
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        respondTouchDown?()
        isHighlighted = true
        update()
        _touchBeganPoint = touches.first?.location(in: self)
    }
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        respondTouchMoved?()
    }
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        respondTouchEnded?()
        if let t = touches.first, let p = _touchBeganPoint {
            let p1 = t.location(in: self)
            if bounds.contains(p1) {
                var isClickTriggered: Bool = false
                if sqrt(pow(p.x - p1.x, 2) + pow(p.y - p1.y, 2)) < clickMoveTolerance {
                    if let f = respondClick {
                        isClickTriggered = true
                        f()
                    }
                }
                if isClickTriggered {
                    if let e = clickHighlightDelaySecs {
                        UIView.animate(withDuration: e) {
                            self.isHighlighted = false
                            self.update()
                        }
                    } else {
                        isHighlighted = false
                        update()
                    }
                } else {
                    isHighlighted = false
                    update()
                }
                respondTouchUpInside?()
            } else {
                isHighlighted = false
                respondTouchUpOutside?()
                update()
            }
        }
    }
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        respondTouchCancelled?()
    }
    private var _touchBeganPoint: CGPoint?
    private var _isOriginPrepared: Bool = false
    private var _originBackgoundColor: QXColor?
    private var _originShadow: QXShadow?
    private var _originBorder: QXBorder?
    private var _originAlpha: CGFloat?

}

open class QXTitleButton: QXButton {
    
    open var title: String = "" { didSet { update() } }
    open var font: QXFont = QXFont(fmt: "14 #333333")
    open var richTitles: [QXRichText]? { didSet { update() } }
    open var richTitle: QXRichText? {
        set {
            if let e = newValue {
                richTitles = [e]
            } else {
                richTitles = nil
            }
        }
        get {
            return richTitles?.first
        }
    }

    open var titleHighlighted: String?
    open var fontHighlighted: QXFont?
    open var richTitlesHighlighted: [QXRichText]?
    open var richTitleHighlighted: QXRichText? {
        set {
            if let e = newValue {
                richTitlesHighlighted = [e]
            } else {
                richTitlesHighlighted = nil
            }
        }
        get {
            return richTitlesHighlighted?.first
        }
    }

    open var titleSelected: String?
    open var fontSelected: QXFont?
    open var richTitlesSelected: [QXRichText]?
    open var richTitleSelected: QXRichText? {
        set {
            if let e = newValue {
                richTitlesSelected = [e]
            } else {
                richTitlesSelected = nil
            }
        }
        get {
            return richTitlesSelected?.first
        }
    }

    open var titleDisabled: String?
    open var fontDisabled: QXFont?
    open var richTitlesDisabled: [QXRichText]?
    open var richTitleDisabled: QXRichText? {
        set {
            if let e = newValue {
                richTitlesDisabled = [e]
            } else {
                richTitlesDisabled = nil
            }
        }
        get {
            return richTitlesDisabled?.first
        }
    }
    
    open var padding: QXPadding = QXPadding.zero

    public lazy var label: UILabel = {
        let one = UILabel()
        one.textAlignment = .center
        one.isUserInteractionEnabled = false
        return one
    }()
    
    public override init() {
        super.init()
        contentView.addSubview(label)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: padding.left, y: padding.top, width: contentView.bounds.width - padding.left - padding.right, height: contentView.bounds.height - padding.top - padding.bottom)
    }
    open override var intrinsicContentSize: CGSize {
        if isDisplay {
            if let e = intrinsicSize {
                return e.cgSize
            } else {
                let size = label.intrinsicContentSize
                return CGSize(width: margin.left + padding.left + size.width + padding.right + margin.right,
                              height: margin.top + padding.top + size.height + padding.bottom + margin.bottom)
            }
        } else {
            return CGSize.zero
        }
    }
    
    override open func handleNormalize() {
        super.handleNormalize()
        if let e = richTitles {
            label.qxRichTexts = e
        } else {
            label.qxRichText = QXRichText.text(title, font)
        }
    }
    override open func handleHighlighted() {
        super.handleHighlighted()
        if let e = richTitlesHighlighted ?? richTitles {
            label.qxRichTexts = e
        } else {
            let e = titleHighlighted ?? title
            label.qxRichText = QXRichText.text(e, font)
        }
    }
    override open func handleSelected() {
        super.handleSelected()
        if let e = richTitlesSelected ?? richTitles {
            label.qxRichTexts = e
        } else {
            let e = titleSelected ?? title
            label.qxRichText = QXRichText.text(e, font)
        }
    }
    override open func handleDisabled(isSelected: Bool) {
        super.handleDisabled(isSelected: isSelected)
        if let e = richTitlesDisabled ?? richTitles {
            label.qxRichTexts = e
        } else {
            let e = titleDisabled ?? title
            label.qxRichText = QXRichText.text(e, font)
        }
    }
    

}
