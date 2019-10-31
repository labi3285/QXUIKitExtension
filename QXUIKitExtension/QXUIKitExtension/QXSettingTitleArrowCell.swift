//
//  QXSettingTitleArrowCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import QXConsMaker

open class QXSettingTitleArrowCell: QXSettingCell {
        

    open override func height(_ model: Any?, _ width: CGFloat) -> CGFloat? {
        let h = super.height(model, width)
        if let e = h {
            arrowView.intrinsicHeight = e - layoutView.padding.top - layoutView.padding.bottom
        }
        return h
    }
    
    public lazy var titleLabel: QXLabel = {
        let one = QXLabel()
        one.numberOfLines = 1
        one.font = QXFont(fmt: "16 #333333")
        return one
    }()
    public lazy var subTitleLabel: QXLabel = {
        let one = QXLabel()
        one.numberOfLines = 1
        one.font = QXFont(fmt: "14 #666666")
        return one
    }()
    public lazy var arrowView: QXImageView = {
        let one = QXImageView()
        one.qxTintColor = QXColor.hex("#666666", 1)
        one.image = QXUIKitExtensionResources.shared.image("icon_arrow.png")        .setRenderingMode(.alwaysTemplate)
        one.respondUpdateImage = { [weak self] in
            self?.layoutView.setNeedsLayout()
        }
        return one
    }()
    public lazy var layoutView: QXStackView = {
        let one = QXStackView()
        one.alignmentY = .center
        one.alignmentX = .left
        one.viewMargin = 10
        one.padding = QXEdgeInsets(5, 10, 5, 15)
        one.setupViews([self.titleLabel, QXFlexView(), self.subTitleLabel, self.arrowView], collapseOrder: [0, 2, 1, 3])
        return one
    }()
    
    public lazy var backButton: QXButton = {
        let one = QXButton()
        one.backView.backgroundColorHighlighted = QXColor.higlightGray
        return one
    }()
    
    required public init() {
        super.init()
        contentView.addSubview(backButton)
        contentView.addSubview(layoutView)
        layoutView.IN(contentView).LEFT.TOP.RIGHT.BOTTOM.MAKE()
        fixHeight = 50
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    required public init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        backButton.frame = contentView.bounds
    }
    
}
