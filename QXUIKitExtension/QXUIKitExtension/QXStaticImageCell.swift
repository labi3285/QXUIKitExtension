//
//  QXStaticImageCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/11/12.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import QXConsMaker

open class QXStaticImageCell: QXStaticCell {
    
    open override func height(_ model: Any?) -> CGFloat? {
        myImageView.fixWidth = context.givenWidth
        return myImageView.intrinsicContentSize.height
    }
        
    public final lazy var myImageView: QXImageView = {
        let e = QXImageView()
        e.padding = QXEdgeInsets(5, 15, 5, 15)
        e.respondUpdateImage = { [weak self] in
            self?.context?.tableView?.setNeedsUpdate()
        }
        return e
    }()

    public required init() {
        super.init()
        contentView.addSubview(myImageView)
        myImageView.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public required init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }
    
}
