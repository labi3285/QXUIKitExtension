//
//  QXTextField.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXTextField: QXView, UITextFieldDelegate {
    
    public var respondBeginEditting: (() -> Void)?
    public var respondTextChange: ((_ text: String?, _ isEmpty: Bool) -> Void)?
    public var respondEndEditting: (() -> Void)?
    public var respondReturn: (() -> Void)?
    
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
            uiTextField.qxUpdateFilter(filter)
        }
    }
        
    public var pickerView: QXPickersView? {
        didSet {
            if let e = pickerView {
                uiTextField.inputView = QXKeyboardView(e)
                e.respondItem = { [weak self] item in
                    self?.pickedItems = item?.items()
                    self?.pickedItem = item
                }
            }
        }
    }
    public private(set) var pickedItem: QXPickerView.Item?
    public var pickedTextParser: ([String]?) -> String?
        = { strs in strs?.joined(separator: "-") }
    public private(set) var pickedItems: [QXPickerView.Item]? {
        didSet {
            text = pickedTextParser(pickedItems?.map{ $0.text }) ?? ""
            pickedItem = pickedItems?.last
        }
    }
    public var bringInPickedItems: [QXPickerView.Item]? {
        didSet {
            pickedItems = bringInPickedItems
            pickerView?.bringInPickedItems = bringInPickedItems
        }
    }
    
    open var iconView: QXView? {
        didSet {
            if let e = oldValue {
                e.removeFromSuperview()
            }
            if let e = iconView {
                addSubview(e)
                layoutSubviews()
            }
        }
    }
    open var clearButton: QXButton? {
        didSet {
            if let e = oldValue {
                e.removeFromSuperview()
            }
            if let e = clearButton {
                addSubview(e)
                e.isDisplay = text.count > 0
                layoutSubviews()
                e.respondClick = { [unowned self] in
                    self.text = ""
                }
            }
        }
    }
    open var handleButton: QXButton? {
        didSet {
            if let e = oldValue {
                e.removeFromSuperview()
            }
            if let e = handleButton {
                addSubview(e)
                layoutSubviews()
            }
        }
    }
    
    public var buttonMargin: CGFloat = 0
    
    public final lazy var uiTextField: UITextField = {
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
    public final lazy var coverView: UIView = {
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
    public required init?(coder aDecoder: NSCoder) {
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
            let tfwh = uiTextField.intrinsicContentSize
            var leftSpace: CGFloat = 0
            var rightSpace: CGFloat = 0
            var maxH: CGFloat = 0
            if let e = iconView, e.isDisplay {
                let wh = e.natureSize
                leftSpace += wh.w + buttonMargin
                maxH = max(maxH, wh.h)
            }
            if let e = clearButton, e.isDisplay {
                let wh = e.natureSize
                rightSpace += wh.w
                maxH = max(maxH, wh.h)
            }
            if let e = handleButton, e.isDisplay {
                let wh = e.natureSize
                rightSpace += wh.w
                maxH = max(maxH, wh.h)
            }
            if let a = clearButton, a.isDisplay, let b = handleButton, b.isDisplay {
                rightSpace += buttonMargin * 2
            } else if let a = clearButton, a.isDisplay {
                rightSpace += buttonMargin
            } else if let b = handleButton, b.isDisplay {
                rightSpace += buttonMargin
            }
            w = padding.left + tfwh.width + leftSpace + rightSpace + padding.right
            h = padding.left + max(tfwh.height, maxH) + padding.right
        }
        return QXSize(w, h)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        if let i = iconView, i.isDisplay {
            let whi = i.natureSize
            i.qxRect = qxBounds.insideRect(.left(padding.left), .center, .size(whi))
            if let a = clearButton, a.isDisplay, let b = handleButton, b.isDisplay {
                let wha = a.natureSize
                let whb = b.natureSize
                b.qxRect = qxBounds.insideRect(.right(padding.right), .center, .size(whb))
                a.qxRect = qxBounds.insideRect(.right(padding.right + whb.w + buttonMargin), .center, .size(wha))
                uiTextField.qxRect = qxBounds.insideRect(.left(padding.left + whi.w + buttonMargin), .top(padding.top), .bottom(padding.bottom), .right(padding.right + buttonMargin + wha.w + buttonMargin + whb.w))
            } else if let a = clearButton, a.isDisplay {
                let wha = a.natureSize
                a.qxRect = qxBounds.insideRect(.right(padding.right), .center, .size(wha))
                uiTextField.qxRect = qxBounds.insideRect(.left(padding.left + whi.w + buttonMargin), .top(padding.top), .bottom(padding.bottom), .right(padding.right + wha.w + buttonMargin))
            } else if let b = handleButton, b.isDisplay {
               let whb = b.natureSize
               b.qxRect = qxBounds.insideRect(.right(padding.right), .center, .size(whb))
               uiTextField.qxRect = qxBounds.insideRect(.left(padding.left + whi.w + buttonMargin), .top(padding.top), .bottom(padding.bottom), .right(padding.right + whb.w + buttonMargin))
            } else {
                uiTextField.qxRect = qxBounds.insideRect(.left(padding.left + whi.w + buttonMargin), .top(padding.top), .bottom(padding.bottom), .right(padding.right))
            }
        } else {
            if let a = clearButton, a.isDisplay, let b = handleButton, b.isDisplay {
                let wha = a.natureSize
                let whb = b.natureSize
                b.qxRect = qxBounds.insideRect(.right(padding.right), .center, .size(whb))
                a.qxRect = qxBounds.insideRect(.right(padding.right + whb.w + buttonMargin), .center, .size(wha))
                uiTextField.qxRect = qxBounds.insideRect(.left(padding.left), .top(padding.top), .bottom(padding.bottom), .right(padding.right + whb.w + buttonMargin + whb.w + buttonMargin + wha.w))
            } else if let a = clearButton, a.isDisplay {
                let wha = a.natureSize
                a.qxRect = qxBounds.insideRect(.right(padding.right), .center, .size(wha))
                uiTextField.qxRect = qxBounds.insideRect(.left(padding.left), .top(padding.top), .bottom(padding.bottom), .right(padding.right + wha.w + buttonMargin))
            } else if let b = handleButton, b.isDisplay {
               let whb = b.natureSize
               b.qxRect = qxBounds.insideRect(.right(padding.right), .center, .size(whb))
               uiTextField.qxRect = qxBounds.insideRect(.left(padding.left), .top(padding.top), .bottom(padding.bottom), .right(padding.right + whb.w + buttonMargin))
            } else {
                uiTextField.qxRect = qxBounds.rectByReduce(padding)
            }
        }
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
        if QXEmpty(textField.text) {
            pickerView?.checkOrPerformSelectAtInit()
        }
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
            respondTextChange?(text, {
                if let text = uiTextField.text {
                    return text.isEmpty
                }
                return true
            }())
        }
        clearButton?.isDisplay = text.count > 0
        layoutSubviews()
    }
}



