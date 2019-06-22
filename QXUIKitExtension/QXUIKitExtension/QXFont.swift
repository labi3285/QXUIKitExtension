//
//  QXFont.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/6/22.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

public struct QXFont {
    
    public var size: CGFloat
    public var color: QXColor
    public var fontName: String?
    
    public init(size: CGFloat, color: QXColor, fontName: String? = nil) {
        self.fontName = fontName
        self.size = size
        self.color = color
    }
    public var uiFont: UIFont? {
        if let fontName = fontName {
            return UIFont(name: fontName, size: size)
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    
}


extension UILabel {
    
    public var qxFont: QXFont? {
        set {
            if let e = newValue?.uiFont {
                self.font = e
            }
            if let e = newValue?.color.uiColor {
                self.textColor = e
            }
        }
        get {
            let c = QXColor.uiColor(textColor)
            let s = font.fontDescriptor.object(forKey: .size) as? CGFloat ?? 0
            return QXFont(size: s, color: c)
        }
    }
    
}

extension UITextView {
    
    public var qxFont: QXFont? {
        set {
            if let e = newValue?.uiFont {
                self.font = e
            }
            if let e = newValue?.color.uiColor {
                self.textColor = e
            }
        }
        get {
            let c = QXColor.uiColor(textColor ?? UIColor.black)
            let s = font?.qxSize ?? 0
            return QXFont(size: s, color: c)
        }
    }
    
}
