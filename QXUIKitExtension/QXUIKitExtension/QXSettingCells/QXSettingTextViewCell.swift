//
//  QXSettingTextViewCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXSettingTextViewCell: QXSettingCell {

    open override func height(_ model: Any?, _ width: CGFloat) -> CGFloat? {
        textView.intrinsicWidth = width - textView.padding.left - textView.padding.right
        let h = textView.intrinsicContentSize.height
        if let _h = height {
            return max(_h, h)
        }
        return h
    }

    public lazy var textView: QXTextView = {
        let one = QXTextView()
        one.padding = QXMargin(5, 15, 5, 15)
        one.font = QXFont(fmt: "15 #333333")
        one.placeHolderfont = QXFont(fmt: "16 #999999")
        one.uiTextView.isScrollEnabled = false
        one.respondNeedsUpdate = { [weak self] in
            self?.tableView.update()
        }
        return one
    }()

    required public init() {
        super.init()
        contentView.addSubview(textView)
        textView.IN(contentView).LEFT.TOP.RIGHT.BOTTOM.MAKE()
        height = 100
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    required public init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }

}
