//
//  QXSettingTitleSelectArrowCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2020/1/15.
//  Copyright © 2020 labi3285_lab. All rights reserved.
//

import UIKit
import QXConsMaker

open class QXSettingTitleCheckArrowCell: QXSettingCell {
        
    open var isChecked: Bool = false {
        didSet {
            iconView.isHidden = !isChecked
        }
    }
    
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
        }
        return h
    }
    
    public final lazy var titleLabel: QXLabel = {
        let e = QXLabel()
        e.numberOfLines = 1
        e.font = QXFont(16, QXColor.dynamicTitle)
        return e
    }()
    public final lazy var iconView: QXImageView = {
        let e = QXImageView()
        e.qxTintColor = QXColor.hex("#20a464", 1)
        e.image = QXUIKitExtensionResources.shared.image("icon_check.png")
            .setSize(20, 20)
            .setRenderingMode(.alwaysTemplate)
        e.compressResistance = QXView.resistanceStable
        e.respondUpdateImage = { [weak self] in
            self?.layoutView.setNeedsLayout()
        }
        e.compressResistanceX = 2
        e.isHidden = true
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
        e.views = [self.titleLabel, self.iconView, QXFlexSpace(), self.arrowView]
        return e
    }()
        
    public required init() {
        super.init()
        contentView.addSubview(layoutView)
        layoutView.IN(contentView).LEFT.TOP.RIGHT.BOTTOM.MAKE()
        backButton.isDisplay = true
        fixHeight = 50
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public required init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }
    
}
