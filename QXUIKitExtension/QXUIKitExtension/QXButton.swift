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
    
    public lazy var backView: BackView = {
        let one = BackView()
        one.isUserInteractionEnabled = false
        return one
    }()
    
    open class BackView: UIView {
       open var backgroundColorHighlighted: QXColor?
    
       open var shadowHighlighted: QXShadow?
       open var borderHighlighted: QXBorder?

       open var backgroundColorSelected: QXColor?
       open var shadowSelected: QXShadow?
       open var borderSelected: QXBorder?
    
       open var backgroundColorDisabled: QXColor?
       open var shadowDisabled: QXShadow?
       open var borderDisabled: QXBorder?
    }
    
    public override init() {
        super.init()
        addSubview(backView)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        backView.qxRect = qxRect.absoluteRect.rectByReduce(padding)
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
        qxSetNeedsLayout()
    }
    
    open func handlePrepareOrigins() {
        _originBackgoundColor = backView.qxBackgroundColor ?? QXColor.clear
        _originShadow = backView.qxShadow
        _originBorder = backView.qxBorder
        _originAlpha = alpha
    }
    open func handleNormalize() {
        if !_isOriginPrepared {
            handlePrepareOrigins()
            _isOriginPrepared = true
        }
        backView.qxBackgroundColor = _originBackgoundColor
        backView.qxShadow = _originShadow
        backView.qxBorder = _originBorder
        backView.alpha = _originAlpha ?? 1
        qxSetNeedsLayout()
    }
    open func handleHighlighted() {
        if !_isOriginPrepared {
            handlePrepareOrigins()
            _isOriginPrepared = true
        }
        if let e = backView.backgroundColorHighlighted {
            backView.qxBackgroundColor = e
        }
        if let e = backView.shadowHighlighted {
            backView.qxShadow = e
        }
        if let e = backView.borderHighlighted {
            backView.qxBorder = e
        }
        if let e = highlightAlpha {
            backView.alpha = e
        }
        qxSetNeedsLayout()
    }
    open func handleSelected() {
        if !_isOriginPrepared {
            handlePrepareOrigins()
            _isOriginPrepared = true
        }
        if let e = backView.backgroundColorSelected {
            backView.qxBackgroundColor = e
        }
        if let e = backView.shadowSelected {
            backView.qxShadow = e
        }
        if let e = backView.borderSelected {
            backView.qxBorder = e
        }
        qxSetNeedsLayout()
    }
    open func handleDisabled(isSelected: Bool) {
        if !_isOriginPrepared {
            handlePrepareOrigins()
            _isOriginPrepared = true
        }
        if let e = backView.backgroundColorDisabled {
            backView.qxBackgroundColor = e
        }
        if let e = backView.shadowDisabled {
            backView.qxShadow = e
        }
        if let e = backView.borderDisabled {
            backView.qxBorder = e
        }
        if let e = disableAlpha {
            backView.alpha = e
        }
        qxSetNeedsLayout()
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
                    isClickTriggered = true
                    respondClick?()
                }
                if isClickTriggered {
                    if let e = clickHighlightDelaySecs {
                        DispatchQueue.main.qxAsyncWait(e) {
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
        handleNormalize()
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
    
    open var titlePadding: QXEdgeInsets = QXEdgeInsets.zero

    public lazy var label: UILabel = {
        let one = UILabel()
        one.textAlignment = .center
        one.isUserInteractionEnabled = false
        return one
    }()
    
    public override init() {
        super.init()
        backView.addSubview(label)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        label.qxRect = backView.qxRect.absoluteRect.rectByReduce(padding)
    }
    
    public var intrinsicMinHeight: CGFloat?
    public var intrinsicWidth: CGFloat?
    open override var intrinsicContentSize: CGSize {
        if isDisplay {
            if let e = intrinsicSize {
                return e.cgSize
            } else {
                var size = label.qxIntrinsicContentSize
                size = size.sizeByAdd(titlePadding).sizeByAdd(padding)
                if let e = intrinsicMinHeight {
                   size = QXSize(size.w, max(size.h, e))
                }
                if let e = intrinsicWidth {
                    size = QXSize(max(size.w, e), size.h)
                }
                return size.cgSize
            }
        } else {
            return CGSize.zero
        }
    }
    
    override open func handleNormalize() {
        if let e = richTitles {
            label.qxRichTexts = e
        } else {
            label.qxRichText = QXRichText.text(title, font)
        }
        super.handleNormalize()
    }
    override open func handleHighlighted() {
        if let e = richTitlesHighlighted {
            label.qxRichTexts = e
        } else if let e = titleHighlighted {
            label.qxRichText = QXRichText.text(e, font)
        }
        super.handleHighlighted()
    }
    override open func handleSelected() {
        if let e = richTitlesSelected {
            label.qxRichTexts = e
        } else if let e = titleSelected {
            label.qxRichText = QXRichText.text(e, font)
        }
        super.handleSelected()
    }
    override open func handleDisabled(isSelected: Bool) {
        if let e = richTitlesDisabled {
            label.qxRichTexts = e
        } else if let e = titleDisabled {
            label.qxRichText = QXRichText.text(e, font)
        }
        super.handleDisabled(isSelected: isSelected)
    }

}

open class QXImageButton: QXButton {
    
    open var image: QXImage? { didSet { update() } }
    
    open var imageHighlighted: QXImage?
    open var imageSelected: QXImage?
    open var imageDisabled: QXImage?
        
    public lazy var imageView: QXImageView = {
        let one = QXImageView()
        return one
    }()
    
    public override init() {
        super.init()
        backView.addSubview(imageView)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        imageView.qxRect = backView.qxRect.absoluteRect
    }
    
    public var intrinsicWidth: CGFloat? = nil
    public var intrinsicHeight: CGFloat? = nil
    open override var intrinsicContentSize: CGSize {
        if isDisplay {
            if let e = intrinsicSize {
                return e.cgSize
            } else if let e = intrinsicWidth {
                let size = imageView.qxIntrinsicContentSize
                if size.isZero {
                    return size.cgSize
                } else {
                    if size.w <= e - padding.left - padding.right {
                        return size.sizeByAdd(padding).cgSize
                    } else {
                        let w = e - padding.left - padding.right
                        let h = w * size.h / size.w
                        return QXSize(w, h).sizeByAdd(padding).cgSize
                    }
                }
            } else if let e = intrinsicHeight {
                let size = imageView.qxIntrinsicContentSize
                if size.isZero {
                   return size.cgSize
                } else {
                   if size.h <= e - padding.top - padding.bottom {
                       return size.sizeByAdd(padding).cgSize
                   } else {
                       let h = e - padding.top - padding.bottom
                       let w = h * size.w / size.h
                       return QXSize(w, h).sizeByAdd(padding).cgSize
                   }
                }
            } else {
                let size = imageView.qxIntrinsicContentSize
                if size.isZero {
                    return size.cgSize
                } else {
                    return size.sizeByAdd(padding).cgSize
                }
            }
        } else {
            return CGSize.zero
        }
    }
    
    override open func handleNormalize() {
        imageView.image = image ?? imageView.image
        super.handleNormalize()
    }
    override open func handleHighlighted() {
        if let e = imageHighlighted {
            imageView.image = e
        }
        super.handleHighlighted()
    }
    override open func handleSelected() {
        if let e = imageHighlighted {
            imageView.image = e
        }
        super.handleSelected()
    }
    override open func handleDisabled(isSelected: Bool) {
        if let e = imageDisabled {
            imageView.image = e
        }
        super.handleDisabled(isSelected: isSelected)
    }
    
}


open class QXStackButton: QXButton {
    
    open var views: [QXView] = [] { didSet { update() } }
    
    open var viewsHighlighted: [QXView]?
    open var viewsSelected: [QXView]?
    open var viewsDisabled: [QXView]?
    
    open var stackPadding: QXEdgeInsets = QXEdgeInsets.zero
    
    public lazy var stackView: QXStackView = {
        let one = QXStackView()
        one.alignmentX = .center
        one.alignmentY = .center
        return one
    }()
    
    public override init() {
        super.init()
        backView.addSubview(stackView)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        stackView.qxRect = backView.qxRect.absoluteRect.rectByReduce(stackPadding)
    }
    
    public var intrinsicMinWidth: CGFloat?
    public var intrinsicMinHeight: CGFloat?
    open override var intrinsicContentSize: CGSize {
        if isDisplay {
            if let e = intrinsicSize {
                return e.cgSize
            } else {
                let size = stackView.qxIntrinsicContentSize
                if size.isZero {
                    return size.cgSize
                } else {
                    var size = size.sizeByAdd(stackPadding).sizeByAdd(padding)
                    if let e = intrinsicMinWidth {
                        size = QXSize(max(size.w, e), size.h)
                    }
                    if let e = intrinsicMinHeight {
                        size = QXSize(size.w, max(size.h, e))
                    }
                    return size.cgSize
                }
            }
        } else {
            return CGSize.zero
        }
    }
    
    override open func handleNormalize() {
        stackView.setupViews(views)
        super.handleNormalize()
    }
    override open func handleHighlighted() {
        if let e = viewsHighlighted {
            stackView.setupViews(e)
        }
        super.handleHighlighted()
    }
    override open func handleSelected() {
        if let e = viewsSelected {
            stackView.setupViews(e)
        }
        super.handleSelected()
    }
    override open func handleDisabled(isSelected: Bool) {
        if let e = viewsDisabled {
            stackView.setupViews(e)
        }
        super.handleDisabled(isSelected: isSelected)
    }
    
}
