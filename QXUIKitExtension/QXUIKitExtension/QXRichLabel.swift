//
//  QXLabel.swift
//  QXLabel
//
//  Created by labi3285 on 2019/6/22.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXRichLabel: QXView {
    
    public var text: String {
        set {
            items = [Item.text(string: newValue, font: font, linkData: nil)]
        }
        get {
            return _attributtedString.string
        }
    }
    
    /// font for single text
    public var font: QXFont = QXFont(14, QXColor.dynamicText) {
        didSet {
            items = [Item.text(string: text, font: font, linkData: nil)]
        }
    }
    
    public enum Item {
        /**
         * text item
         * - font: text font, nil for default
         * - linkData: link data is for touch feedback. [tip] if you want to touch through this label, set linkData = nil.
         */
        case text(string: String, font: QXFont?, linkData: Any?)
        
        /**
         * image item
         * - size: image size. nil for image.size.
         * - widthPadding: width padding. Will div into left widthPadding/2 and right widthPadding/2.
         * - descentRatio: descent ratio for calculate aescent and descent based on size.
         * - linkData: link data is for touch feedback. [tip] if you want to touch through this label, set linkData = nil.
         */
        case image(image: QXImage, widthPadding: CGFloat, descentRatio: CGFloat, linkData: Any?)
        
        /**
         * view item
         * - size: image size. nil for view.intrinsicContentSize.
         * - widthPadding: width padding. Will div into left widthPadding/2 and right widthPadding/2.
         * - descentRatio: descent ratio for calculate aescent and descent based on size.
         * - linkData: link data is for touch feedback. [warning] if you want interaction from this view, you must set linkData = nil. If you want linkData to work or touch through this label, you must set view.isUserInteractionEnabled = false.
         */
        case view(view: UIView, size: QXSize?, widthPadding: CGFloat, descentRatio: CGFloat, linkData: Any?)
        
    }
    /// models for show
    public var items: [QXRichLabel.Item] = [] {
        didSet {
            for view in subviews {
                view.removeFromSuperview()
            }
            qxSetNeedsLayout()
        }
    }
    
    /// link responder
    public var respondTouchLink: ((_ data: Any) -> Void)?
    
    /// alignment at x direction
    public var alignmentX: QXAlignmentX = .left
    
    /// alignment at y direction
    public var alignmentY: QXAlignmentY = .top
    
    /// customise line break item. Default is '...'. [warning] this item must be no-bigger than texts around
    public var lineBreakItem: QXRichLabel.Item?
    
    /// number of lines, <=0 for no limit
    public var numberOfLines: Int = 0
    
    /// line space, nil for auto
    public var lineSpace: CGFloat = 0
    /// paragraph space, nil for auto, should be bigger than lineSpace
    public var paragraphSpace: CGFloat = 0
    /// justified for line
    public var justified: Bool = true
    /// first line head indent
    public var firstLineHeadIndent: CGFloat = 0
    /// hyphenation factor, 0.0~1.0
    public var hyphenationFactor: CGFloat = 0
    
    /// highlight color
    public var highlightColor: QXColor = QXColor.dynamicHiglight
    
    //MARK:- COPY
    public var isCopyEnabled: Bool = false {
        didSet {
            if isCopyEnabled {
                addGestureRecognizer(longGestureRecognizer)
            } else {
                removeGestureRecognizer(longGestureRecognizer)
            }
        }
    }
    private final lazy var longGestureRecognizer: UILongPressGestureRecognizer = {
        let e = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(_:)))
        return e
    }()
    @objc func longPressed(_ recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            self.becomeFirstResponder()
            let copyMenu = UIMenuItem(title: "复制", action: #selector(copyitem(menuVc:)))
            let menu = UIMenuController.shared
            menu.menuItems = [copyMenu]
            menu.setTargetRect(bounds.qxFrameByReduce(padding.uiEdgeInsets), in: self)
            menu.arrowDirection = .down
            menu.update()
            menu.setMenuVisible(true, animated: true)
        }
    }
    @objc func copyitem(menuVc: UIMenuController) {
        UIPasteboard.general.string = text
    }
    override open var canBecomeFirstResponder: Bool {
        return isCopyEnabled
    }
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copyitem(menuVc:)) && isCopyEnabled {
           return true
        }
        return false
    }
    
    /// line height tolerance, nil for auto. Normaly when asc and none-asc mix in one line will result in a change of line height. this property will prevent from doing this by fix line height by lineHeightTolerance * font-size. [warning] you must be sure to have attaches NO BIGGER than this when set to yes. 1.1 is currently the fit value for charactors
    public var lineHeightTolerance: CGFloat? = 1.1
    
    /// calculate size for width, nil width for no limit
    public func sizeForWidth(_ width: CGFloat?) -> CGSize {
        return _getAttibuttedStringfixSize(_getContent(items).attributtedString, width)
    }
    open override func natureContentSize() -> QXSize {
        return _getAttibuttedStringfixSize(_getContent(items).attributtedString, maxWidth ?? fixWidth).qxSize
    }

    /// init
    public override init() {
        super.init()
        backgroundColor = UIColor.clear
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        let content = _getContent(items)
        var links = content.links
        let attri = content.attributtedString
        let rect = bounds
        let ctFrame = __getCtFrame(content.attributtedString, rect)
        let ctLines = __getCtLines(ctFrame)
        let showLines = _getShowLinesCount(ctFrame, ctLines)
        _attributtedString = attri
        let linesInfo = _getLines(ctFrame, rect, showLines, attri)
        _lines = linesInfo.lines
        if let link = linesInfo.truncatedLink {
            links.append(link)
        }
        for link in links {
            for line in _lines {
                for run in line.runs {
                    if link.range.intersection(run.range) != nil {
                        link.runs.append(run)
                    }
                }
            }
        }
        _links = links
        for line in _lines {
            for run in line.runs {
                if let attachment = run.attachment {
                    if let view = attachment.view {
                        if view.superview == nil {
                            addSubview(view)
                            let transform = CGAffineTransform(translationX: 0, y: rect.height).scaledBy(x: 1, y: -1)
                            view.frame = run.frame.applying(transform)
                        }
                    }
                }
            }
        }
    }
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        ctx.saveGState()
        let transform = CGAffineTransform(translationX: 0, y: rect.height).scaledBy(x: 1, y: -1)
        ctx.concatenate(transform)
        if let link = _touchedLink {
            for run in link.runs {
                let bounds = run.frame
                let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize.zero)
                ctx.addPath(path.cgPath)
                ctx.setLineWidth(0)
                ctx.setFillColor(highlightColor.uiColor.cgColor)
                ctx.fillPath()
            }
        }
        for line in _lines {
            for run in line.runs {
                ctx.textPosition = run.origin
                if let attachment = run.attachment {
                    if let image = attachment.image?.cgImage {
                        ctx.draw(image, in: run.frame)
                    }
                } else {
                    CTRunDraw(run.ctRun, ctx, CFRange(location: 0, length: 0))
                }
            }
        }
        ctx.restoreGState()
    }
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        _touchedLocation = point
        _touchedLink = _tryCatchTouchedLink(point, _links)
        if _touchedLink != nil {
            setNeedsDisplay()
        }
    }
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        if sqrt(pow(point.x - _touchedLocation.x, 2) + pow(point.y - _touchedLocation.y, 2)) > 10 {
            _touchedLink = nil
            setNeedsDisplay()
        }
    }
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if _isHiglight {
            return
        }
        if let link = _touchedLink {
            respondTouchLink?(link.data)
            _isHiglight = true
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self._touchedLink = nil
                self.setNeedsDisplay()
                self._isHiglight = false
            }
        }
    }
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let e = super.hitTest(point, with: event) {
            for view in subviews {
                if view.isUserInteractionEnabled {
                    let point = view.convert(point, from: self)
                    if view.point(inside: point, with: event) {
                        return view.hitTest(point, with: event)
                    }
                }
            }
            if _tryCatchTouchedLink(point, _links) != nil {
                return self
            }
            if isCopyEnabled {
                return e
            }
            return nil
        }
        return nil
    }
    
    fileprivate class Link {
        let range: NSRange
        let data: Any
        var runs: [Run] = []
        init(range: NSRange, data: Any) {
            self.range = range
            self.data = data
        }
    }
    fileprivate struct Attachment {
        weak var image: UIImage?
        weak var view: UIView?
        let size: CGSize
        let widthPadding: CGFloat
        let descentRatio: CGFloat
    }
    fileprivate struct Run {
        let ctRun: CTRun
        let range: NSRange
        let frame: CGRect
        let origin: CGPoint
        let attachment: Attachment?
    }
    fileprivate struct Line {
        let ctLine: CTLine
        let range: NSRange
        let frame: CGRect
        let origin: CGPoint
        let runs: [Run]
    }
    private var _attributtedString: NSAttributedString = NSAttributedString()
    private var _lines: [Line] = []
    private var _links: [Link] = []
    private var _isHiglight: Bool = false
    private var _touchedLocation: CGPoint = CGPoint.zero
    private var _touchedLink: Link?

}


extension QXRichLabel {
    
    private func _getContent(_ items: [QXRichLabel.Item]) -> (attributtedString: NSAttributedString, paragraphStyle: NSMutableParagraphStyle, links: [Link]) {
        let mAttri = NSMutableAttributedString()
        var links: [Link] = []
        for item in items {
            let content = _getItemContent(item)
            let range = NSRange(location: mAttri.length, length: content.attributtedString.length)
            mAttri.append(content.attributtedString)
            if let linkData = content.linkData {
                let link = Link(range: range, data: linkData)
                links.append(link)
            }
        }
        if mAttri.string.hasSuffix("\n") {
            mAttri.append(NSAttributedString(string: " "))
        }
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpace
        style.paragraphSpacing = max(paragraphSpace - self.lineSpace, 0)
        style.lineBreakMode = .byCharWrapping
        if let lineHeightTolerance = lineHeightTolerance {
            var maxNeedsHeight: CGFloat = 0
            for item in items {
                maxNeedsHeight = max(maxNeedsHeight, _getItemNeedsHeight(item))
            }
            style.minimumLineHeight = maxNeedsHeight * lineHeightTolerance
            style.maximumLineHeight = maxNeedsHeight * lineHeightTolerance
        }
        style.firstLineHeadIndent = firstLineHeadIndent
        style.hyphenationFactor = Float(hyphenationFactor)
        if justified {
            style.alignment = .justified
        }
        mAttri.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: mAttri.length))
        return (mAttri.copy() as! NSAttributedString, style, links)
    }
    private func _getItemContent(_ item: QXRichLabel.Item) -> (attributtedString: NSAttributedString, linkData: Any?) {
        switch item {
        case .text(string: let str, font: let font, linkData: let linkData):
            let attri = (font ?? self.font).nsAttributtedString(str)
            if let linkData = linkData {
                let mAttri = NSMutableAttributedString()
                mAttri.append(attri)
                mAttri.append(NSAttributedString(string: "\u{FFFC}"))
                return (mAttri.copy() as! NSAttributedString, linkData)
            } else {
                return (attri, nil)
            }
        case .image(image: let image, widthPadding: let widthPadding, descentRatio: let descentRatio, linkData: let linkData):
            if let e = image.uiImage {
                let size = image.size ?? e.size.qxSize
                let attach = Attachment(image: e, view: nil, size: size.cgSize, widthPadding: widthPadding, descentRatio: descentRatio)
                let attri = _getAttachmentAttributtedString(attach)
                return (attri, linkData)
            }
        case .view(view: let view, size: let size, widthPadding: let widthPadding, descentRatio: let descentRatio, linkData: let linkData):
            let size = size?.cgSize ?? view.intrinsicContentSize
            let attach = Attachment(image: nil, view: view, size: size, widthPadding: widthPadding, descentRatio: descentRatio)
            let attri = _getAttachmentAttributtedString(attach)
            return (attri, linkData)
        }
        let attri = NSAttributedString()
        return (attri, nil)
    }
    private func _getItemNeedsHeight(_ item: Item) -> CGFloat {
        switch item {
        case .text(string: _, font: let font, linkData: _):
            return (font ?? self.font).size
        case .image(image: let image, widthPadding: _, descentRatio: _, linkData: _):
            if let size = image.size {
                return size.h
            }
        case .view(view: let view, size: let size, widthPadding: _, descentRatio: _, linkData: _):
            let size = size?.cgSize ?? view.intrinsicContentSize
            return size.height
        }
        return 0
    }
    private func _getAttachmentAttributtedString(_ attach: Attachment) -> NSAttributedString {
        var callBacks = CTRunDelegateCallbacks(version: kCTRunDelegateVersion1, dealloc: { (p) in
        }, getAscent: { (p) -> CGFloat in
            let attach = p.assumingMemoryBound(to: Attachment.self).pointee
            return attach.size.height * (1 - attach.descentRatio)
        }, getDescent: { (p) -> CGFloat in
            let attach = p.assumingMemoryBound(to: Attachment.self).pointee
            return attach.size.height * attach.descentRatio
        }, getWidth: { (p) -> CGFloat in
            let attach = p.assumingMemoryBound(to: Attachment.self).pointee
            return attach.size.width + attach.widthPadding
        })
        let buffer = UnsafeMutablePointer<Attachment>.allocate(capacity: 1)
        buffer.initialize(to: attach)
        let runDelegate = CTRunDelegateCreate(&callBacks, buffer)!
        let font = QXFont(attach.size.height, QXColor.hex("#000000", 1))
        let attri = font.nsAttributtedString("\u{FFFC}")
        let mAttri = NSMutableAttributedString(attributedString: attri)
        mAttri.addAttribute(kCTRunDelegateAttributeName as NSAttributedString.Key, value: runDelegate, range: NSRange(location: 0, length: mAttri.length))
        return mAttri.copy() as! NSAttributedString
    }
    private func _getAttibuttedStringfixSize(_ attri: NSAttributedString, _ limitWidth: CGFloat?) -> CGSize {
        let limitRect = CGRect(x: 0, y: 0, width: limitWidth ?? QXView.extendLength, height: QXView.extendLength)
        let ctFrame = __getCtFrame(attri, limitRect)
        let ctLines = __getCtLines(ctFrame)
        var c = ctLines.count
        if numberOfLines > 0 {
            if numberOfLines < c {
                c = numberOfLines
            }
        }
        let size: CGSize
        if let limitWidth = limitWidth {
            let limitSize = CGSize(width: limitWidth - padding.left - padding.right, height: QXView.extendLength)
            size = __getCtShowLinesSize(ctLines, c, attri, limitSize)
        } else {
            let limitSize = CGSize(width: QXView.extendLength, height: QXView.extendLength)
            size = __getCtShowLinesSize(ctLines, c, attri, limitSize)
        }
        return CGSize(width: padding.left + padding.right + ceil(size.width + 0.6),
                      height: padding.top + padding.bottom + ceil(size.height + 0.6))
    }
    
    //MARK:-
    private func _getIsLineBreaked(_ ctFrame: CTFrame, _ showLines: Int, _ ctLines: [CTLine], _ attributtedString: NSAttributedString) -> Bool {
        if showLines < ctLines.count {
            return true
        } else {
            return CTFrameGetVisibleStringRange(ctFrame).length < attributtedString.length
        }
    }
    private func _getShowLinesCount(_ ctFrame: CTFrame, _ ctLines: [CTLine]) -> Int {
        let c = ctLines.count
        if numberOfLines <= 0 {
            return c
        } else {
            return min(numberOfLines, c)
        }
    }
    private func _getCtTruncLine(_ ctLine: CTLine, _ attributtedString: NSAttributedString, _ ctWidth: CGFloat) -> (ctLine: CTLine, truncLineOffset: CFIndex?, truncatedLink: Link?) {
        let range = CTLineGetStringRange(ctLine)
        let dic = attributtedString.attributes(at: range.location + range.length - 1, effectiveRange: nil)
        let mAttri =  attributtedString.attributedSubstring(from: NSRange(location: range.location, length: range.length)).mutableCopy() as! NSMutableAttributedString
        let attriToken = NSAttributedString(string: "\u{2026}", attributes: dic)
        mAttri.append(attriToken)
        mAttri.append(attriToken)
        let link: Link?
        let _attriToken: NSAttributedString
        if let item = lineBreakItem {
            let attriContent = _getItemContent(item)
            _attriToken = attriContent.attributtedString
            if let linkData = attriContent.linkData {
                let range = NSRange(location: range.location + range.length - 2, length: attriContent.attributtedString.length)
                link = Link(range: range, data: linkData)
            } else {
                link = nil
            }
        } else {
            _attriToken = attriToken
            link = nil
        }
        let tokenLine = CTLineCreateWithAttributedString(_attriToken)
        let _ctLine = CTLineCreateWithAttributedString(mAttri)
        if let truncatedLine = CTLineCreateTruncatedLine(_ctLine, Double(ctWidth), .end, tokenLine) {
            return (truncatedLine, range.location, link)
        }
        return (ctLine, nil, nil)
    }
    private func _checkOrGetAttachmet(_ ctRun: CTRun) -> Attachment? {
        let dic = CTRunGetAttributes(ctRun) as NSDictionary
        let runDelegate = dic[kCTRunDelegateAttributeName]
        if let runDelegate = runDelegate {
            return CTRunDelegateGetRefCon(runDelegate as! CTRunDelegate).assumingMemoryBound(to: Attachment.self).pointee
        }
        return nil
    }
    private func _getRuns(_ ctLine: CTLine, _ lineFrame: CGRect, _ lineOrigin: CGPoint, _ truncLineOffset: CFIndex?) -> [Run] {
        let ctRuns = __getCtRuns(ctLine)
        var runs: [Run] = []
        for ctRun in ctRuns {
            let ctRange = CTRunGetStringRange(ctRun)
            let runRange: NSRange
            if let truncLineOffset = truncLineOffset {
                runRange = NSRange(location: truncLineOffset + ctRange.location, length: ctRange.length)
            } else {
                runRange = NSRange(location: ctRange.location, length: ctRange.length)
            }
            var offsetX = __getCtRunOffset(ctLine, ctRun)
            let origin = CGPoint(x: lineOrigin.x, y: lineOrigin.y)
            let runWhs = __getCtRunWidthHeights(ctRun)
            if let attachment = _checkOrGetAttachmet(ctRun) {
                offsetX += attachment.widthPadding / 2
                let descent = attachment.size.height * attachment.descentRatio
                let frame = CGRect(x: lineOrigin.x + offsetX, y: lineOrigin.y - descent, width: attachment.size.width, height: attachment.size.height)
                let run = Run(ctRun: ctRun, range: runRange, frame: frame, origin: origin, attachment: attachment)
                runs.append(run)
            } else {
                let frame = CGRect(x: lineOrigin.x + offsetX, y: lineOrigin.y - runWhs.descent, width: runWhs.width, height: runWhs.height)
                let run = Run(ctRun: ctRun, range: runRange, frame: frame, origin: origin, attachment: nil)
                runs.append(run)
            }
        }
        return runs
    }
    private func _getLines(_ ctFrame: CTFrame, _ rect: CGRect, _ showLines: Int, _ attributtedString: NSAttributedString) -> (lines: [Line], truncatedLink: Link?) {
        let ctLines = __getCtLines(ctFrame)
        let origins = __getCtOrigins(ctFrame, showLines)
        let limitSize = CGSize(width: rect.width - padding.left - padding.right, height: rect.height - padding.top - padding.bottom)
        let linesSize = __getCtShowLinesSize(ctLines, showLines, attributtedString, limitSize)
        let isLineBreaked = _getIsLineBreaked(ctFrame, showLines, ctLines, attributtedString)
        let ctWidth = rect.width - padding.left - padding.right
        let ctHeight = rect.height - padding.top - padding.bottom
        var lines: [Line] = []
        var truncatedLink: Link?
        for (i, ctLine) in ctLines.enumerated() {
            let _ctLine: CTLine
            let truncLineOffset: CFIndex?
            let ctRange = CTLineGetStringRange(ctLine)
            if i == showLines - 1 && isLineBreaked {
                let lineRange = _getCtTruncLine(ctLine, attributtedString, ctWidth)
                _ctLine = lineRange.ctLine
                truncLineOffset = lineRange.truncLineOffset
                truncatedLink = lineRange.truncatedLink
            } else {
                _ctLine = ctLine
                truncLineOffset = nil
            }
            if i < showLines {
                var origin = origins[i]
                var offsetX = __getCtPenOffset(_ctLine, ctWidth)
                var offsetY: CGFloat
                switch alignmentY {
                case .top:
                    offsetY = 0
                case .center:
                    offsetY = (ctHeight - linesSize.height) / 2
                case .bottom:
                    offsetY = ctHeight - linesSize.height
                }
                offsetX += padding.left
                offsetY -= padding.bottom
                let lineRect = __getCtLineRect(ctLine, origin)
                let frame = CGRect(x: origin.x + offsetX, y: offsetY, width: lineRect.width, height: lineRect.height)
                origin = CGPoint(x: origin.x + offsetX, y: origin.y - offsetY)
                let runs = _getRuns(_ctLine, frame, origin, truncLineOffset)
                let range = NSRange(location: ctRange.location, length: ctRange.length)
                let line = Line(ctLine: _ctLine, range: range, frame: frame, origin: origin, runs: runs)
                lines.append(line)
            } else {
                break
            }
        }
        return (lines, truncatedLink)
    }
    private func _tryCatchTouchedLink(_ point: CGPoint, _ links: [Link]) -> Link? {
        let transform = CGAffineTransform(translationX: 0, y: bounds.height).scaledBy(x: 1, y: -1)
        for link in links.reversed() {
            for run in link.runs {
                var bounds = run.frame.applying(transform)
                bounds = bounds.insetBy(dx: 0, dy: -lineSpace / 2 - run.frame.height * 0.1)
                if bounds.contains(point) {
                    return link
                }
            }
        }
        return nil
    }
    
}

extension QXRichLabel {
    
    private func __getCtFrame(_ attributtedString: NSAttributedString, _ rect: CGRect) -> CTFrame {
        let ctRect = rect.inset(by: padding.uiEdgeInsets)
        return CTFramesetterCreateFrame(CTFramesetterCreateWithAttributedString(attributtedString),
                                        CFRange(location: 0, length: attributtedString.string.count),
                                        CGPath(rect: ctRect, transform: nil),
                                        nil)
    }
    private func __getCtLines(_ ctFrame: CTFrame) -> [CTLine] {
        let lines = CTFrameGetLines(ctFrame)
        var arr: [CTLine] = []
        for i in 0..<CFArrayGetCount(lines) {
            let line = Unmanaged<CTLine>.fromOpaque(CFArrayGetValueAtIndex(lines, i)).takeUnretainedValue()
            arr.append(line)
        }
        return arr
    }
    private func __getCtRuns(_ ctLine: CTLine) -> [CTRun] {
        let runs = CTLineGetGlyphRuns(ctLine)
        var arr: [CTRun] = []
        for i in 0..<CFArrayGetCount(runs) {
            let line = Unmanaged<CTRun>.fromOpaque(CFArrayGetValueAtIndex(runs, i)).takeUnretainedValue()
            arr.append(line)
        }
        return arr
    }
    private func __getCtPenOffset(_ ctLine: CTLine, _ totalWidth: CGFloat) -> CGFloat {
        let flush: CGFloat
        switch alignmentX {
        case .left:
            flush = 0
        case .center:
            flush = 0.5
        case .right:
            flush = 1.0
        }
        return CGFloat(CTLineGetPenOffsetForFlush(ctLine, flush, Double(totalWidth)))
    }
    private func __getCtOrigins(_ ctFrame: CTFrame, _ showLines: Int) -> [CGPoint] {
        let origins = UnsafeMutablePointer<CGPoint>.allocate(capacity: showLines);
        CTFrameGetLineOrigins(ctFrame, CFRange(location: 0, length: showLines), origins)
        var arr: [CGPoint] = []
        for i in 0..<showLines {
            arr.append(origins[i])
        }
        return arr
    }
    private func __getCtLineWidthHeights(_ ctLine: CTLine) -> (width: CGFloat, height: CGFloat, ascent: CGFloat, descent: CGFloat, leading: CGFloat) {
        var ascent: CGFloat = 0
        var descent: CGFloat = 0
        var leading: CGFloat = 0
        let width = CTLineGetTypographicBounds(ctLine, &ascent, &descent, &leading)
        let height = ascent + descent + leading
        return (CGFloat(width), height, ascent, descent, leading)
    }
    private func __getCtRunWidthHeights(_ ctRun: CTRun) -> (width: CGFloat, height: CGFloat, ascent: CGFloat, descent: CGFloat, leading: CGFloat) {
        var ascent: CGFloat = 0
        var descent: CGFloat = 0
        var leading: CGFloat = 0
        let range = CFRange(location: 0, length: 0)
        let width = CTRunGetTypographicBounds(ctRun, range, &ascent, &descent, &leading)
        let height = ascent + descent + leading
        return (CGFloat(width), height, ascent, descent, leading)
    }
    private func __getCtLineRect(_ ctLine: CTLine, _ origin: CGPoint) -> CGRect {
        let whs = __getCtLineWidthHeights(ctLine)
        return CGRect(x: origin.x, y: origin.y - whs.descent, width: whs.width, height: whs.ascent + whs.descent)
    }
    private func __getCtRunOffset(_ ctLine: CTLine, _ ctRun: CTRun) -> CGFloat {
        var secondaryOffset: CGFloat = 0
        let runRange = CTRunGetStringRange(ctRun)
        return CTLineGetOffsetForStringIndex(ctLine, runRange.location, &secondaryOffset)
    }
    private func __getCtShowLinesSize(_ ctLines: [CTLine], _ showLines: Int, _ attributtedString: NSAttributedString, _ limitSize: CGSize) -> CGSize {
        let attri: NSAttributedString
        if showLines < ctLines.count {
            let range = CTLineGetStringRange(ctLines[showLines - 1])
            attri = attributtedString.attributedSubstring(from: NSRange(location: 0, length: range.location + range.length))
        } else {
            attri = attributtedString
        }
        if showLines == 1 {
            let size = attri.boundingRect(with: limitSize, options: .usesLineFragmentOrigin, context: nil).size
            return CGSize(width: size.width, height: size.height - lineSpace)
        } else {
            return attri.boundingRect(with: limitSize, options: .usesLineFragmentOrigin, context: nil).size
        }
    }
    
}

