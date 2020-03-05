//
//  QXSettingTitleSegsControlCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2020/2/7.
//  Copyright © 2020 labi3285_lab. All rights reserved.
//

import UIKit
import QXConsMaker

open class QXSettingTitleSegsControlCell: QXSettingCell {
    
    public final lazy var titleLabel: QXLabel = {
        let e = QXLabel()
        e.numberOfLines = 1
        e.font = QXFont(16, QXColor.dynamicTitle)
        return e
    }()
    public final lazy var segsControlView: QXSegsControlView = {
        let e = QXSegsControlView()
        e.compressResistance = QXView.resistanceStable
        return e
    }()
    
    public final lazy var layoutView: QXStackView = {
        let e = QXStackView()
        e.alignmentY = .center
        e.alignmentX = .left
        e.viewMargin = 10
        e.padding = QXEdgeInsets(5, 15, 5, 15)
        e.views = [self.titleLabel, QXFlexSpace(), self.segsControlView]
        return e
    }()
    
    public required init() {
        super.init()
        contentView.addSubview(layoutView)
        layoutView.IN(contentView).LEFT.TOP.RIGHT.BOTTOM.MAKE()
        fixHeight = 50
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public required init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }
    
}
