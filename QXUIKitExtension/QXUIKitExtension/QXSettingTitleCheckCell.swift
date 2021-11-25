//
//  QXSettingTitleSelectCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/11/8.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import QXConsMaker

open class QXSettingTitleCheckCell: QXSettingCell {
    
    open var isChecked: Bool = false {
        didSet {
            iconView.isHidden = !isChecked
        }
    }
    
    open override var isEnabled: Bool {
        didSet {
            super.isEnabled = isEnabled
            backButton.isEnabled = isEnabled
        }
    }
    
    open override func height(_ model: Any?) -> CGFloat? {
        let h = super.height(model)
        if let e = h {
            iconView.fixHeight = e - layoutView.padding.top - layoutView.padding.bottom
        }
        return h
    }

    public final lazy var titleLabel: QXLabel = {
        let e = QXLabel()
        e.numberOfLines = 1
        e.font = QXFont(16, QXColor.dynamicTitle)
        e.compressResistanceX = 1
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
    public final lazy var layoutView: QXStackView = {
        let e = QXStackView()
        e.alignmentY = .center
        e.alignmentX = .left
        e.viewMargin = 10
        e.padding = QXEdgeInsets(5, 15, 5, 15)
        e.views = [self.titleLabel, QXFlexSpace(), self.iconView]
        return e
    }()
        
    public required init() {
        super.init()
        contentView.addSubview(layoutView)
        layoutView.IN(contentView).LEFT.TOP.RIGHT.BOTTOM.MAKE()
        fixHeight = 50
        backButton.isDisplay = true
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public required init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }
    
}


open class QXTitleCheck {
    public var title: String?
    public var richTitle: [QXRichText]?
    public var isChecked: Bool = false
    public var todo: (() -> ())?
    public init(_ title: String, _ isChecked: Bool) {
        self.title = title
        self.isChecked = isChecked
    }
}

open class QXCheckCell: QXTableViewBreakLineCell {
    
    open override class func height(_ model: Any?, _ context: QXTableViewCell.Context) -> CGFloat? {
        return 50
    }
    
    open override var model: Any? {
        didSet {
            if let e = model as? QXTitleCheck {
                if let e = e.richTitle {
                    titleLabel.richTexts = e
                } else {
                    titleLabel.text = e.title ?? ""
                }
                iconView.isHidden = !e.isChecked
            }
        }
    }

    public final lazy var titleLabel: QXLabel = {
        let e = QXLabel()
        e.numberOfLines = 1
        e.font = QXFont(16, QXColor.dynamicTitle)
        e.compressResistanceX = 1
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
    public final lazy var layoutView: QXStackView = {
        let e = QXStackView()
        e.alignmentY = .center
        e.alignmentX = .left
        e.viewMargin = 10
        e.padding = QXEdgeInsets(5, 15, 5, 15)
        e.views = [self.titleLabel, QXFlexSpace(), self.iconView]
        return e
    }()
    
    public required init(_ reuseId: String) {
        super.init(reuseId)
        contentView.qxBackgroundColor = QXColor.dynamicBody
        contentView.addSubview(layoutView)
        layoutView.IN(contentView).LEFT.TOP.RIGHT.BOTTOM.MAKE()
        backButton.respondClick = { [weak self] in
            (self?.model as? QXTitleCheck)?.todo?()
            self?.didClickCell()
        }
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
