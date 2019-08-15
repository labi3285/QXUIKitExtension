//
//  QXPoint.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/12.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

public struct QXPoint {
    
    /// x
    public var x: CGFloat
    /// y
    public var y: CGFloat
    
    public static let zero = QXPoint()
    public var isZero: Bool {
        return x == 0 && y == 0
    }

    /// default init
    public init() {
        self.x = 0
        self.y = 0
    }
    
    /// init with x/y
    public init(_ x: CGFloat, _ y: CGFloat) {
        self.x = x
        self.y = y
    }
    
}


extension CGPoint {
    
    /// QXPoint
    public var qxPoint: QXPoint {
        set {
            x = CGFloat(newValue.x)
            y = CGFloat(newValue.y)
        }
        get {
            return QXPoint(CGFloat(x), CGFloat(y))
        }
    }
    
}
