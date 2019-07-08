//
//  UIFont_ext.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/6/22.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

extension UIFont {
    
    public func qxFont(_ color: QXColor) -> QXFont {
        return QXFont(size: qxSize, color: color)
    }
    
    public var qxSize: CGFloat {
        return fontDescriptor.object(forKey: .size) as? CGFloat ?? 0
    }
    
}
