//
//  QXFont.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/6/22.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

struct QXFont {
    
    var size: CGFloat
    var color: QXColor
    var fontName: String
    
    init(fontName: String, size: CGFloat, color: QXColor) {
        self.fontName = fontName
        self.size = size
        self.color = color
    }

    var uiFont: UIFont? {
        return UIFont(name: fontName, size: size)
    }
    
}
