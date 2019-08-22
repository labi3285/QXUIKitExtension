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
            uiLabel.attributedText = font.nsAttributtedString(text)
            richTexts = nil
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

    open var margin: QXMargin = QXMargin.zero

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
                var size = CGSize(width: e, height: CGFloat.greatestFiniteMagnitude)
                size = uiLabel.sizeThatFits(size)
                w = margin.left + size.width + margin.right
                h = margin.top + size.height + margin.bottom
            } else {
                let size = uiLabel.intrinsicContentSize
                w = margin.left + size.width + margin.right
                h = margin.top + size.height + margin.bottom
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
        let size = uiLabel.sizeThatFits(CGSize.init(width: bounds.width - margin.left - margin.right, height: CGFloat.greatestFiniteMagnitude))
        let h = min(size.height, bounds.height - margin.bottom - margin.bottom)
        let y: CGFloat
        switch alignmentY {
        case .top:
            y = margin.top
        case .center:
            y = (bounds.height - margin.top - margin.bottom - h) / 2 + margin.top
        case .bottom:
            y = (bounds.height - margin.bottom - h) / 2 + margin.top
        }
        uiLabel.frame = CGRect(x: margin.left, y: y, width: bounds.width - margin.left - margin.right, height: h)
    }

}
