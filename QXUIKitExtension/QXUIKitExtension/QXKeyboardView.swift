//
//  QXKeyboardView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/12/13.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXKeyboardView: QXView {
    
    public let view: QXView
    public init(_ view: QXView) {
        self.view = view
        super.init()
        addSubview(view)
        view.extendWidth = true
        view.extendHeight = true
        if QXDevice.isLiuHaiScreen {
            self.padding = QXEdgeInsets(10, 20, 35, 20)
            self.frame = CGRect(x: 0, y: 0, width: 0, height: 245)
        } else {
            self.padding = QXEdgeInsets(10, 20, 10, 20)
            self.frame = CGRect(x: 0, y: 0, width: 0, height: 220)
        }
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        view.qxRect = qxBounds.rectByReduce(padding)
    }
    
}

