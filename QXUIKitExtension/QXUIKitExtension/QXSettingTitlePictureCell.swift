//
//  QXSettingTitlePictureCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/29.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import QXConsMaker
import TZImagePickerController

open class QXSettingTitlePictureCell: QXSettingCell {

    public lazy var titleLabel: QXLabel = {
        let one = QXLabel()
        one.numberOfLines = 1
        one.intrinsicMinHeight = 999
        one.alignmentY = .top
        one.padding = QXEdgeInsets(10, 0, 10, 0)
        one.font = QXFont(fmt: "16 #333333")
        return one
    }()

    public lazy var pictureView: QXEditPictureView = {
        let one = QXEditPictureView()
        one.intrinsicSize = QXSize(100, 100)
        return one
    }()
        
    public lazy var layoutView: QXStackView = {
        let one = QXStackView()
        one.alignmentY = .center
        one.alignmentX = .left
        one.viewMargin = 10
        one.padding = QXEdgeInsets(5, 15, 5, 15)
        one.setupViews([self.titleLabel, QXFlexView(), self.pictureView])
        return one
    }()
    
    required public init() {
        super.init()
        contentView.addSubview(layoutView)
        layoutView.IN(contentView).LEFT.TOP.RIGHT.BOTTOM.MAKE()
        fixHeight = 120
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    required public init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }
    
}
