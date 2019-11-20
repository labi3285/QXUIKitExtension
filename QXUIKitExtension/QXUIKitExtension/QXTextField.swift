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
    
    open var isEnabled: Bool = true {
        didSet {
            uiTextField.isEnabled = isEnabled
            uiTextField.alpha = isEnabled ? 1 : 0.3
        }
    }

    public var text: String {
        set {
            uiTextField.text = newValue
        }
        get {
            return uiTextField.text ?? ""
        }
    }
    
    open var font: QXFont = QXFont(16, QXColor.dynamicInput) {
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
    open var placeHolderfont: QXFont = QXFont(16, QXColor.dynamicPlaceHolder) {
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
        
    public var pickerView: QXPickerKeyboardView? {
        didSet {
            if let e = pickerView {
                uiTextField.inputView = e
                e.respondItem = { [weak self] item in
                    self?.pickedItems = item?.items()
                    self?.pickedItem = item
                }
            }
        }
    }
    public private(set) var pickedItem: QXPickerView.Item?
    public var pickedSeparator: String = "-"
    public private(set) var pickedItems: [QXPickerView.Item]? {
        didSet {
            text = pickedItems?.map({ $0.text }).joined(separator: pickedSeparator) ?? ""
            pickedItem = pickedItems?.last
        }
    }
    public var bringInPickedItems: [QXPickerView.Item]? {
        didSet {
            pickedItems = bringInPickedItems
            pickerView?.bringInPickedItems = bringInPickedItems
        }
    }
            
    public lazy var uiTextField: UITextField = {
        let e = UITextField()
        e.clearButtonMode = .never
        e.qxTintColor = QXColor.dynamicAccent
        e.leftViewMode = .never
        e.rightViewMode = .never
        e.delegate = self
        e.addTarget(self, action: #selector(textChange), for: .editingChanged)
        return e
    }()
    private var _originUITextFieldQXTintColor: QXColor?
    public lazy var coverView: UIView = {
        let e = UIView()
        e.backgroundColor = UIColor.clear
        e.isHidden = true
        return e
    }()
    public override init() {
        super.init()
        addSubview(uiTextField)
        addSubview(coverView)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func natureContentSize() -> QXSize {
        var w: CGFloat = 0
        var h: CGFloat = 0
        if let e = fixWidth {
            var size = CGSize(width: QXView.extendLength, height: QXView.extendLength)
            size = uiTextField.sizeThatFits(size)
            w = padding.left + e + padding.right
            h = padding.top + size.height + padding.bottom
        } else {
            let size = uiTextField.intrinsicContentSize
            w = padding.left + size.width + padding.right
            h = padding.top + size.height + padding.bottom
        }
        return QXSize(w, h)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        uiTextField.qxRect = qxBounds.rectByReduce(padding)
        coverView.qxRect = uiTextField.qxRect
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
        coverView.isHidden = pickerView == nil
    }
    public func textFieldDidEndEditing(_ textField: UITextField) {
        respondEndEditting?()
        coverView.isHidden = true
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

