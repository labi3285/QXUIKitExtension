//
//  QXTextField.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXTextField: QXView, UITextFieldDelegate {
    
    public var respondBeginEditting: (() -> ())?
    public var respondTextChange: ((_ text: String?, _ isEmpty: Bool) -> ())?
    public var respondEndEditting: (() -> ())?
    public var respondReturn: (() -> ())?
    
    public var text: String {
        set {
            uiTextField.text = newValue
        }
        get {
            return uiTextField.text ?? ""
        }
    }
    
    open var font: QXFont = QXFont(size: 16, color: QXColor.black) {
        didSet {
            uiTextField.font = font.uiFont
            uiTextField.textColor = font.color.uiColor
        }
    }
    
    
    open var placeHolder: String = "" {
        didSet {
            uiTextField.attributedPlaceholder = placeHolderfont.nsAttributtedString(placeHolder)
                   qxSetNeedsLayout()
        }
    }
    open var placeHolderfont: QXFont = QXFont(size: 16, color: QXColor.placeHolderGray) {
        didSet {
            uiTextField.attributedPlaceholder = placeHolderfont.nsAttributtedString(placeHolder)
            qxSetNeedsLayout()
        }
    }
    
    public var filter: QXTextFilter? {
        didSet {
            if let filter = filter {
                switch filter {
                case .integer(min: _, max: _):
                    uiTextField.keyboardType = .decimalPad
                case .double(min: _, max: _):
                    uiTextField.keyboardType = .decimalPad
                case .float(min: _, max: _):
                    uiTextField.keyboardType = .decimalPad
                case .number(limit: _):
                    uiTextField.keyboardType = .numberPad
                case .money(min: _, max: _):
                    uiTextField.keyboardType = .decimalPad
                default:
                    break
                }
            }
        }
    }
        
    public lazy var uiTextField: UITextField = {
        let one = UITextField()
        one.clearButtonMode = .whileEditing
        one.qxTintColor = QXColor.hex("#666666", 1)
        one.leftViewMode = .never
        one.rightViewMode = .never
        one.delegate = self
        one.addTarget(self, action: #selector(textChange), for: .editingChanged)
        return one
    }()
        
    public override init() {
        super.init()
        addSubview(uiTextField)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var intrinsicWidth: CGFloat?
    open override var intrinsicContentSize: CGSize {
        if isDisplay {
            var w: CGFloat = 0
            var h: CGFloat = 0
            if let e = intrinsicSize {
                w = e.w
                h = e.h
            } else if let e = intrinsicWidth {
                var size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
                size = uiTextField.sizeThatFits(size)
                w = padding.left + e + padding.right
                h = padding.top + size.height + padding.bottom
            } else {
                let size = uiTextField.intrinsicContentSize
                w = padding.left + size.width + padding.right
                h = padding.top + size.height + padding.bottom
            }
            return CGSize(width: w, height: h)
        } else {
            return CGSize.zero
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        uiTextField.qxRect = qxBounds.rectByReduce(padding)
    }
    
    public var hasSelectRange: Bool {
        if let range =  uiTextField.markedTextRange {
            if uiTextField.position(from: range.start, offset: 0) != nil {
                return true
            }
        }
        return false
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        respondReturn?()
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        respondBeginEditting?()
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        respondEndEditting?()
    }
    
    @objc func textChange() {
        if !hasSelectRange {
            if let filter = filter {
                let _text = filter.filte(uiTextField.text ?? "")
                if _text != text {
                    text = _text
                }
            }
        }
        respondTextChange?(text, {
            if let text = uiTextField.text {
                return text.isEmpty
            }
            return true
        }())        
    }
}
