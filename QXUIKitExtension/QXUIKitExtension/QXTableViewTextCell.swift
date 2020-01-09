//
//  QXTextCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/11/12.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXTableViewText {
    
    public init(_ text: String) {
        self.text = text
    }
    public init(_ text: String, _ font: QXFont) {
        self.text = text
        self.font = font
    }
    public init(_ items: [QXRichLabel.Item]) {
        if items.count > 0 {
            self.items = items
        }
    }
    public init(_ items: QXRichLabel.Item...) {
        if items.count > 0 {
            self.items = items
        }
    }
    
    open var text: String = ""
    open var font: QXFont = QXFont(14, QXColor.dynamicText)
    open var items: [QXRichLabel.Item]?
    open var respondTouchLink: ((_ data: Any) -> Void)?
    open var alignmentX: QXAlignmentX = .left
    open var alignmentY: QXAlignmentY = .top
    open var lineSpace: CGFloat = 0
    open var paragraphSpace: CGFloat = 0
    open var justified: Bool = true
    open var firstLineHeadIndent: CGFloat = 0
    open var hyphenationFactor: CGFloat = 0
    open var highlightColor: QXColor = QXColor.dynamicHiglight
    open var isCopyEnabled: Bool = false
    open var padding: QXEdgeInsets = QXEdgeInsets(5, 15, 5, 15)
    open var numberOfLines: Int = 0

}

open class QXTableViewTextCell: QXTableViewCell {
    
    override open func initializedWithTable() {
        super.initializedWithTable()
        label.fixWidth = cellWidth
    }
        
    override open var model: Any? {
        didSet {
            super.model = model
            if let e = model as? QXTableViewText {
                label.respondTouchLink = e.respondTouchLink
                label.alignmentX = e.alignmentX
                label.alignmentY = e.alignmentY
                label.lineSpace = e.lineSpace
                label.paragraphSpace = e.paragraphSpace
                label.justified = e.justified
                label.firstLineHeadIndent = e.firstLineHeadIndent
                label.hyphenationFactor = e.hyphenationFactor
                label.highlightColor = e.highlightColor
                label.numberOfLines = e.numberOfLines
                label.isCopyEnabled = e.isCopyEnabled
                label.padding = e.padding
                if let e = e.items {
                    label.items = e
                } else {
                    label.font = e.font
                    label.text = e.text
                }
            }
        }
    }
    public final lazy var label: QXRichLabel = {
        let e = QXRichLabel()
        e.font = QXFont(14, QXColor.dynamicText)
        e.numberOfLines = 0
        e.isCopyEnabled = true
        return e
    }()
    required public init(_ reuseId: String) {
        super.init(reuseId)
        contentView.addSubview(label)
        label.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        backButton.isDisplay = false
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
