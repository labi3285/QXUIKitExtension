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
        
    open override var isEnabled: Bool {
        didSet {
            super.isEnabled = isEnabled
            backButton.isDisplay = isEnabled
        }
    }
    open override func height(_ model: Any?) -> CGFloat? {
        let h = super.height(model)
        if let e = h {
            arrowView.fixHeight = e - layoutView.padding.top - layoutView.padding.bottom
        }
        return h
    }

    public var placeHolderFont: QXFont = QXFont(16, QXColor.dynamicPlaceHolder)
    public var placeHolder: String? {
        didSet {
            if richContent == nil && QXEmpty(content) {
                if _originFont == nil {
                    _originFont = subTitleLabel.font
                }
                subTitleLabel.font = placeHolderFont
                subTitleLabel.text = placeHolder ?? ""
            }
        }
    }
    public var content: String? {
        didSet {
            if !QXEmpty(content) {
                if let e = _originFont {
                    subTitleLabel.font = e
                }
                subTitleLabel.text = content ?? ""
            } else {
                if _originFont == nil {
                    _originFont = subTitleLabel.font
                }
                subTitleLabel.font = placeHolderFont
                subTitleLabel.text = placeHolder ?? ""
            }
        }
    }
    public var richContents: [QXRichText]? {
        didSet {
            if let e = richContents {
                subTitleLabel.richTexts = e
            } else {
                if _originFont == nil {
                    _originFont = subTitleLabel.font
                }
                subTitleLabel.font = placeHolderFont
                subTitleLabel.text = placeHolder ?? ""
            }
        }
    }
    
    public var richContent: QXRichText? {
        didSet {
            if let e = richContent {
                richContents = [e]
            } else {
                if _originFont == nil {
                    _originFont = subTitleLabel.font
                }
                subTitleLabel.font = placeHolderFont
                subTitleLabel.text = placeHolder ?? ""
            }
        }
    }
    private var _originFont: QXFont!
    
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
        e.views = [self.titleLabel, QXFlexSpace(), self.subTitleLabel, self.arrowView]
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

open class QXTitleArrow {
    public var title: String?
    public var richTitle: [QXRichText]?
    public var subTitle: String?
    public var richSubTitle: [QXRichText]?
    public var todo: (() -> ())?
    public init(_ title: String) {
        self.title = title
    }
}

open class QXTitleArrowCell: QXTableViewBreakLineCell {
        
    open override class func height(_ model: Any?, _ context: QXTableViewCell.Context) -> CGFloat? {
        return 50
    }
    
    open override var model: Any? {
        didSet {
            if let e = model as? QXTitleArrow {
                if let e = e.richTitle {
                    titleLabel.richTexts = e
                } else {
                    titleLabel.text = e.title ?? ""
                }
                if let e = e.richSubTitle {
                    subTitleLabel.richTexts = e
                } else {
                    subTitleLabel.text = e.subTitle ?? ""
                }
            }
        }
    }
    
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
        e.views = [self.titleLabel, QXFlexSpace(), self.subTitleLabel, self.arrowView]
        return e
    }()
        
    public required init(_ reuseId: String) {
        super.init(reuseId)
        contentView.qxBackgroundColor = QXColor.dynamicBody
        contentView.addSubview(layoutView)
        layoutView.IN(contentView).LEFT.TOP.RIGHT.BOTTOM.MAKE()
        backButton.respondClick = { [weak self] in
            (self?.model as? QXTitleArrow)?.todo?()
            self?.didClickCell()
        }
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
