//
//  QXTextView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

open class QXTextView: QXView, UITextViewDelegate {

    public var respondBeginEditting: (() -> Void)?
    public var respondTextChange: ((_ text: String?, _ isEmpty: Bool) -> Void)?
    public var respondEndEditting: (() -> Void)?
    public var respondNeedsUpdate: (() -> Void)?
    
    open var isEnabled: Bool = true {
        didSet {
            if isEnabled {
                uiTextView.isUserInteractionEnabled = true
                uiTextView.alpha = 1
            } else {
                uiTextView.isUserInteractionEnabled = false
                uiTextView.alpha = 0.3
            }
        }
    }
    
    public var text: String {
        set {
            uiTextView.text = newValue
            placeHolderLabel.isHidden = !newValue.isEmpty
        }
        get {
            return uiTextView.text ?? ""
        }
    }

    open var font: QXFont = QXFont(16, QXColor.dynamicInput) {
        didSet {
            uiTextView.font = font.uiFont
            uiTextView.textColor = font.color.uiColor
        }
    }
    
    open var placeHolder: String = "" {
        didSet {
            toolbarPlaceholder = placeHolder
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
            uiTextView.qxUpdateFilter(filter)
        }
    }
    
    public final lazy var uiTextView: UITextView = {
        let e = UITextView()
        e.backgroundColor = UIColor.clear
        e.qxTintColor = QXColor.dynamicAccent
        let p = e.textContainer.lineFragmentPadding
        e.textContainerInset = UIEdgeInsets(top: 0, left: -p, bottom: 0, right: -p)
        e.delegate = self
        return e
    }()
    public final lazy var placeHolderLabel: QXLabel = {
        let e = QXLabel()
        e.font = QXFont(16, QXColor.dynamicPlaceHolder)
        e.padding = QXEdgeInsets(7, 5, 7, 5)
        e.isUserInteractionEnabled = false
        return e
    }()
        
    public override init() {
        super.init()
        addSubview(uiTextView)
        uiTextView.addSubview(placeHolderLabel)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func natureContentSize() -> QXSize {
        if let e = fixWidth ?? maxWidth {
            var size = CGSize(width: e, height: QXView.extendLength)
            size = uiTextView.sizeThatFits(size)
            return size.qxSize.sizeByAdd(padding)
        } else {
            return uiTextView.qxIntrinsicContentSize.sizeByAdd(padding)
        }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        uiTextView.qxRect = qxBounds.rectByReduce(padding)
        let wh = placeHolderLabel.natureContentSize()
        placeHolderLabel.qxRect = QXRect(wh)
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
            respondTextChange?(text, {
                if let text = uiTextView.text {
                    return text.isEmpty
                }
                return true
            }())
            respondNeedsUpdate?()
        }
        placeHolderLabel.isHidden = !text.isEmpty
    }
}
