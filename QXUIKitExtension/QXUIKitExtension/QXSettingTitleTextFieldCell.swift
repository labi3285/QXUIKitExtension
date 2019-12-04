//
//  QXSettingTitleTextFieldCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import QXConsMaker

open class QXSettingTitleTextFieldCell: QXSettingCell {

    open override var isEnabled: Bool {
        didSet {
            textField.isEnabled = isEnabled
            super.isEnabled = isEnabled
        }
    }
    
    public final lazy var titleLabel: QXLabel = {
        let e = QXLabel()
        e.numberOfLines = 1
        e.font = QXFont(16, QXColor.dynamicTitle)
        return e
    }()
    public final lazy var textField: QXTextField = {
        let e = QXTextField()
        e.extendSize = true
        e.font = QXFont(16, QXColor.dynamicInput)
        e.placeHolderfont = QXFont(16, QXColor.dynamicPlaceHolder)
        e.uiTextField.textAlignment = .right
        e.compressResistanceX = QXView.resistanceEasyDeform
        e.placeHolder = "输入内容"
        return e
    }()
    public final lazy var suffixLabel: QXLabel = {
        let e = QXLabel()
        e.respondNeedsLayout = { [weak e, weak self] in
            e?.isDisplay = !QXEmpty(e?.uiLabel.attributedText?.string ?? e?.uiLabel.text)
            self?.layoutView.qxSetNeedsLayout()
        }
        return e
    }()
    public final lazy var layoutView: QXStackView = {
        let e = QXStackView()
        e.alignmentY = .center
        e.alignmentX = .left
        e.viewMargin = 10
        e.padding = QXEdgeInsets(5, 15, 5, 15)
        e.views = [self.titleLabel, QXFlexSpace(), self.textField, self.suffixLabel]
        return e
    }()

    public required init() {
        super.init()
        contentView.addSubview(layoutView)
        layoutView.IN(contentView).LEFT.TOP.RIGHT.BOTTOM.MAKE()
        fixHeight = 50
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public required init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }
    
    public class SuffixLabel: QXLabel {
        override public var text: String {
            didSet {
                super.text = text
                isDisplay = !QXEmpty(uiLabel.attributedText?.string ?? uiLabel.text)
            }
        }
        override public var font: QXFont {
            didSet {
                super.font = font
                isDisplay = !QXEmpty(uiLabel.attributedText?.string ?? uiLabel.text)
            }
        }
        override public var richTexts: [QXRichText]? {
            didSet {
                super.richTexts = richTexts
                isDisplay = !QXEmpty(uiLabel.attributedText?.string ?? uiLabel.text)
            }
        }
        
    }

}
