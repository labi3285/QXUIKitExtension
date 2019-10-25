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
    /// uiColor:(UIColor)
    case uiColor(_ uiColor: UIColor)
    /// cgColor:(CGColor)
    case cgColor(_ cgColor: CGColor)
    /// ciColor:(CIColor)
    case ciColor(_ ciColor: CIColor)

    /// #FFFFFF 100%
    public static func fmtHex(_ fmtHex: String) -> QXColor {
        let components = fmtHex.components(separatedBy: " ")
        if components.count == 1 {
            return .hex(fmtHex, 1)
        } else if components.count == 2 {
            let hex = components[0]
            let alpha = components[1].replacingOccurrences(of: "%", with: "").qxCGFloatValue / 100
            return .hex(hex, alpha)
        }
        return QXColor.null
    }
    
    public static var null: QXColor { return QXColor.rgb(0, 0, 0, 0) }
    public static var red: QXColor { return QXColor.rgb(255, 0, 0, 255) }
    public static var green: QXColor { return QXColor.rgb(0, 255, 0, 255) }
    public static var blue: QXColor { return QXColor.rgb(0, 0, 255, 255) }
    public static var black: QXColor { return QXColor.rgb(0, 0, 0, 255) }
    public static var white: QXColor { return QXColor.rgb(255, 255, 255, 255) }
    public static var clear: QXColor { return QXColor.rgb(0, 0, 0, 0) }
    
    public static var cyan: QXColor { return QXColor.rgb(0, 255, 255, 255) }
    public static var yellow: QXColor { return QXColor.rgb(255, 255, 0, 255) }
    public static var magenta: QXColor { return QXColor.rgb(255, 0, 255, 255) }
    public static var orange: QXColor { return QXColor.rgb(255, 127, 0, 255) }
    public static var purple: QXColor { return QXColor.rgb(127, 0, 127, 255) }
    public static var brown: QXColor { return QXColor.rgb(165, 102, 51, 255) }

    public static var placeHolderGray: QXColor { return QXColor.rgb(187, 187, 187, 255) }
    public static var backgroundGray: QXColor { return QXColor.rgb(245, 245, 245, 255) }
    public static var higlightGray: QXColor { return QXColor.rgb(245, 245, 245, 255) }
    public static var lineGray: QXColor { return QXColor.rgb(224, 224, 224, 255) }
    public static var borderGray: QXColor { return QXColor.rgb(166, 166, 166, 255) }
    
    public static func random(alpha: CGFloat) -> QXColor { return QXColor.uiColor(UIColor.qxRandom(alpha: alpha)) }
    public static var random: QXColor { return QXColor.uiColor(UIColor.qxRandom) }

}

extension QXColor {
    
    public var uiImage: UIImage {
        return UIImage.qxCreate(color: uiColor)
    }
    
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
                Scanner(string: t.qxSubString(start: 4, end: 5)).scanHexInt32(&b)
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
        case .uiColor(let c):
            return c
        case .cgColor(let c):
            return UIColor(cgColor: c)
        case .ciColor(let c):
            return UIColor(ciColor: c)
        }
    }
    
}

extension UIColor {
    
    static func qxRandom(alpha: CGFloat) -> UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(255)) / 255.0,
                       green: CGFloat(arc4random_uniform(255)) / 255.0,
                       blue: CGFloat(arc4random_uniform(255)) / 255.0,
                       alpha: alpha)
    }
    
    static var qxRandom: UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(255)) / 255.0,
                       green: CGFloat(arc4random_uniform(255)) / 255.0,
                       blue: CGFloat(arc4random_uniform(255)) / 255.0,
                       alpha: CGFloat(arc4random_uniform(255)) / 255.0)
    }
}


extension UIView {
    
    public var qxBackgroundColor: QXColor? {
        set {
            backgroundColor = newValue?.uiColor
        }
        get {
            if let e = backgroundColor {
                return QXColor.uiColor(e)
            }
            return nil
        }
    }
    
    public var qxTintColor: QXColor? {
        set {
            tintColor = newValue?.uiColor
        }
        get {
            if let e = tintColor {
                return QXColor.uiColor(e)
            }
            return nil
        }
    }
    
    
}
