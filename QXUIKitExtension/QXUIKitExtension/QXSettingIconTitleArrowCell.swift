//
//  QXSettingIconTitleStackCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/11/8.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import QXConsMaker

open class QXSettingIconTitleArrowCell: QXSettingCell {
        
    open override var isEnabled: Bool {
        didSet {
            super.isEnabled = isEnabled
            backButton.isDisplay = isEnabled
        }
    }
    
    override open func height(_ model: Any?, _ width: CGFloat) -> CGFloat? {
        let h = super.height(model, width)
        if let e = h {
            arrowView.fixHeight = e - layoutView.padding.top - layoutView.padding.bottom
            iconView.fixHeight = e - layoutView.padding.top - layoutView.padding.bottom
        }
        return h
    }
    
    public final lazy var iconView: QXImageView = {
        let e = QXImageView()
        e.qxTintColor = QXColor.dynamicIndicator
        e.image = QXUIKitExtensionResources.shared.image("icon_setting.png")
            .setSize(24, 24)
            .setRenderingMode(.alwaysTemplate)
        e.compressResistance = QXView.resistanceStable
        e.respondUpdateImage = { [weak self] in
            self?.layoutView.setNeedsLayout()
        }
        return e
    }()
    public final lazy var titleLabel: QXLabel = {
        let e = QXLabel()
        e.numberOfLines = 1
        e.font = QXFont(16, QXColor.dynamicTitle)
        return e
    }()
    public final lazy var subTitleLabel: QXLabel = {
        let e = QXLabel()
        e.numberOfLines = 1
        e.font = QXFont(14, QXColor.dynamicSubTitle)
        e.compressResistanceX = QXView.resistanceEasyDeform
        return e
    }()
    public final lazy var arrowView: QXImageView = {
        let e = QXImageView()
        e.qxTintColor = QXColor.dynamicIndicator
        e.image = QXUIKitExtensionResources.shared.image("icon_arrow.png")
            .setRenderingMode(.alwaysTemplate)
        e.compressResistance = QXView.resistanceStable
        e.respondUpdateImage = { [weak self] in
            self?.layoutView.setNeedsLayout()
        }
        return e
    }()
    public final lazy var layoutView: QXStackView = {
        let e = QXStackView()
        e.alignmentY = .center
        e.alignmentX = .left
        e.viewMargin = 10
        e.padding = QXEdgeInsets(5, 10, 5, 15)
        e.setupViews(self.iconView, self.titleLabel, QXFlexSpace(), self.subTitleLabel, self.arrowView)
        return e
    }()
        
    required public init() {
        super.init()
        contentView.addSubview(layoutView)
        layoutView.IN(contentView).LEFT.TOP.RIGHT.BOTTOM.MAKE()
        backButton.isDisplay = true
        fixHeight = 50
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    required public init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }
    
}
