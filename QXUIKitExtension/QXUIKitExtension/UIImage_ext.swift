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
