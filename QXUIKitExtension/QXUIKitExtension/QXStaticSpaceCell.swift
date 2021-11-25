//
//  QXStaticSpaceCell.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/28.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import QXConsMaker

open class QXStaticSpaceCell: QXStaticCell {
    
    convenience public init(height: CGFloat) {
        self.init()
        self.fixHeight = height
    }
    
    public required init() {
        super.init()
        fixHeight = 10
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public required init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }
    
}
