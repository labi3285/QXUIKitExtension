//
//  QXStaticSpaceHeaderFooterView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/11/6.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXStaticSpaceHeaderView: QXStaticBaseHeaderFooterView {
    
    convenience public init(height: CGFloat) {
        self.init()
        self.fixHeight = height
    }
    
    required public init() {
        super.init()
        fixHeight = 10
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    required public init(_ reuseId: String) {
        fatalError("init(_:) has not been implemented")
    }
    
}

