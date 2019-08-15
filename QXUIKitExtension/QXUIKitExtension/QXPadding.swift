//
//  QXEdgeInsets.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/19.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

public struct QXPadding {
    
    public var top: CGFloat
    public var left: CGFloat
    public var bottom: CGFloat
    public var right: CGFloat

    public static let zero = QXPadding()
    
    public init() {
        self.top = 0
        self.right = 0
        self.bottom = 0
        self.left = 0
    }
    
    public init(_ top: CGFloat, _ right: CGFloat, _ bottom: CGFloat, _ left: CGFloat) {
        self.top = top
        self.left = left
        self.bottom = bottom
        self.right = right
    }
    public init(_ top: Double, _ right: Double, _ bottom: Double, _ left: Double) {
        self.top = CGFloat(top)
        self.left = CGFloat(left)
        self.bottom = CGFloat(bottom)
        self.right = CGFloat(right)
    }
    public init(_ top: Int, _ right: Int, _ bottom: Int, _ left: Int) {
        self.top = CGFloat(top)
        self.left = CGFloat(left)
        self.bottom = CGFloat(bottom)
        self.right = CGFloat(right)
    }
    
    public var uiEdgeInsets: UIEdgeInsets {
        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    public var isZero: Bool {
        return top == 0 && right == 0 && bottom == 0 && left == 0
    }
    
}

extension UIEdgeInsets {
    
    public var qxPadding: QXPadding {
        return QXPadding(top, left, bottom, right)
    }

}
