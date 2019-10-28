//
//  QXLabel.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/20.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXLabel: QXView {
    
    open var text: String = "" {
        didSet {
            uiLabel.attributedText = font.nsAttributtedString(text)
            qxSetNeedsLayout()
        }
    }
    open var font: QXFont = QXFont(size: 14, color: QXColor.black) {
        didSet {
            richTexts = nil
            uiLabel.attributedText = font.nsAttributtedString(text)
            qxSetNeedsLayout()
        }
    }
    
    open var alignmentX: QXAlignmentX = .left {
        didSet {
            switch alignmentX {
            case .left:
                uiLabel.textAlignment = .left
            case .center:
                uiLabel.textAlignment = .center
            case .right:
                uiLabel.textAlignment = .right
            }
        }
    }
    open var alignmentY: QXAlignmentY = .center

    open var richTexts: [QXRichText]? {
        didSet {
            if let richTexts = richTexts {
                uiLabel.attributedText = QXRichText.nsAttributedString(richTexts)
            } else {
                uiLabel.attributedText = nil
            }
            qxSetNeedsLayout()
        }
    }
    
    open var richText: QXRichText? {
        set {
            if let richText = newValue {
                richTexts = [richText]
            } else {
                richTexts = nil
            }
        }
        get { return richTexts?.first }
    }
    
    open var numberOfLines: Int {
        set { uiLabel.numberOfLines = newValue }
        get { return uiLabel.numberOfLines }
    }
    
    public lazy var uiLabel: UILabel = {
        let one = UILabel()
        return one
    }()

    public override init() {
        super.init()
        addSubview(uiLabel)
        isUserInteractionEnabled = false
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var intrinsicWidth: CGFloat?
    public var intrinsicMinWidth: CGFloat?
    public var intrinsicMinHeight: CGFloat?
    public var intrinsicMaxWidth: CGFloat?
    public var intrinsicMaxHeight: CGFloat?
    open override var intrinsicContentSize: CGSize {
        if isDisplay {
            var w: CGFloat = 0
            var h: CGFloat = 0
            if let e = intrinsicSize {
                w = e.w
                h = e.h
            } else if let e = intrinsicWidth {
                var size = CGSize(width: e - padding.left - padding.right, height: CGFloat.greatestFiniteMagnitude)
                size = uiLabel.sizeThatFits(size)
                w = e
                h = size.height + padding.top + padding.bottom
            } else {
                let size = uiLabel.intrinsicContentSize
                w = padding.left + size.width + padding.right
                h = padding.top + size.height + padding.bottom
            }
            if let e = intrinsicMinWidth { w = max(e, w) }
            if let e = intrinsicMaxWidth { w = min(e, w) }
            if let e = intrinsicMinHeight { h = max(e, h) }
            if let e = intrinsicMaxHeight { h = min(e, h) }
            return CGSize(width: w, height: h)
        } else {
            return CGSize.zero
        }
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        let size = uiLabel.sizeThatFits(CGSize.init(width: bounds.width - padding.left - padding.right, height: CGFloat.greatestFiniteMagnitude))
        let h = min(size.height, bounds.height - padding.top - padding.bottom)
        let y: CGFloat
        switch alignmentY {
        case .top:
            y = padding.top
        case .center:
            y = (bounds.height - padding.top - padding.bottom - h) / 2 + padding.top
        case .bottom:
            y = (bounds.height - padding.bottom - h) / 2 + padding.top
        }
        uiLabel.frame = CGRect(x: padding.left, y: y, width: bounds.width - padding.left - padding.right, height: h)
    }

}
