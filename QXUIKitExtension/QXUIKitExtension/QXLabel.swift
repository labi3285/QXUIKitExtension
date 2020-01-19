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
    open var font: QXFont = QXFont(14, QXColor.dynamicText) {
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
    
    public final lazy var uiLabel: UILabel = {
        let e = UILabel()
        return e
    }()

    public override init() {
        super.init()
        addSubview(uiLabel)
        isUserInteractionEnabled = false
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func natureContentSize() -> QXSize {
        if let e = fixWidth ?? maxWidth {
            var size = CGSize(width: e - padding.left - padding.right, height: QXView.extendLength)
            size = uiLabel.sizeThatFits(size)
            return size.qxSize.sizeByAdd(padding)
        } else {
            return uiLabel.sizeThatFits(QXView.extendSize.cgSize).qxSize.sizeByAdd(padding)
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        let size = uiLabel.sizeThatFits(CGSize.init(width: bounds.width - padding.left - padding.right, height: QXView.extendLength))
        let h = min(size.height, bounds.height - padding.top - padding.bottom)
        let w = min(size.width, bounds.width - padding.left - padding.right)
        let x: CGFloat
        switch alignmentX {
        case .left:
            x = padding.left
        case .center:
            x = (bounds.width - padding.left - padding.right - w) / 2 + padding.left
        case .right:
            x = bounds.width - padding.right - w
        }
        let y: CGFloat
        switch alignmentY {
        case .top:
            y = padding.top
        case .center:
            y = (bounds.height - padding.top - padding.bottom - h) / 2 + padding.top
        case .bottom:
            y = bounds.height - padding.bottom - h
        }
        uiLabel.frame = CGRect(x: x, y: y, width: w, height: h)
    }
    
    //MARK:- COPY
    public var isCopyEnabled: Bool = false {
        didSet {
            if isCopyEnabled {
                addGestureRecognizer(longGestureRecognizer)
                isUserInteractionEnabled = true
            } else {
                removeGestureRecognizer(longGestureRecognizer)
                isUserInteractionEnabled = false
            }
        }
    }
    private final lazy var longGestureRecognizer: UILongPressGestureRecognizer = {
        let e = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        return e
    }()
    @objc func longPressed(_ recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            self.becomeFirstResponder()
            let copyMenu = UIMenuItem(title: "复制", action: #selector(copyitem(menuVc:)))
            let menu = UIMenuController.shared
            menu.menuItems = [copyMenu]
            menu.setTargetRect(uiLabel.frame, in: self)
            menu.arrowDirection = .down
            menu.update()
            menu.setMenuVisible(true, animated: true)
        }
    }
    @objc func copyitem(menuVc: UIMenuController) {
        UIPasteboard.general.string = uiLabel.text ?? ""
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

}

