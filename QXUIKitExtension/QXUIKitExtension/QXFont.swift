//
//  QXFont.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/6/22.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXFont {
    
    /// 字体大小
    open var size: CGFloat
    /// 字体颜色
    open var color: QXColor
    /// 是否加粗
    open var bold: Bool
    
    /// 是否倾斜
    open var obliqueness: Bool?
    open func setObliqueness(_ e: Bool?) -> QXFont { obliqueness = e; return self }

    /// 字体
    open var fontName: String?
    open func setFontName(_ e: String?) -> QXFont { fontName = e; return self }

    /// 背景色
    open var backgroundColor: QXColor?
    open func setBackgroundColor(_ e: QXColor?) -> QXFont { backgroundColor = e; return self }

    /// 删除线
    open var strikethrough: Bool?
    open func setStrikethrough(_ e: Bool?) -> QXFont { strikethrough = e; return self }
    /// 删除线颜色
    open var strikethroughColor: QXColor?
    open func setStrikethroughColor(_ e: QXColor?) -> QXFont { strikethroughColor = e; return self }

    /// 下划线颜色
    open var underlineColor: QXColor?
    open func setUnderlineColor(_ e: QXColor?) -> QXFont { underlineColor = e; return self }
    /// 下划线样式
    open var underline: Bool?
    open func setUnderline(_ e: Bool?) -> QXFont { underline = e; return self }

    /// 描边颜色
    open var strokeColor: QXColor?
    open func setStrokeColor(_ e: QXColor?) -> QXFont { strokeColor = e; return self }

    /// 描边宽度
    open var strokeWidth: CGFloat?
    open func setStrokeWidth(_ e: CGFloat?) -> QXFont { strokeWidth = e; return self }

    /// 字符间隔
    open var kern: CGFloat?
    open func setKern(_ e: CGFloat?) -> QXFont { kern = e; return self }

    /// 基线偏移
    open var baselineOffset: CGFloat?
    open func setBaselineOffset(_ e: CGFloat?) -> QXFont { baselineOffset = e; return self }
    
    /// 附件
    open var attachment: NSTextAttachment?
    open func setAttachment(_ e: NSTextAttachment?) -> QXFont { attachment = e; return self }

    /// 链接
    open var link: String?
    open func setLink(_ e: String?) -> QXFont { link = e; return self }
    
    /// 阴影
    open var shadow: NSShadow?
    open func setShadow(_ e: NSShadow?) -> QXFont { shadow = e; return self }
    
    /// 特效
    open var textEffect: String?
    open func setTextEffect(_ e: String?) -> QXFont { textEffect = e; return self }

    /// 扁平化
    open var expansion: String?
    open func setExpansion(_ e: String?) -> QXFont { expansion = e; return self }
    
    /// 是否垂直布局
    open var verticalGlyphForm: Bool?
    open func setVerticalGlyphForm(_ e: Bool?) -> QXFont { verticalGlyphForm = e; return self }

    /// 段落样式
    open var paragraphStyle: NSParagraphStyle?
    open func setParagraphStyle(_ e: NSParagraphStyle?) -> QXFont { paragraphStyle = e; return self }
        
    /// "16 #ffffff BU 5,10"
    public init(fmt: String) {
        let comps = fmt.components(separatedBy: " ")
        if comps.count <= 0 {
            self.size = QXDebugFatalError("format error", 14)
            self.color = QXColor.black
            self.bold = false
        } else if comps.count == 1 {
            self.size = comps[0].qxCGFloatValue
            self.color = QXColor.black
            self.bold = false
        } else {
            var color: QXColor?
            var bold: Bool?
            var underLine: Bool?
            var paragraphStyle: NSParagraphStyle?
            for (i, e) in comps.enumerated() {
                if i > 0 {
                    if e.hasPrefix("#") {
                        color = QXColor.fmtHex(e)
                    } else if e.contains("B") {
                        bold = true
                    } else if e.contains("U") {
                        underLine = true
                    } else if e.contains(",") {
                        let comps = e.components(separatedBy: ",")
                        if comps.count == 2 {
                            let e = NSMutableParagraphStyle()
                            e.lineSpacing = comps[0].qxCGFloatValue
                            e.paragraphSpacing = comps[1].qxCGFloatValue
                            paragraphStyle = e
                        }
                    }
                }
            }
            self.size = comps[0].qxCGFloatValue
            self.color = color ?? QXColor.black
            self.bold = bold ?? false
            self.underline = underLine
            self.paragraphStyle = paragraphStyle
        }
    }
    
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
    
    public init(_ size: CGFloat, _ fmtHex: String, _ bold: Bool) {
        self.size = size
        self.color = QXColor.fmtHex(fmtHex)
        self.bold = bold
    }
    
    /// #ffffff 100%
    public init(_ size: CGFloat, _ colorFmtHex: String) {
        self.size = size
        self.color = QXColor.fmtHex(colorFmtHex)
        self.bold = false
    }
    
    open var uiFont: UIFont? {
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
    
    open func nsAttributtedString(_ str: String) -> NSAttributedString {
        return NSAttributedString(string: str, attributes: nsAttributtes)
    }

    open var nsAttributtes: [NSAttributedString.Key: Any] {
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
    
    open var qxText: String? {
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
    public var qxFont: QXFont? {
        set {
            objc_setAssociatedObject(self, &UILabel.kUILabelQXFontAssociateKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let e = objc_getAssociatedObject(self, &UILabel.kUILabelQXFontAssociateKey) as? QXFont {
                return e
            }
            return nil
        }
    }
    private static var kUILabelQXFontAssociateKey:String = "kUILabelQXFontAssociateKey"

}

extension UITextView {

    open var qxText: String? {
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
            objc_setAssociatedObject(self, &UITextView.kUITextViewQXFontAssociateKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let e = objc_getAssociatedObject(self, &UITextView.kUITextViewQXFontAssociateKey) as? QXFont {
                return e
            }
            return nil
        }
    }
    private static var kUITextViewQXFontAssociateKey: String = "kUITextViewQXFontAssociateKey"
    
}

extension UIButton {
    
    open var qxText: String? {
        set {
            if let e = newValue {
                setAttributedTitle(qxFont?.nsAttributtedString(e), for: .normal)
            } else {
                setAttributedTitle(nil, for: .normal)
            }
        }
        get {
            return title(for: .normal)
        }
    }
    
    public var qxFont: QXFont? {
        set {
            objc_setAssociatedObject(self, &UIButton.kUIButtonQXFontAssociateKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let e = objc_getAssociatedObject(self, &UIButton.kUIButtonQXFontAssociateKey) as? QXFont {
                return e
            }
            return nil
        }
    }
    private static var kUIButtonQXFontAssociateKey: String = "kUIButtonQXFontAssociateKey"
    
}

