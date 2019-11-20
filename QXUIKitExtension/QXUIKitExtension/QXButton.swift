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
    open var clickHighlightDelaySecs: TimeInterval? = 0.1
    
    /// 高亮的alpha，nil表示不生效
    open var highlightAlpha: CGFloat? //= 0.3
    /// 无效的alpha，nil表示不生效
    open var disableAlpha: CGFloat? = 0.3
    
    /// 是否高亮
    public private(set) var isHighlighted: Bool = false
    
    public lazy var backView: BackView = {
        let e = BackView()
        e.isUserInteractionEnabled = false
        return e
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
    override open func layoutSubviews() {
        super.layoutSubviews()
        backView.qxRect = qxRect.absoluteRect.rectByReduce(padding)
    }
    
    open override func natureContentSize() -> QXSize {
        return QXSize(44, 44)
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
        if backView.backgroundColorHighlighted != nil {
            highlightAlpha = nil
        }
        if backView.backgroundColorDisabled != nil {
            disableAlpha = nil
        }
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
        backView.alpha = _originAlpha ?? 1
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
        backView.alpha = _originAlpha ?? 1
        qxSetNeedsLayout()
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        respondTouchDown?()
        isHighlighted = true
        update()
        _touchBeganPoint = touches.first?.location(in: self)
    }
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        respondTouchMoved?()
    }
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
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
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
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
    open var font: QXFont = QXFont(14, QXColor.dynamicTitle) { didSet { update() } }
    
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

    public lazy var uiLabel: UILabel = {
        let e = UILabel()
        e.textAlignment = .center
        e.isUserInteractionEnabled = false
        return e
    }()
    
    public override init() {
        super.init()
        backView.addSubview(uiLabel)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        uiLabel.qxRect = backView.qxRect.absoluteRect.rectByReduce(titlePadding)
    }
    
    open override func natureContentSize() -> QXSize {
        var size = uiLabel.qxIntrinsicContentSize
        size = size.sizeByAdd(titlePadding).sizeByAdd(padding)
        return size
    }
    
    override open func handlePrepareOrigins() {
        super.handlePrepareOrigins()
        if titleHighlighted != nil {
            highlightAlpha = nil
        }
        if titleDisabled != nil {
            disableAlpha = nil
        }
    }
    
    override open func handleNormalize() {
        if let e = richTitles {
            uiLabel.qxRichTexts = e
        } else {
            uiLabel.qxRichText = QXRichText.text(title, font)
        }
        super.handleNormalize()
    }
    override open func handleHighlighted() {
        if let e = richTitlesHighlighted {
            uiLabel.qxRichTexts = e
        } else if let e = titleHighlighted {
            uiLabel.qxRichText = QXRichText.text(e, font)
        } else {
           if let e = richTitles {
              uiLabel.qxRichTexts = e
           } else {
              uiLabel.qxRichText = QXRichText.text(title, font)
           }
        }
        super.handleHighlighted()
    }
    override open func handleSelected() {
        if let e = richTitlesSelected {
            uiLabel.qxRichTexts = e
        } else if let e = titleSelected {
            uiLabel.qxRichText = QXRichText.text(e, font)
        } else {
            if let e = richTitles {
               uiLabel.qxRichTexts = e
            } else {
               uiLabel.qxRichText = QXRichText.text(title, font)
            }
        }
        super.handleSelected()
    }
    override open func handleDisabled(isSelected: Bool) {
        if let e = richTitlesDisabled {
            uiLabel.qxRichTexts = e
        } else if let e = titleDisabled {
            uiLabel.qxRichText = QXRichText.text(e, font)
        } else {
            if let e = richTitles {
                uiLabel.qxRichTexts = e
            } else {
                uiLabel.qxRichText = QXRichText.text(title, font)
            }
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
        let e = QXImageView()
        return e
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
    
    open override func natureContentSize() -> QXSize {
        if let e = fixWidth ?? maxWidth {
            let size = imageView.qxIntrinsicContentSize
            if size.isZero {
                return size
            } else {
                if size.w <= e - padding.left - padding.right {
                    return size.sizeByAdd(padding)
                } else {
                    let w = e - padding.left - padding.right
                    let h = w * size.h / size.w
                    return QXSize(w, h).sizeByAdd(padding)
                }
            }
        } else if let e = fixHeight ?? maxHeight {
            let size = imageView.qxIntrinsicContentSize
            if size.isZero {
                return size
            } else {
                if size.h <= e - padding.top - padding.bottom {
                    return size.sizeByAdd(padding)
                } else {
                    let h = e - padding.top - padding.bottom
                    let w = h * size.w / size.h
                    return QXSize(w, h).sizeByAdd(padding)
                }
            }
        } else {
            let size = imageView.qxIntrinsicContentSize
            if size.isZero {
                return size
            } else {
                return size.sizeByAdd(padding)
            }
        }
    }

    override open func handlePrepareOrigins() {
        super.handlePrepareOrigins()
        if imageHighlighted != nil {
            highlightAlpha = nil
        }
        if imageDisabled != nil {
            disableAlpha = nil
        }
    }
    
    override open func handleNormalize() {
        imageView.image = image
        super.handleNormalize()
    }
    override open func handleHighlighted() {
        if let e = imageHighlighted {
            imageView.image = e
        }
        super.handleHighlighted()
    }
    override open func handleSelected() {
        if let e = imageSelected {
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
        let e = QXStackView()
        e.alignmentX = .center
        e.alignmentY = .center
        return e
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
    
    open override func natureContentSize() -> QXSize {
        let size = stackView.qxIntrinsicContentSize
        if size.isZero {
            return size
        } else {
            return size.sizeByAdd(stackPadding).sizeByAdd(padding)
        }
    }
    
    override open func handlePrepareOrigins() {
        super.handlePrepareOrigins()
        if viewsHighlighted != nil {
            highlightAlpha = nil
        }
        if viewsDisabled != nil {
            disableAlpha = nil
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
