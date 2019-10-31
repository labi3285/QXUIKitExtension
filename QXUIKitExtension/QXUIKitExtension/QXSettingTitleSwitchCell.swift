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
    
    public lazy var titleLabel: QXLabel = {
        let one = QXLabel()
        one.numberOfLines = 1
        one.font = QXFont(fmt: "16 #333333")
        return one
    }()
    public lazy var switchView: QXSwitchView = {
        let one = QXSwitchView()
        return one
    }()
    
    public lazy var layoutView: QXStackView = {
        let one = QXStackView()
        one.alignmentY = .center
        one.alignmentX = .left
        one.viewMargin = 10
        one.padding = QXEdgeInsets(5, 15, 5, 15)
        one.setupViews([self.titleLabel, QXFlexView(), self.switchView])
        return one
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
