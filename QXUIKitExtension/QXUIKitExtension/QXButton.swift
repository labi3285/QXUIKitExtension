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

    open var respondTouchUpInside: (() -> Void)?
    open var respondTouchUpOutside: (() -> Void)?

    open var respondTouchDown: (() -> Void)?
    open var respondTouchMoved: (() -> Void)?
    open var respondTouchEnded: (() -> Void)?
    open var respondTouchCancelled: (() -> Void)?
    
    open var respondClick: (() -> Void)?
    /// 触发点击的容忍距离
    open var clickMoveTolerance: CGFloat = 20
    /// 点击的高光效果持续时间，默认0.3秒, nil 表示不会延时
    open var clickHighlightDelaySecs: TimeInterval? = 0.1
    
    /// 高亮的alpha，nil表示不生效
    open var highlightAlpha: CGFloat? = 0.3
    /// 无效的alpha，nil表示不生效
    open var disableAlpha: CGFloat? = 0.3
    
    /// 是否高亮
    public private(set) var isHighlighted: Bool = false
    
    public final lazy var backView: BackView = {
        let e = BackView()
        e.clipsToBounds = false
        e.isUserInteractionEnabled = false
        e.uiImageView.contentMode = .scaleToFill
        e.respondChangeBackLayers = { [unowned self] c in
            self._originBackLayers = c
        }
        e.respondChangeImage = { [unowned self] c in
            self._originBackImage = c
        }
        e.respondChangeBackColor = { [unowned self] c in
            self._originBackColor = c
        }
        e.respondChangeShadow = { [unowned self] c in
            self._originShadow = c
        }
        e.respondChangeBorder = { [unowned self] c in
            self._originBorder = c
        }
        return e
    }()
    
    open class BackView: QXImageView {
        
        var respondChangeBackLayers: (([QXLayer]?) -> ())?
        var respondChangeImage: ((QXImage?) -> ())?
        var respondChangeBackColor: ((QXColor?) -> ())?
        var respondChangeShadow: ((QXShadow?) -> ())?
        var respondChangeBorder: ((QXBorder?) -> ())?

        open override var backLayers: [QXLayer]? {
            set {
                super.backLayers = newValue
                respondChangeBackLayers?(newValue)
            }
            get {
                return super.backLayers
            }
        }
        fileprivate func _pureUpdateBackLayers(_ e: [QXLayer]?) {
            super.backLayers = e
        }
        
        open override var image: QXImage? {
            didSet {
                super.image = image
                respondChangeImage?(image)
            }
        }
        fileprivate func _pureUpdateImage(_ e: QXImage?) {
            super.image = e
        }
        
        open override var backColor: QXColor? {
            set {
                super.backColor = newValue
                respondChangeBackColor?(newValue)
            }
            get {
                return super.backColor
            }
        }
        fileprivate func _pureUpdateBackColor(_ e: QXColor?) {
            super.backColor = e
        }
        
        open override var shadow: QXShadow? {
            set {
                super.shadow = newValue
                respondChangeShadow?(newValue)
            }
            get {
                return super.shadow
            }
        }
        fileprivate func _pureUpdateShadow(_ e: QXShadow?) {
            super.shadow = e
        }
        
        open override var border: QXBorder? {
            set {
                super.border = newValue
                respondChangeBorder?(newValue)
            }
            get {
                return super.border
            }
        }
        fileprivate func _pureUpdateBorder(_ e: QXBorder?) {
            super.border = e
        }
        
        open var backLayersHighlighted: [QXLayer]?
        open var backLayersDisabled: [QXLayer]?
        open var backLayersSelected: [QXLayer]?
        
        open var imageHighlighted: QXImage?
        open var imageDisabled: QXImage?
        open var imageSelected: QXImage?

        open var backColorHighlighted: QXColor?
        open var backColorSelected: QXColor?
        open var backColorDisabled: QXColor?
        
        open var shadowHighlighted: QXShadow?
        open var shadowSelected: QXShadow?
        open var shadowDisabled: QXShadow?

        open var borderHighlighted: QXBorder?
        open var borderSelected: QXBorder?
        open var borderDisabled: QXBorder?
    }
    
    public override init() {
        super.init()
        addSubview(backView)
        clipsToBounds = false
    }
    public required init?(coder aDecoder: NSCoder) {
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
        _originBackLayers = backView.backLayers
        _originBackImage = backView.image
        _originBackColor = backView.backColor ?? QXColor.clear
        _originShadow = backView.shadow
        _originBorder = backView.border
        _originAlpha = alpha
        if backView.backColorHighlighted != nil {
            highlightAlpha = nil
        }
        if backView.backColorDisabled != nil {
            disableAlpha = nil
        }
    }
    open func handleNormalize() {
        if !_isOriginPrepared {
            handlePrepareOrigins()
            _isOriginPrepared = true
        }
        if let e = _originBackImage {
            backView._pureUpdateBackLayers(nil)
            backView._pureUpdateBackColor(nil)
            backView._pureUpdateImage(e)
        } else if let e = _originBackLayers {
            backView._pureUpdateBackLayers(e)
            backView._pureUpdateBackColor(nil)
            backView._pureUpdateImage(nil)
        } else {
            backView._pureUpdateBackLayers(nil)
            backView._pureUpdateBackColor(_originBackColor)
            backView._pureUpdateImage(nil)
        }
        backView._pureUpdateShadow(_originShadow)
        backView._pureUpdateBorder(_originBorder)
        backView.alpha = _originAlpha ?? 1
    }
    open func handleHighlighted() {
        if !_isOriginPrepared {
            handlePrepareOrigins()
            _isOriginPrepared = true
        }
        if let e = backView.imageHighlighted ?? _originBackImage {
            backView._pureUpdateBackLayers(nil)
            backView._pureUpdateBackColor(nil)
            backView._pureUpdateImage(e)
        } else if let e = backView.backLayersHighlighted ?? _originBackLayers {
            backView._pureUpdateBackLayers(e)
            backView._pureUpdateBackColor(nil)
            backView._pureUpdateImage(nil)
        } else {
            backView._pureUpdateBackLayers(nil)
            backView._pureUpdateBackColor(backView.backColorHighlighted ?? _originBackColor)
            backView._pureUpdateImage(nil)
        }
        backView._pureUpdateShadow(backView.shadowHighlighted ?? _originShadow)
        backView._pureUpdateBorder(backView.borderHighlighted ?? _originBorder)
        backView.alpha = highlightAlpha ?? _originAlpha ?? 1
    }
    open func handleSelected() {
        if !_isOriginPrepared {
            handlePrepareOrigins()
            _isOriginPrepared = true
        }
        if let e = backView.imageSelected ?? _originBackImage {
            backView._pureUpdateBackLayers(nil)
            backView._pureUpdateBackColor(nil)
            backView._pureUpdateImage(e)
        } else if let e = backView.backLayersSelected ?? _originBackLayers {
            backView._pureUpdateBackLayers(e)
            backView._pureUpdateBackColor(nil)
            backView._pureUpdateImage(nil)
        } else {
            backView._pureUpdateBackLayers(nil)
            backView._pureUpdateBackColor(backView.backColorSelected ?? _originBackColor)
            backView._pureUpdateImage(nil)
        }
        backView._pureUpdateShadow(backView.shadowSelected ?? _originShadow)
        backView._pureUpdateBorder(backView.borderSelected ?? _originBorder)
        backView.alpha = _originAlpha ?? 1
    }
    open func handleDisabled(isSelected: Bool) {
        if !_isOriginPrepared {
            handlePrepareOrigins()
            _isOriginPrepared = true
        }
        if let e = backView.imageDisabled ?? _originBackImage {
            backView._pureUpdateBackLayers(nil)
            backView._pureUpdateBackColor(nil)
            backView._pureUpdateImage(e)
        } else if let e = backView.backLayersDisabled ?? _originBackLayers {
            backView._pureUpdateBackLayers(e)
            backView._pureUpdateBackColor(nil)
            backView._pureUpdateImage(nil)
        } else {
            backView._pureUpdateBackLayers(nil)
            backView._pureUpdateBackColor(backView.backColorDisabled ?? _originBackColor)
            backView._pureUpdateImage(nil)
        }
        backView._pureUpdateShadow(backView.shadowDisabled ?? _originShadow)
        backView._pureUpdateBorder(backView.borderDisabled ?? _originBorder)
        backView.alpha = disableAlpha ?? _originAlpha ?? 1
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
                        let origin = self.isUserInteractionEnabled
                        self.isUserInteractionEnabled = false
                        DispatchQueue.main.qxAsyncAfter(e) {
                           self.isHighlighted = false
                           self.update()
                           self.isUserInteractionEnabled = origin
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
        isHighlighted = false
        respondTouchCancelled?()
        update()
    }
    private var _touchBeganPoint: CGPoint?
    private var _isOriginPrepared: Bool = false
    
    private var _originBackLayers: [QXLayer]?
    private var _originBackImage: QXImage?
    private var _originBackColor: QXColor?
    
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

    public final lazy var uiLabel: UILabel = {
        let e = UILabel()
        e.textAlignment = .center
        e.isUserInteractionEnabled = false
        return e
    }()
    
    public override init() {
        super.init()
        backView.addSubview(uiLabel)
    }
    public required init?(coder aDecoder: NSCoder) {
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
            if let e = richTitles {
                uiLabel.qxRichTexts = e
            } else {
                uiLabel.qxRichText = QXRichText.text(title, font)
            }
        }
        super.handleNormalize()
    }
    override open func handleHighlighted() {
        if let e = richTitlesHighlighted {
            uiLabel.qxRichTexts = e
        } else if let e = titleHighlighted {
            uiLabel.qxRichText = QXRichText.text(e, font)
        } else {
            if let e = richTitlesHighlighted ?? richTitles {
                uiLabel.qxRichTexts = e
            } else {
                uiLabel.qxRichText = QXRichText.text(titleHighlighted ?? title, fontHighlighted ?? font)
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
            if let e = richTitlesSelected ?? richTitles {
               uiLabel.qxRichTexts = e
            } else {
               uiLabel.qxRichText = QXRichText.text(titleSelected ?? title, fontSelected ?? font)
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
    
    open var image: QXImage? {
        didSet {
            update()
        }
    }
    
    open var imageHighlighted: QXImage?
    open var imageSelected: QXImage?
    open var imageDisabled: QXImage?
    
    open var imageSize: QXSize?
    
    public final lazy var imageView: QXImageView = {
        let e = QXImageView()
        return e
    }()
    
    public override init() {
        super.init()
        backView.addSubview(imageView)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if let e = imageSize {
            imageView.qxRect = backView.qxBounds.insideRect(.center, .size(e))
        } else {
            imageView.qxRect = backView.qxBounds
        }
    }
    
    open override func natureContentSize() -> QXSize {
        if let e = imageSize {
            return e.sizeByAdd(padding)
        } else {
            return imageView.natureSize.sizeByAdd(padding)
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
        imageView.image = imageSelected ?? image
        super.handleSelected()
    }
    override open func handleDisabled(isSelected: Bool) {
        imageView.image = imageSelected ?? image
        super.handleDisabled(isSelected: isSelected)
    }
    
}

open class QXStackButton: QXButton {
    
    open var views: [QXViewProtocol] = [] { didSet { update() } }
    
    open var viewsHighlighted: [QXViewProtocol]?
    open var viewsSelected: [QXViewProtocol]?
    open var viewsDisabled: [QXViewProtocol]?
        
    public final lazy var stackView: QXStackView = {
        let e = QXStackView()
        e.alignmentX = .center
        e.alignmentY = .center
        return e
    }()
    
    public override init() {
        super.init()
        backView.addSubview(stackView)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        stackView.qxRect = backView.qxBounds
    }
    
    open override func natureContentSize() -> QXSize {
        return stackView.natureSize.sizeByAdd(padding)
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
        stackView.views = views
        super.handleNormalize()
    }
    override open func handleHighlighted() {
        if let e = viewsHighlighted {
            stackView.views = e
        }
        super.handleHighlighted()
    }
    override open func handleSelected() {
        if let e = viewsSelected {
            stackView.views = e
        }
        super.handleSelected()
    }
    override open func handleDisabled(isSelected: Bool) {
        if let e = viewsDisabled {
            stackView.views = e
        }
        super.handleDisabled(isSelected: isSelected)
    }
    
}


open class QXIconButton: QXStackButton {
    
    open var icon: QXImage? {
        set {
            iconView.image = newValue
        }
        get {
            return iconView.image
        }
    }
    
    open var title: String {
        set {
            titleLabel.text = newValue
        }
        get {
            return titleLabel.text
        }
    }
    
    open var isVertical: Bool {
        set {
            stackView.isVertical = newValue
        }
        get {
            return stackView.isVertical
        }
    }
    
    public final lazy var iconView: QXImageView = {
        let e = QXImageView()
        e.compressResistance = QXView.resistanceStable
        return e
    }()
    public final lazy var titleLabel: QXLabel = {
        let e = QXLabel()
        e.compressResistance = QXView.resistanceNormal
        e.font = QXFont(12, QXColor.dynamicText)
        return e
    }()
    
    public convenience init(isVertical: Bool) {
        self.init()
        self.stackView.isVertical = isVertical
    }
    
    public override init() {
        super.init()
        self.stackView.viewMargin = 5
        self.views = [iconView, titleLabel]
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}

open class QXFoldButton: QXStackButton {
    
    open var title: String {
        set {
            titleLabel.text = newValue
        }
        get {
            return titleLabel.text
        }
    }
    
    open var isFold: Bool = true {
        didSet {
            if isFold {
                iconView.transform = CGAffineTransform.identity
            } else {
                iconView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }
        }
    }
    
    public final lazy var iconView: QXImageView = {
        let e = QXImageView()
        e.image = QXImage.shapTriangleFill(w: 10, h: 5, direction: .down, color: QXColor.dynamicIndicator)
        e.compressResistance = QXView.resistanceStable
        return e
    }()
    public final lazy var titleLabel: QXLabel = {
        let e = QXLabel()
        e.compressResistance = QXView.resistanceNormal
        e.font = QXFont(14, QXColor.dynamicText)
        return e
    }()
    public override init() {
        super.init()
        self.highlightAlpha = nil
        self.stackView.viewMargin = 5
        self.padding = QXEdgeInsets(5, 5, 5, 5)
        self.views = [titleLabel, iconView]
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}

open class QXMaskButton: QXView, UIGestureRecognizerDelegate {
    
    open var respondTapBackground: (() -> Void)?
    
    open var alignmentX: QXAlignmentX = .center
    open var alignmentY: QXAlignmentY = .center

    public let view: QXView
    public required init(view: QXView) {
        self.view = view
        super.init()
        addSubview(view)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapOnBackground))
        tap.delegate = self
        addGestureRecognizer(tap)
        backColor = QXColor.hex("#000000", 0.5)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override open func layoutSubviews() {
        super.layoutSubviews()
        let wh = view.natureSize
        let w = min(wh.w, bounds.width - padding.left - padding.right)
        let h = min(wh.h, bounds.height - padding.top - padding.bottom)
        var x = padding.left
        switch alignmentX {
        case .left:
            break
        case .center:
            x += (bounds.width - padding.left - padding.right - w) / 2
        case .right:
            x += bounds.width - padding.left - padding.right - w
        }
        var y = padding.top
        switch alignmentY {
        case .top:
            break
        case .center:
            y += (bounds.height - padding.top - padding.bottom - h) / 2
        case .bottom:
            y += bounds.height - padding.top - padding.bottom - h
        }
        view.qxRect = QXRect(x, y, w, h)
    }

    open override func natureContentSize() -> QXSize {
        return view.natureSize.sizeByAdd(padding)
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == self {
            return true
        }
        return false
    }
    @objc func handleTapOnBackground() {
        respondTapBackground?()
    }
    
}


