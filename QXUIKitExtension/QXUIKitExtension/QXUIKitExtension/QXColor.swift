//
//  QXColor.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/6/22.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

public enum QXColor {
    /// hex:(#FFFFFF, 0.5)
    case hex(_ hex: String, _ alpha: CGFloat)
    /// rgb:(255, 255, 255, 255)
    case rgb(_ r: UInt8, _ g: UInt8, _ b: UInt8, _ a: UInt8)
    /// image:(QXImage)
    case image(_ image: QXImage)
}

extension QXColor {
    
    public var uiColor: UIColor {
        switch self {
        case .hex(let hex, let alpha):
            var t = hex.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines).uppercased()
            t = t.qxSubStringWithoutPrefix("#")
            if (t.count != 6) {
                return UIColor(red: 0, green: 0, blue: 0, alpha: alpha)
            } else {
                var r: CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0
                Scanner(string: t.qxSubString(start: 0, end: 1)).scanHexInt32(&r)
                Scanner(string: t.qxSubString(start: 2, end: 3)).scanHexInt32(&g)
                Scanner(string: t.qxSubString(start: 4, end: 5)).scanHexInt32(&g)
                return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
            }
        case .rgb(let r, let g, let b, let a):
            return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(a)/255.0)
        case .image(let image):
            if let image = image.uiImage {
                return UIColor(patternImage: image)
            } else {
                fatalError("Only local image can be used here currently!")
            }
        }
    }
    
}
