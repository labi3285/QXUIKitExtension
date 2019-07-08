//
//  QXFont.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/6/22.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

public struct QXFont {
    
    /// 字体大小
    public var size: CGFloat
    /// 字体颜色
    public var color: QXColor
    /// 是否加粗
    public var bold: Bool
    
    /// 是否倾斜
    public var obliqueness: Bool?
    
    /// 字体
    public var fontName: String?
    /// 背景色
    public var backgroundColor: QXColor?
    
    /// 删除线
    public var strikethrough: Bool?
    /// 删除线颜色
    public var strikethroughColor: QXColor?

    /// 下划线颜色
    public var underlineColor: QXColor?
    /// 下划线样式
    public var underline: Bool?

    /// 描边颜色
    public var strokeColor: QXColor?
    /// 描边宽度
    public var strokeWidth: CGFloat?
    /// 字符间隔
    public var kern: CGFloat?
    /// 基线偏移
    public var baselineOffset: CGFloat?
    
    /// 附件
    public var attachment: NSTextAttachment?
    /// 链接
    public var link: String?
    
    /// 阴影
    public var shadow: NSShadow?
    /// 特效
    public var textEffect: String?
    /// 扁平化
    public var expansion: String?
    
    /// 是否垂直布局
    public var verticalGlyphForm: Bool?

    /// 段落样式
    public var paragraphStyle: NSParagraphStyle?
    
    public init(size: CGFloat, fontName: String, color: QXColor) {
        self.fontName = fontName
        self.size = size
        self.color = color
        self.bold = false
    }
    
    public init(size: CGFloat, color: QXColor) {
        self.size = size
        self.color = color
        self.bold = false
    }
    
    public init(_ size: CGFloat, _ bold: Bool, _ formatHex: String) {
        self.size = size
        self.color = QXColor.formatHex(formatHex)
        self.bold = bold
    }
    
    /// #ffffff 100%
    public init(_ size: CGFloat, _ colorFormatHex: String) {
        self.size = size
        self.color = QXColor.formatHex(colorFormatHex)
        self.bold = false
    }
    
    public var uiFont: UIFont? {
        if let fontName = fontName {
            return UIFont(name: fontName, size: size)
        } else {
            if bold {
                return UIFont.boldSystemFont(ofSize: size)
            } else {
                return UIFont.systemFont(ofSize: size)
            }
        }
    }
    
    public func nsAttributtedString(_ str: String) -> NSAttributedString {
        return NSAttributedString(string: str, attributes: nsAttributtes)
    }

    public var nsAttributtes: [NSAttributedString.Key: Any] {
        var dic: [NSAttributedString.Key: Any] = [:]
        func checkOrAppend(_ key: NSAttributedString.Key, _ value: Any?) {
            if let value = value {
                dic[key] = value
            }
        }
        func bool2Int(_ b: Bool?) -> Int? {
            if let b = b {
                return b ? 1 : 0
            }
            return nil
        }
        checkOrAppend(NSAttributedString.Key.font, uiFont)
        checkOrAppend(NSAttributedString.Key.foregroundColor, color.uiColor)
        checkOrAppend(NSAttributedString.Key.backgroundColor, backgroundColor?.uiColor)
        checkOrAppend(NSAttributedString.Key.obliqueness, bool2Int(obliqueness))
        checkOrAppend(NSAttributedString.Key.strikethroughStyle, bool2Int(strikethrough))
        checkOrAppend(NSAttributedString.Key.strikethroughColor, strikethroughColor?.uiColor)
        checkOrAppend(NSAttributedString.Key.underlineStyle, bool2Int(underline))
        checkOrAppend(NSAttributedString.Key.underlineColor, underlineColor?.uiColor)
        checkOrAppend(NSAttributedString.Key.strokeColor, strokeColor?.uiColor)
        checkOrAppend(NSAttributedString.Key.strokeWidth, strokeWidth)
        checkOrAppend(NSAttributedString.Key.kern, kern)
        checkOrAppend(NSAttributedString.Key.baselineOffset, baselineOffset)
        checkOrAppend(NSAttributedString.Key.attachment, attachment)
        checkOrAppend(NSAttributedString.Key.link, link)
        checkOrAppend(NSAttributedString.Key.shadow, shadow)
        checkOrAppend(NSAttributedString.Key.textEffect, textEffect)
        checkOrAppend(NSAttributedString.Key.expansion, expansion)
        checkOrAppend(NSAttributedString.Key.verticalGlyphForm, bool2Int(verticalGlyphForm))
        checkOrAppend(NSAttributedString.Key.paragraphStyle, paragraphStyle)
        return dic
    }
    
}

extension UILabel {
    
    public var qxText: String? {
        set {
            if let text = newValue {
                attributedText = qxFont?.nsAttributtedString(text)
            } else {
                attributedText = nil
            }
        }
        get {
            return text
        }
    }
    var qxFont: QXFont? {
        set {
            objc_setAssociatedObject(self, &UILabel.kQXFontUILabelAssociateKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let qxFont = objc_getAssociatedObject(self, &UILabel.kQXFontUILabelAssociateKey) as? QXFont {
                return qxFont
            }
            return nil
        }
    }
    private static var kQXFontUILabelAssociateKey:UInt = 3285000001

}

extension UITextView {

    public var qxText: String? {
        get {
            return text
        }
        set {
            if let text = newValue {
                attributedText = qxFont?.nsAttributtedString(text)
            } else {
                attributedText = nil
            }
        }
    }
    
    public var qxFont: QXFont? {
        set {
            objc_setAssociatedObject(self, &UITextView.kQXFontUITextViewAssociateKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let qxFont = objc_getAssociatedObject(self, &UITextView.kQXFontUITextViewAssociateKey) as? QXFont {
                return qxFont
            }
            return nil
        }
    }
    private static var kQXFontUITextViewAssociateKey:UInt = 3285000002
    
}
