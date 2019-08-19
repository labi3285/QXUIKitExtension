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
    open var alignmentY: QXAlignmentY = .top

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

    public init() {
        super.init(frame: CGRect.zero)
        addSubview(uiLabel)
        isUserInteractionEnabled = false
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var intrinsicWidth: CGFloat?
    open override var intrinsicContentSize: CGSize {
        if isDisplay {
            if let e = intrinsicSize {
                return e.cgSize
            } else if let e = intrinsicWidth {
                let size = uiLabel.sizeThatFits(CGSize(width: e - margin.left - margin.right, height: CGFloat.greatestFiniteMagnitude))
                return CGSize(width: e,
                              height: margin.top + size.height + margin.bottom)
            } else {
                let size = uiLabel.intrinsicContentSize
                return CGSize(width: margin.left + size.width + margin.right,
                              height: margin.top + size.height + margin.bottom)
            }
        } else {
            return CGSize.zero
        }
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        let size = uiLabel.sizeThatFits(CGSize.init(width: bounds.width - margin.left - margin.right, height: CGFloat.greatestFiniteMagnitude))
        let h = min(size.height, bounds.height - margin.bottom - size.height)
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
