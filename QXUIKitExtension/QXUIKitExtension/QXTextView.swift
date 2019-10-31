//
//  QXTextView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit


open class QXTextView: QXView, UITextViewDelegate {

    public var respondBeginEditting: (() -> ())?
    public var respondTextChange: ((_ text: String?, _ isEmpty: Bool) -> ())?
    public var respondEndEditting: (() -> ())?
    public var respondNeedsUpdate: (() -> ())?
    
    public var text: String {
        set {
            uiTextView.text = newValue
            placeHolderLabel.isHidden = !newValue.isEmpty
        }
        get {
            return uiTextView.text ?? ""
        }
    }
    
    open var font: QXFont = QXFont(size: 16, color: QXColor.black) {
        didSet {
            uiTextView.font = font.uiFont
            uiTextView.textColor = font.color.uiColor
        }
    }
    
    open var placeHolder: String = "" {
        didSet {
            placeHolderLabel.text = placeHolder
        }
    }
    open var placeHolderfont: QXFont {
        set {
            placeHolderLabel.font = newValue
        }
        get {
            return placeHolderLabel.font
        }
    }

    public var filter: QXTextFilter? {
        didSet {
            if let filter = filter {
                switch filter {
                case .integer(min: _, max: _):
                    uiTextView.keyboardType = .decimalPad
                case .double(min: _, max: _):
                    uiTextView.keyboardType = .decimalPad
                case .float(min: _, max: _):
                    uiTextView.keyboardType = .decimalPad
                case .number(limit: _):
                    uiTextView.keyboardType = .numberPad
                default:
                    break
                }
            }
        }
    }
    
    public lazy var uiTextView: UITextView = {
        let one = UITextView()
        one.backgroundColor = UIColor.clear
        one.qxTintColor = QXColor.hex("#666666", 1)
        one.delegate = self
        return one
    }()
    public lazy var placeHolderLabel: QXLabel = {
        let one = QXLabel()
        one.font = QXFont(size: 16, color: QXColor.placeHolderGray)
        one.padding = QXEdgeInsets(7, 5, 7, 5)
        one.isUserInteractionEnabled = false
        return one
    }()
        
    public override init() {
        super.init()
        addSubview(uiTextView)
        uiTextView.addSubview(placeHolderLabel)
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
                size = uiTextView.sizeThatFits(size)
                w = padding.left + size.width + padding.right
                h = padding.top + size.height + padding.bottom
            } else {
                let size = uiTextView.intrinsicContentSize
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
        uiTextView.qxRect = qxBounds.rectByReduce(padding)
        let wh = placeHolderLabel.intrinsicContentSize
        placeHolderLabel.qxRect = QXRect(0, 0, wh.width, wh.height)
    }

    public var hasSelectRange: Bool {
        if let range =  uiTextView.markedTextRange {            
            if uiTextView.position(from: range.start, offset: 0) != nil {
                return true
            }
        }
        return false
    }

    public func textViewDidBeginEditing(_ textView: UITextView) {
        respondBeginEditting?()
    }
    public func textViewDidEndEditing(_ textView: UITextView) {
        respondEndEditting?()
    }

    public func textViewDidChange(_ textView: UITextView) {
        if !hasSelectRange {
            if let filter = filter {
                let _text = filter.filte(uiTextView.text ?? "")
                if _text != text {
                    text = _text
                }
            }
        }
        placeHolderLabel.isHidden = !text.isEmpty
        respondTextChange?(text, {
            if let text = uiTextView.text {
                return text.isEmpty
            }
            return true
        }())
        respondNeedsUpdate?()
    }
}
