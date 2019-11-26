//
//  QXSettingTextViewCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import QXConsMaker

open class QXSettingTextViewCell: QXSettingCell {

    open override var isEnabled: Bool {
        didSet {
            textView.isEnabled = isEnabled
            super.isEnabled = isEnabled
        }
    }
    
    override open func height(_ model: Any?, _ width: CGFloat) -> CGFloat? {
        textView.maxWidth = width - textView.padding.left - textView.padding.right
        let h = textView.intrinsicContentSize.height
        if let _h = fixHeight {
            return max(_h, h)
        }
        return h
    }

    public final lazy var textView: QXTextView = {
        let e = QXTextView()
        e.padding = QXEdgeInsets(5, 10, 5, 10)
        e.font = QXFont(16, QXColor.dynamicInput)
        e.placeHolderfont = QXFont(16, QXColor.dynamicPlaceHolder)
        e.uiTextView.isScrollEnabled = false
        e.respondNeedsUpdate = { [weak self] in
            self?.tableView?.update()
        }
        return e
    }()

    required public init() {
        super.init()
        contentView.addSubview(textView)
        textView.IN(contentView).LEFT.TOP.RIGHT.BOTTOM.MAKE()
        fixHeight = 100
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    required public init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }

}
