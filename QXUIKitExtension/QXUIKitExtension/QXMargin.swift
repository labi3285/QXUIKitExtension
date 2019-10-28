//
//  QXEdgeInsets.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/20.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

public struct QXEdgeInsets {
    
    public var top: CGFloat
    public var left: CGFloat
    public var bottom: CGFloat
    public var right: CGFloat
    
    public static let zero = QXEdgeInsets()
    
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
    
    public var qxEdgeInsets: QXEdgeInsets {
        return QXEdgeInsets(top, left, bottom, right)
    }
    
}

extension QXRect {
    
    public func rectByReduce(_ edgeInsets: QXEdgeInsets) -> QXRect {
        return QXRect(x + edgeInsets.left,
                      y + edgeInsets.top,
                      w - edgeInsets.left - edgeInsets.right,
                      h - edgeInsets.top - edgeInsets.bottom)
    }
    
    public func rectByAdd(_ edgeInsets: QXEdgeInsets) -> QXRect {
        return QXRect(x - edgeInsets.left,
                      y - edgeInsets.top,
                      w + edgeInsets.left + edgeInsets.right,
                      h + edgeInsets.top + edgeInsets.bottom)
    }
    
}

extension QXSize {
    
    public func sizeByReduce(_ edgeInsets: QXEdgeInsets) -> QXSize {
        return QXSize(w - edgeInsets.left - edgeInsets.right, h - edgeInsets.top - edgeInsets.bottom)
    }
    public func sizeByAdd(_ edgeInsets: QXEdgeInsets) -> QXSize {
        return QXSize(w + edgeInsets.left + edgeInsets.right, h + edgeInsets.top + edgeInsets.bottom)
    }
}

extension CGRect {
    
    public func qxFrameByReduce(_ edgeInsets: UIEdgeInsets) -> CGRect {
        return CGRect(x: minX + edgeInsets.left,
                      y: minY + edgeInsets.top,
                      width: width - edgeInsets.left - edgeInsets.right,
                      height: height - edgeInsets.top - edgeInsets.bottom)
    }
    
    public func qxFrameByAdd(_ edgeInsets: UIEdgeInsets) -> CGRect {
        return CGRect(x: minX - edgeInsets.left,
                      y: minY - edgeInsets.top,
                      width: width + edgeInsets.left + edgeInsets.right,
                      height: height + edgeInsets.top + edgeInsets.bottom)
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

extension QXEdgeInsets: CustomStringConvertible {
    
    public var description: String {
        func string(_ f: CGFloat) -> String {
            if f == CGFloat(Int(f)) {
                return "\(Int(f))"
            } else {
                return "\(f)"
            }
        }
        return "[\(string(top)),\(string(right)),\(string(bottom)),\(string(left))]"
    }
    
}
