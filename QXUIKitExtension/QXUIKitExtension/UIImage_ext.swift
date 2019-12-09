//
//  UIImage_ext.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/7/5.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

extension UIImage {
    
    public var qxImage: QXImage {
        return QXImage(self)
    }
    
    public var qxMainColor: UIColor? {
        let w = min(Int(size.width), 9)
        let h = min(Int(size.height), 9)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        if let ctx = CGContext(data: nil, width: w, height: h, bitsPerComponent: 8, bytesPerRow: w * 4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue), let image = cgImage {
            let rect = CGRect(x: 0, y: 0, width: CGFloat(w), height: CGFloat(h))
            ctx.draw(image, in: rect)
            if let e = ctx.data {
                let data = e.assumingMemoryBound(to: CUnsignedChar.self)
                let set = NSCountedSet(capacity: w * h)
                for x in 0..<w {
                    for y in 0..<h {
                        let offset = (y * w + x) * 4
                        let R = (data + offset + 0).pointee
                        let G = (data + offset + 1).pointee
                        let B = (data + offset + 2).pointee
                        let A = (data + offset + 3).pointee
                        if A > 0 {
                           if (R != 255 || G != 255 || B != 255) {
                                set.add([CGFloat(R), CGFloat(G), CGFloat(B), CGFloat(A)])
                           }
                       }
                    }
                }
                var max: [CGFloat]?
                var maxCount: Int = 0
                for e in set {
                    let c = set.count(for: e)
                    
//                    print("\(c) ---  \(e)")

                    if c >= maxCount {
                        maxCount = c
                        max = e as? [CGFloat]
                    } else {
                        continue
                    }
                }
                if let e = max {
                    return UIColor(red: e[0] / 255,
                                   green: e[1] / 255,
                                   blue: e[2] / 255,
                                   alpha: e[3] / 255)
                }
            }
                
        }
        return UIColor.yellow
    }
    
    public static func qxCreate(text: String, font: UIFont, color: UIColor) -> UIImage {
        return qxCreate(text: text, font: font, color: color, ext: nil)
    }
    public static func qxCreate(text: String, font: UIFont, color: UIColor, ext: [NSAttributedString.Key : Any]?) -> UIImage {
        var dic: [NSAttributedString.Key : Any] = [:]
        if let e = ext {
            for (k,v) in e {
                dic[k] = v
            }
        }
        dic[NSAttributedString.Key.font] = font
        dic[NSAttributedString.Key.foregroundColor] = color
        let attri = NSAttributedString(string: text, attributes: dic)
        return qxCreate(size: attri.size(), render: { (ctx, rect) in
            attri.draw(at: CGPoint.zero)
        })
    }
    
    public static func qxCreate(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return qxCreate(size: size, render: { (ctx, rect) in
            ctx.setFillColor(color.cgColor)
            ctx.setLineWidth(0)
            ctx.fill(rect)
        })
    }
    
    public static func qxCreate(size: CGSize, render: (_ ctx: CGContext, _ rect: CGRect) -> ()) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let ctx = UIGraphicsGetCurrentContext()!
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        render(ctx, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}

extension QXImage {
    
    public static func image(text: String, font: UIFont, color: UIColor) -> QXImage {
        return image(text: text, font: font, color: color, ext: nil)
    }
    public static func image(text: String, font: UIFont, color: UIColor, ext: [NSAttributedString.Key : Any]?) -> QXImage {
        let scaleFont = font.withSize(font.qxSize * UIScreen.main.scale)
        let e = UIImage.qxCreate(text: text, font: scaleFont, color: color, ext: ext)
        let s = QXSize(e.size.width / UIScreen.main.scale, e.size.height / UIScreen.main.scale)
        return QXImage(e).setSize(s)
    }
    
    public static func image(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> QXImage {
        let s = CGSize(width: size.width * UIScreen.main.scale, height: size.height * UIScreen.main.scale)
        let e = UIImage.qxCreate(color: color, size: s)
        let s1 = QXSize(e.size.width / UIScreen.main.scale, e.size.height / UIScreen.main.scale)
        return QXImage(e).setSize(s1)
    }
    
    public static func image(size: QXSize, render: (_ ctx: CGContext, _ size: QXSize, _ scale: CGFloat) -> ()) -> QXImage {
        let s = CGSize(width: size.w * UIScreen.main.scale, height: size.h * UIScreen.main.scale)
        UIGraphicsBeginImageContext(s)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.translateBy(x: 0, y: -1)
        render(ctx, s.qxSize, UIScreen.main.scale)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let s1 = QXSize(s.width / UIScreen.main.scale, s.height / UIScreen.main.scale)
        return QXImage(image).setSize(s1)
    }
    
}
