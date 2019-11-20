//
//  QXSettingTitleSwitchCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import QXConsMaker

open class QXSettingTitleSwitchCell: QXSettingCell {
    
    open override var isEnabled: Bool {
        didSet {
            super.isEnabled = isEnabled
            switchView.isEnabled = isEnabled
        }
    }
    
    public lazy var titleLabel: QXLabel = {
        let e = QXLabel()
        e.numberOfLines = 1
        e.font = QXFont(size: 16, color: QXColor.dynamicTitle)
        return e
    }()
    public lazy var switchView: QXSwitchView = {
        let e = QXSwitchView()
        e.compressResistance = QXView.resistanceStable
        return e
    }()
    
    public lazy var layoutView: QXStackView = {
        let e = QXStackView()
        e.alignmentY = .center
        e.alignmentX = .left
        e.viewMargin = 10
        e.padding = QXEdgeInsets(5, 15, 5, 15)
        e.setupViews([self.titleLabel, QXFlexSpace(), self.switchView])
        return e
    }()
    
    required public init() {
        super.init()
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
    
}
