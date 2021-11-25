//
//  QXSize.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/12.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

public struct QXSize {
    
    public var w: CGFloat
    public var h: CGFloat
    
    public static let zero = QXSize()
    public var isZero: Bool {
        return w == 0 || h == 0
    }
        
    public init() {
        self.w = 0
        self.h = 0
    }
    
    public init(_ w: CGFloat, _ h: CGFloat) {
        self.w = w
        self.h = h
    }
    public init(_ w: Double, _ h: Double) {
        self.w = CGFloat(w)
        self.h = CGFloat(h)
    }
    public init(_ w: Int, _ h: Int) {
        self.w = CGFloat(w)
        self.h = CGFloat(h)
    }
    
    public mutating func apply(_ scale: CGFloat) {
        w = w * scale
        h = h * scale
    }
    
}

extension CGSize {
    
    /// QXSize
    public var qxSize: QXSize {
        set {
            width = CGFloat(newValue.w)
            height = CGFloat(newValue.h)
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
