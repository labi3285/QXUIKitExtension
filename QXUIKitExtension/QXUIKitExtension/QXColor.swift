//
//  QXColor.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/6/22.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

public enum QXColor {
    
    /// 是否支持夜间模式
    public static var isSupportDarkMode: Bool = true

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
    
    /// hex:(#FFFFFF, 0.5)
    public static func hex(_ hex: String, _ alpha: CGFloat) -> QXColor {
        let rgb = hex2rgb(hex)
        return QXColor.rgb(rgb.r, rgb.g, rgb.b, UInt8(alpha * 255))
    }
    /// #FFFFFF 100% 或者 #FFFFFF 0.3
    public static func fmtHex(_ fmtHex: String) -> QXColor {
        let info = fmtHex2Hex(fmtHex)
        return .hex(info.hex, info.alpha)
    }
    /// #FFFFFF 100% 或者 #FFFFFF 0.3
    public static func darkFmtHex(_ normalFmtHex: String, _ darkFmtHex: String) -> QXColor {
        let a = fmtHex2Hex(normalFmtHex)
        let b = fmtHex2Hex(darkFmtHex)
        let rgba = hex2rgb(a.hex)
        let rgbb = hex2rgb(b.hex)
        if isSupportDarkMode, #available(iOS 13.0, *) {
            return QXColor.uiColor(UIColor(dynamicProvider: { (c) -> UIColor in
                switch c.userInterfaceStyle {
                case .dark:
                    return UIColor(red: CGFloat(rgbb.r)/255, green: CGFloat(rgbb.g)/255, blue: CGFloat(rgbb.b)/255, alpha: a.alpha)
                default:
                    return UIColor(red: CGFloat(rgba.r)/255, green: CGFloat(rgba.g)/255, blue: CGFloat(rgba.b)/255, alpha: b.alpha)
                }
            }))
        } else {
            return QXColor.uiColor(UIColor(red: CGFloat(rgba.r)/255, green: CGFloat(rgba.g)/255, blue: CGFloat(rgba.b)/255, alpha: a.alpha))
        }
    }
    
    public static let red: QXColor = QXColor.rgb(255, 0, 0, 255)
    public static let green: QXColor = QXColor.rgb(0, 255, 0, 255)
    public static let blue: QXColor = QXColor.rgb(0, 0, 255, 255)
    public static let black: QXColor = QXColor.rgb(0, 0, 0, 255)
    public static let white: QXColor = QXColor.rgb(255, 255, 255, 255)
    public static let clear: QXColor = QXColor.rgb(0, 0, 0, 0)
    
    public static let cyan: QXColor = QXColor.rgb(0, 255, 255, 255)
    public static let yellow: QXColor = QXColor.rgb(255, 255, 0, 255)
    public static let magenta: QXColor = QXColor.rgb(255, 0, 255, 255)
    public static let orange: QXColor = QXColor.rgb(255, 127, 0, 255)
    public static let purple: QXColor = QXColor.rgb(127, 0, 127, 255)
    public static let brown: QXColor = QXColor.rgb(165, 102, 51, 255)

    public static let placeHolderGray: QXColor = QXColor.rgb(187, 187, 187, 255)
    public static let backgroundGray: QXColor = QXColor.rgb(245, 245, 245, 255)
    public static let higlightGray: QXColor = QXColor.rgb(245, 245, 245, 255)
    public static let lineGray: QXColor = QXColor.rgb(224, 224, 224, 255)
    public static let borderGray: QXColor = QXColor.rgb(166, 166, 166, 255)
    
    public static var dynamicBar: QXColor = QXColor.darkFmtHex("#ffffff", "#121212")
    public static let dynamicBody: QXColor = QXColor.darkFmtHex("#ffffff", "#1c1c1e")
    public static let dynamicBackgroundGray: QXColor = QXColor.darkFmtHex("#f5f5f5", "#000000")
    public static let dynamicBackgroundKeyboard: QXColor = QXColor.darkFmtHex("#d1d3d9", "#1b1b1b")
    
    public static let dynamicWhite: QXColor = QXColor.darkFmtHex("#ffffff", "#000000")
    public static let dynamicBlack: QXColor = QXColor.darkFmtHex("#000000", "#ffffff")
    public static let dynamicLine: QXColor = QXColor.darkFmtHex("#e0e0e0", "#3d3d41")
    public static let dynamicAdorn: QXColor = QXColor.darkFmtHex("#3478f6", "#3b82f6")

    public static let dynamicTitle: QXColor = QXColor.darkFmtHex("#333333", "#fefefe")
    public static let dynamicSubTitle: QXColor = QXColor.darkFmtHex("#666666", "#98989e")
    public static let dynamicTip: QXColor = QXColor.darkFmtHex("#999999", "#8e8e92")
    public static let dynamicLink: QXColor = QXColor.darkFmtHex("#66b3ff", "#66b3ff")
    public static let dynamicText: QXColor = QXColor.darkFmtHex("#666666", "#98989e")
    public static let dynamicInput: QXColor = QXColor.darkFmtHex("#333333", "#fefefe")
    public static let dynamicIndicator: QXColor = QXColor.darkFmtHex("#666666", "#5a5a5e")
    public static let dynamicPlaceHolder: QXColor = QXColor.darkFmtHex("#bbbbbb", "#656569")

    public static let dynamicHiglight: QXColor = QXColor.darkFmtHex("#f5f5f5", "#363636")
    
    public static func random(alpha: CGFloat) -> QXColor { return QXColor.uiColor(UIColor.qxRandom(alpha: alpha)) }
    public static var random: QXColor { return QXColor.uiColor(UIColor.qxRandom) }

}

extension QXColor {
    
    public var uiImage: UIImage {
        return UIImage.qxCreate(color: uiColor)
    }
    
    public var uiColor: UIColor {
        switch self {
        case .rgb(let r, let g, let b, let a):
            return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(a)/255.0)
        case .image(let image):
            if let image = image.uiImage {
                return UIColor(patternImage: image)
            } else {
                return QXDebugFatalError("Only local image can be used here currently!", UIColor.white)
            }
        case .uiColor(let c):
            return c
        case .cgColor(let c):
            return UIColor(cgColor: c)
        case .ciColor(let c):
            return UIColor(ciColor: c)
        }
    }
    
    private static func hexWithFmtHex(_ fmtHex: String) -> (hex: String, alpha: CGFloat) {
        let components = fmtHex.components(separatedBy: " ")
        if components.count == 1 {
            return (fmtHex, 1)
        } else if components.count == 2 {
            let hex = components[0]
            if components[1].contains("%") {
                let alpha = components[1].replacingOccurrences(of: "%", with: "").qxCGFloatValue / 100
                return (hex, alpha)
            } else {
                let alpha = min(components[1].qxCGFloatValue, 1)
                return (hex, alpha)
            }
        }
        return ("#000000", 0)
    }
    
    private static func hex2rgb(_ hex: String) -> (r: UInt8, g: UInt8, b: UInt8) {
        var t = hex.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines).uppercased()
        t = t.qxSubStringWithoutPrefix("#")
        if (t.count != 6) {
            return (0, 0, 0)
        } else {
            var r: CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0
            Scanner(string: t.qxSubString(start: 0, end: 1)).scanHexInt32(&r)
            Scanner(string: t.qxSubString(start: 2, end: 3)).scanHexInt32(&g)
            Scanner(string: t.qxSubString(start: 4, end: 5)).scanHexInt32(&b)
            return (UInt8(r), UInt8(g), UInt8(b))
        }
    }
    private static func fmtHex2Hex(_ fmtHex: String) -> (hex: String, alpha: CGFloat) {
        let components = fmtHex.components(separatedBy: " ")
        if components.count == 1 {
            return (fmtHex, 1)
        } else if components.count == 2 {
            let hex = components[0]
            if components[1].contains("%") {
                let alpha = components[1].replacingOccurrences(of: "%", with: "").qxCGFloatValue / 100
                return (hex, alpha)
            } else {
                let alpha = min(components[1].qxCGFloatValue, 1)
                return (hex, alpha)
            }
        }
        return ("#000000", 0)
    }
        
}

extension QXColor: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .rgb(let r, let g, let b, let a):
            return "\(type(of: self)).rgb \(r) \(g) \(b) \(a)"
        case .image(let image):
            if let e = image.uiImage {
                return "\(type(of: self)).image \(e)"
            } else {
                return "\(type(of: self)).image nil"
            }
        case .uiColor(let c):
            return "\(type(of: self)).uiColor \(c)"
        case .cgColor(let c):
            return "\(type(of: self)).cgColor \(c)"
        case .ciColor(let c):
            return "\(type(of: self)).ciColor \(c)"
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

