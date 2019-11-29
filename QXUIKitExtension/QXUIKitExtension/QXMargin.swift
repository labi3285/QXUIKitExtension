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
    
//    public mutating func reduce(_ edgeInsets: QXEdgeInsets) {
//        x = x + edgeInsets.left
//        y = y + edgeInsets.top
//        w = w - edgeInsets.left - edgeInsets.right
//        h = h - edgeInsets.top - edgeInsets.bottom
//    }
//    public mutating func add(_ edgeInsets: QXEdgeInsets) {
//        x = x - edgeInsets.left
//        y = y - edgeInsets.top
//        w = w + edgeInsets.left + edgeInsets.right
//        h = h + edgeInsets.top + edgeInsets.bottom
//    }
    
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
    public func rectByScale(_ scale: CGFloat) -> QXRect {
        return QXRect(x * scale,
                      y * scale,
                      w * scale,
                      h * scale)
    }
    
}

extension QXSize {
    
    public mutating func reduce(_ edgeInsets: QXEdgeInsets) {
        w = w - edgeInsets.left - edgeInsets.right
        h = h - edgeInsets.top - edgeInsets.bottom
    }
    public mutating func scale(_ scale: CGFloat) {
        w = w * scale
        h = h * scale
    }
    public mutating func add(_ edgeInsets: QXEdgeInsets) {
        w = w + edgeInsets.left + edgeInsets.right
        h = h + edgeInsets.top + edgeInsets.bottom
    }
    
    public func sizeByReduce(_ edgeInsets: QXEdgeInsets) -> QXSize {
        return QXSize(w - edgeInsets.left - edgeInsets.right, h - edgeInsets.top - edgeInsets.bottom)
    }
    public func sizeByAdd(_ edgeInsets: QXEdgeInsets) -> QXSize {
        return QXSize(w + edgeInsets.left + edgeInsets.right, h + edgeInsets.top + edgeInsets.bottom)
    }
    public func sizeByScale(_ scale: CGFloat) -> QXSize {
        return QXSize(w * scale, h * scale)
    }
    
}

extension CGRect {
    
    public mutating func qxReduce(_ edgeInsets: UIEdgeInsets) {
        origin.x = origin.x + edgeInsets.left
        origin.y = origin.y + edgeInsets.top
        size.width = size.width - edgeInsets.left - edgeInsets.right
        size.height = size.height - edgeInsets.top - edgeInsets.bottom
    }
    
    public mutating func qxAdd(_ edgeInsets: UIEdgeInsets) {
        origin.x = origin.x - edgeInsets.left
        origin.y = origin.y - edgeInsets.top
        size.width = size.width + edgeInsets.left + edgeInsets.right
        size.height = size.height + edgeInsets.top + edgeInsets.bottom
    }
    public mutating func qxScale(_ scale: CGFloat) {
        origin.x = origin.x * scale
        origin.y = origin.y * scale
        size.width = size.width * scale
        size.height = size.height * scale
    }
    
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
    public func qxFrameByScale(_ scale: CGFloat) -> CGRect {
        return CGRect(x: minX * scale,
                      y: minY * scale,
                      width: width * scale,
                      height: height * scale)
    }
    
}

extension CGSize {
    
    public mutating func qxReduce(_ inserts: UIEdgeInsets) {
        width = width - inserts.left - inserts.right
        height = height - inserts.top - inserts.bottom
    }
    public mutating func qxAdd(_ inserts: UIEdgeInsets) {
        width = width + inserts.left + inserts.right
        height = height + inserts.top + inserts.bottom
    }
    public mutating func qxScale(_ scale: CGFloat) {
        width = width * scale
        height = height * scale
    }
    
    public func qxSizeByReduce(_ inserts: UIEdgeInsets) -> CGSize {
        return CGSize(width: width - inserts.left - inserts.right, height: height - inserts.top - inserts.bottom)
    }
    public func qxSizeByAdd(_ inserts: UIEdgeInsets) -> CGSize {
        return CGSize(width: width - inserts.left - inserts.right, height: height - inserts.top - inserts.bottom)
    }
    public func qxSizeByScale(_ scale: CGFloat) -> CGSize {
        return CGSize(width: width * scale, height: height * scale)
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
