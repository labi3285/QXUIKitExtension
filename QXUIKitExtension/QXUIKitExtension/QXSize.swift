//
//  QXSize.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/12.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

public struct QXSize {
    
    public var width: CGFloat
    public var height: CGFloat
    
    public static let zero = QXSize()
    
    public init() {
        self.width = 0
        self.height = 0
    }
    
    init(_ width: CGFloat, _ height: CGFloat) {
        self.width = width
        self.height = height
    }
    
}

extension CGSize {
    
    /// QXSize
    public var qxSize: QXSize {
        set {
            width = CGFloat(newValue.width)
            height = CGFloat(newValue.height)
        }
        get {
            return QXSize(width, height)
        }
    }
    
}

extension UIImage {
    
    public var qxSize: QXSize {
        return size.qxSize
    }
    
}
