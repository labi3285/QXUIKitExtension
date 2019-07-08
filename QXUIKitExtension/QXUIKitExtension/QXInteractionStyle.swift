//
//  QXInteractionStyle.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/6.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

public struct QXControlStateStyle {
    public var icon: QXImage?
    public var title: String?
    public var font: QXFont?
    public var backgroundColor: QXColor?
    public var backgroundImage: QXImage?

    init(icon: QXImage?, title: String?, font: QXFont, backgroundColor: QXColor?) {
        self.icon = icon
        self.title = title
        self.font = font
        self.backgroundColor = backgroundColor
    }
    init(icon: QXImage?, title: String?, font: QXFont, backgroundImage: QXImage?) {
        self.icon = icon
        self.title = title
        self.font = font
        self.backgroundImage = backgroundImage
    }
    init(font: QXFont, backgroundImage: QXImage?) {
        self.font = font
        self.backgroundImage = backgroundImage
    }
    init(font: QXFont) {
        self.font = font
    }
    
    public init(_ size: CGFloat, _ bold: Bool, _ formatHex: String) {
        self.font = QXFont(size, bold, formatHex)
    }
    
}

public struct QXControlStateStyles {
    
    public var normal: QXControlStateStyle
    
    public var highlighted: QXControlStateStyle?
    public var selected: QXControlStateStyle?
    public var disabled: QXControlStateStyle?

    public init(_ size: CGFloat, _ bold: Bool, _ formatHex: String) {
        self.normal = QXControlStateStyle(size, bold, formatHex)
    }
    
    public init(_ normal: QXControlStateStyle) {
        self.normal = normal
    }
//    public init(icon: QXImage?, title: String?, font: QXFont?, backgroundColor: QXImage?) {
//        self.normal = QXControlStateStyle(icon: icon, title: title, font: font, backgroundColor: backgroundColor)
//    }
    
}
