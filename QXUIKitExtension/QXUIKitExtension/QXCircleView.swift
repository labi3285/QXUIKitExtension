//
//  QXCircleView.swift
//  Project
//
//  Created by labi3285 on 2020/1/20.
//  Copyright © 2020 labi3285_lab. All rights reserved.
//

import UIKit

class QXCircleView: QXView {
    
    /// 圆角度（0-1）, nil 表示纯圆
    var radius: CGFloat?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let radius = radius {
            self.layer.cornerRadius = radius
        } else {
            self.layer.cornerRadius = min(bounds.width, bounds.height) / 2
        }
        self.clipsToBounds = true
    }
}
