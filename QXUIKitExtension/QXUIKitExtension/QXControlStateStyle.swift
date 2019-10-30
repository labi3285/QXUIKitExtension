//
//  QXInteractionStyle.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/6.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXControlStateStyle {
    
    public var icon: QXImage?
    @discardableResult
    public func setIcon(_ e: QXImage?) -> QXControlStateStyle { icon = e; return self }

    public var title: String?
    @discardableResult
    public func setTitle(_ e: String?) -> QXControlStateStyle { title = e; return self }

    public var font: QXFont?
    @discardableResult
    public func setFont(_ e: QXFont?) -> QXControlStateStyle { font = e; return self }
    @discardableResult
    public func setFmtFont(_ e: String) -> QXControlStateStyle { font = QXFont(fmt: e); return self }

    public var backgroundColor: QXColor?
    @discardableResult
    public func setBackgroundColor(_ e: QXColor?) -> QXControlStateStyle { backgroundColor = e; return self }

    public var backgroundImage: QXImage?
    @discardableResult
    public func setBackgroundImage(_ e: QXImage?) -> QXControlStateStyle { backgroundImage = e; return self }

    public var shadow: QXShadow?
    @discardableResult
    public func setShadow(_ e: QXShadow?) -> QXControlStateStyle { shadow = e; return self }

    public var border: QXBorder?
    @discardableResult
    public func setBorder(_ e: QXBorder?) -> QXControlStateStyle { border = e; return self }

    public init() {
    }
    
    public init(fmtFont: String) {
        self.font = QXFont(fmt: fmtFont)
    }
    
    public init(font: QXFont) {
        self.font = font
    }
    
}

open class QXControlStateStyles {
    
    public var normal: QXControlStateStyle

    public var highlighted: QXControlStateStyle?
    public func setHighlighted(_ e: QXControlStateStyle?) -> QXControlStateStyles { highlighted = e; return self }

    public var selected: QXControlStateStyle?
    @discardableResult
    public func setSelected(_ e: QXControlStateStyle?) -> QXControlStateStyles { selected = e; return self }

    public var disabled: QXControlStateStyle?
    @discardableResult
    public func setDisabled(_ e: QXControlStateStyle?) -> QXControlStateStyles { disabled = e; return self }

    public init(_ normal: QXControlStateStyle) {
        self.normal = normal
    }
    
    public init(fmtFont: String) {
        self.normal = QXControlStateStyle(fmtFont: fmtFont)
    }
    
    public init(font: QXFont) {
        self.normal = QXControlStateStyle(font: font)
    }
    
}

