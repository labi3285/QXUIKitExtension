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
    
    open var minHeight: CGFloat = 100
    open var maxHeight: CGFloat?

    open override func height(_ model: Any?) -> CGFloat? {
        if let e = fixHeight {
            return e
        }
        textView.fixWidth = ((context?.givenWidth ?? 0)) - textView.padding.left - textView.padding.right
        var h = textView.intrinsicContentSize.height
        h = max(minHeight, h)
        if let e = maxHeight {
            h = min(e, h)
        }
        return h
    }

    public final lazy var textView: QXTextView = {
        let e = QXTextView()
        e.padding = QXEdgeInsets(5, 10, 5, 10)
        e.font = QXFont(16, QXColor.dynamicInput)
        e.placeHolderFont = QXFont(16, QXColor.dynamicPlaceHolder)
        //e.uiTextView.isScrollEnabled = false
        e.respondNeedsUpdate = { [weak self] in
            self?.context?.tableView?.update()
        }
        return e
    }()

    public required init() {
        super.init()
        contentView.addSubview(textView)
        textView.IN(contentView).LEFT.TOP.RIGHT.BOTTOM.MAKE()
        fixHeight = nil
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public required init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }

}
