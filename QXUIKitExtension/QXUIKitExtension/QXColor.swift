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
    
    /// hsb:(360, 100, 100, 100)
    case hsb(_ h: UInt16, _ s: UInt16, _ b: UInt16, _ a: UInt16)

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
    
    public var rgb: (r: UInt8, g: UInt8, b: UInt8, a: UInt8) {
        return uiColor.qxRGB
    }
    public var hsb: (h: UInt16, s: UInt16, b: UInt16, a: UInt16) {
        return uiColor.qxHSB
    }
    public var hex: String {
        return uiColor.qxHEX
    }
    
    /// 颜色反转
    public var opposite: QXColor {
        return QXColor.uiColor(uiColor.qxOpposite)
    }
    
    /// 色环偏移
    public func hsb(_ offsetDegree: Int16) -> QXColor {
        return QXColor.uiColor(uiColor.qxHSB(offsetDegree))
    }
    
    /// 对应黑白色
    public var blackOrWhite: QXColor {
        return QXColor.uiColor(uiColor.qxBlackOrWhite)
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

    /// 导航颜色
    public static var dynamicBar: QXColor = QXColor.darkFmtHex("#ffffff", "#121212")
    /// 设置项颜色
    public static var dynamicBody: QXColor = QXColor.darkFmtHex("#ffffff", "#1c1c1e")
    /// 浅灰背景色
    public static var dynamicBackgroundGray: QXColor = QXColor.darkFmtHex("#f5f5f5", "#000000")
    /// 键盘背景色
    public static var dynamicBackgroundKeyboard: QXColor = QXColor.darkFmtHex("#d1d3d9", "#1b1b1b")
      
    /// 背景白色
    public static var dynamicWhite: QXColor = QXColor.darkFmtHex("#ffffff", "#000000")
    /// 背景黑色
    public static var dynamicBlack: QXColor = QXColor.darkFmtHex("#000000", "#ffffff")
    /// 分隔线颜色
    public static var dynamicLine: QXColor = QXColor.darkFmtHex("#e0e0e0", "#3d3d41")
    /// 强调颜色（光标、返回、导航item等）
    public static var dynamicAccent: QXColor = QXColor.darkFmtHex("#3478f6", "#3b82f6")
    
    /// 按钮颜色
    public static var dynamicButton: QXColor = QXColor.darkFmtHex("#3478f6", "#3b82f6")
    /// 按钮文本颜色
    public static var dynamicButtonText: QXColor = QXColor.darkFmtHex("#ffffff", "#ffffff")

    /// 标题色（导航、标题、设置项）
    public static var dynamicTitle: QXColor = QXColor.darkFmtHex("#333333", "#fefefe")
    /// 副标题颜色（设置项内容）
    public static var dynamicSubTitle: QXColor = QXColor.darkFmtHex("#666666", "#98989e")
    /// 提示颜色（header、footer）
    public static var dynamicTip: QXColor = QXColor.darkFmtHex("#999999", "#8e8e92")
    /// 超链接颜色
    public static var dynamicLink: QXColor = QXColor.darkFmtHex("#66b3ff", "#66b3ff")
    /// 文本默认颜色
    public static var dynamicText: QXColor = QXColor.darkFmtHex("#666666", "#98989e")
    /// 输入框文本颜色
    public static var dynamicInput: QXColor = QXColor.darkFmtHex("#333333", "#fefefe")
    /// 占位符颜色
    public static var dynamicPlaceHolder: QXColor = QXColor.darkFmtHex("#bbbbbb", "#656569")

    /// 指示箭头颜色
    public static var dynamicIndicator: QXColor = QXColor.darkFmtHex("#666666", "#5a5a5e")
    /// 按钮高亮颜色
    public static var dynamicHiglight: QXColor = QXColor.darkFmtHex("#f5f5f5", "#363636")
    
    public static var dynamicIconGray: QXColor = QXColor.darkFmtHex("#999999", "#8e8e92")
    
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
        case .hsb(let h, let s, let b, let a):
            return UIColor(hue: CGFloat(h)/360.0, saturation: CGFloat(s)/100.0, brightness: CGFloat(b)/100.0, alpha: CGFloat(a)/100.0)
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
        t = t.qxStringByCheckOrRemovePrefix("#")
        if (t.count != 6) {
            return (0, 0, 0)
        } else {
            var r: CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0
            Scanner(string: t.qxString(start: 0, end: 1)).scanHexInt32(&r)
            Scanner(string: t.qxString(start: 2, end: 3)).scanHexInt32(&g)
            Scanner(string: t.qxString(start: 4, end: 5)).scanHexInt32(&b)
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
        case .hsb(let h, let s, let b, let a):
            return "\(type(of: self)).hsb \(h) \(s) \(b) \(a)"
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
    
    public var qxRGB: (r: UInt8, g: UInt8, b: UInt8, a: UInt8) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (UInt8(r * 255), UInt8(g * 255), UInt8(b * 255), UInt8(a * 255))
    }
    
    public var qxHSB: (h: UInt16, s: UInt16, b: UInt16, a: UInt16) {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (UInt16(h * 360), UInt16(s * 100), UInt16(b * 100), UInt16(a * 100))
    }
    
    public var qxHEX: String {
        let rgba = qxRGB
        var t = "#"
        var r = String(rgba.r, radix: 16)
        if r.count == 1 {
            r = "0" + r
        }
        t += r
        var g = String(rgba.g, radix: 16)
        if g.count == 1 {
            g = "0" + g
        }
        t += g
        var b = String(rgba.b, radix: 16)
        if b.count == 1 {
            b = "0" + b
        }
        t += b
        if rgba.a < 1 {
            t += " \(CGFloat(rgba.a) / 255)"
        }
        return t
    }
    
    /// 颜色反转
    public var qxOpposite: UIColor {
        let rgba = qxRGB
        return UIColor(red: CGFloat(255 - rgba.r) / 255,
                       green: CGFloat(255 - rgba.g) / 255,
                       blue: CGFloat(255 - rgba.b) / 255,
                       alpha: CGFloat(255 - rgba.a) / 255)
    }
    
    /// 颜色转轮(offset为转角度数)
    public func qxHSB(_ offsetDegree: Int16) -> UIColor {
        let hsba = qxHSB
        return UIColor(hue: CGFloat(abs(Int16(hsba.a) + offsetDegree) % 360) / 360,
                       saturation: CGFloat(hsba.s) / 100,
                       brightness: CGFloat(hsba.b) / 100,
                       alpha: CGFloat(hsba.a) / 100)
    }
    
    /// 对应黑白色
    public var qxBlackOrWhite: UIColor {
        let rgba = qxRGB
        let a = CGFloat(rgba.r) * 0.299 + CGFloat(rgba.g) * 0.587 + CGFloat(rgba.b) * 0.114
        if a < 200/255 {
            return UIColor(red: 0, green: 0, blue: 0, alpha: CGFloat(255 - rgba.a) / 255)
        } else {
            return UIColor(red: 1, green: 1, blue: 1, alpha: CGFloat(255 - rgba.a) / 255)
        }
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


