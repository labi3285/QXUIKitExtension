//
//  UIFont_ext.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/6/22.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

extension UIFont {
    
    public var qxSize: CGFloat {
        return fontDescriptor.object(forKey: .size) as? CGFloat ?? 0
    }
    
}
