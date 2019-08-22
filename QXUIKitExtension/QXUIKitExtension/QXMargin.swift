//
//  QXMargin.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/20.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

public struct QXMargin {
    
    public var top: CGFloat
    public var left: CGFloat
    public var bottom: CGFloat
    public var right: CGFloat
    
    public static let zero = QXMargin()
    
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
        self.right = CGFloat(right)
        self.bottom = CGFloat(bottom)
        self.left = CGFloat(left)
    }
    public init(_ top: Int, _ right: Int, _ bottom: Int, _ left: Int) {
        self.top = CGFloat(top)
        self.right = CGFloat(right)
        self.bottom = CGFloat(bottom)
        self.left = CGFloat(left)
    }
    
    public var uiEdgeInsets: UIEdgeInsets {
        return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
    }
    
    public var isZero: Bool {
        return top == 0 && right == 0 && bottom == 0 && left == 0
    }
    
}

extension UIEdgeInsets {
    
    public var qxMargin: QXMargin {
        return QXMargin(top, left, bottom, right)
    }
    
}

extension QXRect {
    
    public func rectByReduce(_ margin: QXMargin) -> QXRect {
        return QXRect(x + margin.left,
                      y + margin.top,
                      w - margin.left - margin.right,
                      h - margin.top - margin.bottom)
    }
    
    public func rectByAdd(_ margin: QXMargin) -> QXRect {
        return QXRect(x - margin.left,
                      y - margin.top,
                      w + margin.left + margin.right,
                      h + margin.top + margin.bottom)
    }
    
}

extension QXSize {
    
    public func sizeByReduce(_ margin: QXMargin) -> QXSize {
        return QXSize(w - margin.left - margin.right, h - margin.top - margin.bottom)
    }
    public func sizeByAdd(_ margin: QXMargin) -> QXSize {
        return QXSize(w + margin.left + margin.right, h + margin.top + margin.bottom)
    }
}

extension CGRect {
    
    public func qxFrameByReduce(_ inserts: UIEdgeInsets) -> CGRect {
        return CGRect(x: minX + inserts.left,
                      y: minY + inserts.top,
                      width: width - inserts.left - inserts.right,
                      height: height - inserts.top - inserts.bottom)
    }
    
    public func qxFrameByAdd(_ inserts: UIEdgeInsets) -> CGRect {
        return CGRect(x: minX - inserts.left,
                      y: minY - inserts.top,
                      width: width + inserts.left + inserts.right,
                      height: height + inserts.top + inserts.bottom)
    }
    
}

extension CGSize {
    
    public func qxSizeByReduce(_ inserts: UIEdgeInsets) -> CGSize {
        return CGSize(width: width - inserts.left - inserts.right, height: height - inserts.top - inserts.bottom)
    }
    public func qxSizeByAdd(_ inserts: UIEdgeInsets) -> CGSize {
        return CGSize(width: width - inserts.left - inserts.right, height: height - inserts.top - inserts.bottom)
    }
    
}
