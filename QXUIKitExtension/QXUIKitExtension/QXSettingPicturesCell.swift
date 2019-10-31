//
//  QXSettingPicturesCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/29.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import QXConsMaker

open class QXSettingPicturesCell: QXSettingCell {
    
    open override func height(_ model: Any?, _ width: CGFloat) -> CGFloat? {
        picturesView.applyConfigs(intrinsicWidth: width, xCount: 3, hwRatio: 1/1)
        return picturesView.intrinsicContentSize.height
    }
    
    public lazy var picturesView: QXEditPicturesView = {
        let one = QXEditPicturesView(9)
        one.padding = QXEdgeInsets(10, 15, 10, 15)
        one.respondNeedsLayout = { [weak self] in
            self?.tableView?.setNeedsUpdate()
        }
        return one
    }()
    
    required public init() {
        super.init()
        contentView.addSubview(picturesView)
        picturesView.IN(contentView).LEFT.TOP.RIGHT.BOTTOM.MAKE()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    required public init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }
    
}
