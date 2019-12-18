//
//  QXShap.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/12/5.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

extension QXImage {
    
    public static func shapRectFill(size: QXSize, color: QXColor) -> QXImage {
        return QXImage.image(size: size) { (ctx, size, scale) in
            ctx.setLineWidth(0)
            color.uiColor.setFill()
            let rect = CGRect(x: 0, y: 0, width: size.w, height: size.h)
            ctx.fill(rect)
        }
    }
    
    public static func shapRectHollow(w: CGFloat, h: CGFloat, thickness: CGFloat, color: QXColor) -> QXImage {
        return QXImage.image(size: QXSize(w, h)) { (ctx, size, scale) in
            ctx.setLineWidth(thickness)
            color.uiColor.setStroke()
            let rect = CGRect(x: thickness / 2, y: thickness / 2, width: size.w - thickness, height: size.h - thickness)
            ctx.stroke(rect)
        }
    }
    public static func shapTriangleFill(w: CGFloat, h: CGFloat, direction: QXDirection, color: QXColor) -> QXImage {
        let size: QXSize
        switch direction {
        case .up, .down:
            size = QXSize(w, h)
        case .left, .right:
            size = QXSize(h, w)
        }
        return QXImage.image(size: size) { (ctx, size, scale) in
            let w = w * scale
            let h = h * scale
            ctx.setLineWidth(0)
            color.uiColor.setFill()
            switch direction {
            case .up:
                ctx.move(to: CGPoint(x: 0, y: h))
                ctx.addLine(to: CGPoint(x: w / 2, y: 0))
                ctx.addLine(to: CGPoint(x: w, y: h))
                ctx.closePath()
            case .down:
                ctx.move(to: CGPoint(x: 0, y: 0))
                ctx.addLine(to: CGPoint(x: w, y: 0))
                ctx.addLine(to: CGPoint(x: w / 2, y: h))
                ctx.closePath()
            case .left:
                ctx.move(to: CGPoint(x: h, y: 0))
                ctx.addLine(to: CGPoint(x: h, y: w))
                ctx.addLine(to: CGPoint(x: 0, y: w / 2))
                ctx.closePath()
            case .right:
                ctx.move(to: CGPoint(x: 0, y: 0))
                ctx.addLine(to: CGPoint(x: h, y: w / 2))
                ctx.addLine(to: CGPoint(x: 0, y: w))
                ctx.closePath()
            }
            ctx.fillPath()
        }
    }
    public static func shapTriangleHollow(w: CGFloat, h: CGFloat, thickness: CGFloat, direction: QXDirection, color: QXColor) -> QXImage {
        let size: QXSize
        switch direction {
        case .up, .down:
            let st = atan(2 * h/w)
            let d1 = thickness / (2 * tan(st / 2))
            let d2 = thickness / 2 / cos(st)
            size = QXSize(w + d1 * 2, h + d2 + thickness / 2)
        case .left, .right:
            let st = atan(2 * h/w)
            let d1 = thickness / (2 * tan(st / 2))
            let d2 = thickness / 2 / cos(st)
            size = QXSize(h + d2 + thickness / 2, w + d1 * 2)
        }
        return QXImage.image(size: size) { (ctx, size, scale) in
            let thickness = thickness * scale
            let w = w * scale
            let h = h * scale
            ctx.setLineWidth(thickness)
            color.uiColor.setStroke()
            switch direction {
            case .up:
                let st = atan(2 * h/w)
                let d1 = thickness / (2 * tan(st / 2))
                let d2 = thickness / 2 / cos(st)
                ctx.move(to: CGPoint(x: d1, y: d2 + h))
                ctx.addLine(to: CGPoint(x: d1 + w / 2, y: d2))
                ctx.addLine(to: CGPoint(x: d1 + w, y: d2 + h))
                ctx.closePath()
            case .down:
                let st = atan(2 * h/w)
                let d1 = thickness / (2 * tan(st / 2))
                ctx.move(to: CGPoint(x: d1, y: thickness / 2))
                ctx.addLine(to: CGPoint(x: d1 + w, y: thickness / 2))
                ctx.addLine(to: CGPoint(x: d1 + w / 2, y: thickness / 2 + h))
                ctx.closePath()
            case .left:
                let st = atan(2 * h/w)
                let d1 = thickness / (2 * tan(st / 2))
                let d2 = thickness / 2 / cos(st)
                ctx.move(to: CGPoint(x: d2, y: d1 + w / 2))
                ctx.addLine(to: CGPoint(x: d2 + h, y: d1))
                ctx.addLine(to: CGPoint(x: d2 + h, y: d1 + w))
                ctx.closePath()
            case .right:
                let st = atan(2 * h/w)
                let d1 = thickness / (2 * tan(st / 2))
                ctx.move(to: CGPoint(x: thickness / 2, y: d1))
                ctx.addLine(to: CGPoint(x: thickness / 2 + h, y: d1 + w / 2))
                ctx.addLine(to: CGPoint(x: thickness / 2, y: d1 + w))
                ctx.closePath()
            }
            ctx.strokePath()
        }
    }
    
    public static func shapRoundFill(radius: CGFloat, color: QXColor) -> QXImage {
        return QXImage.shapRoundRectFill(size: QXSize(radius * 2, radius * 2), radius: radius, color: color)
    }
    public static func shapRoundHollow(radius: CGFloat, thickness: CGFloat, color: QXColor) -> QXImage {
        return QXImage.shapRoundRectHollow(size: QXSize(radius * 2, radius * 2), radius: radius, thickness: thickness, color: color)
    }
    
    public static func shapRoundRectFill(size: QXSize, radius: CGFloat, color: QXColor) -> QXImage {
        return QXImage.image(size: size) { (ctx, size, scale) in
            let rect = CGRect(x: 0, y: 1, width: size.w, height: size.h)
            let path = UIBezierPath(roundedRect: rect, cornerRadius: radius * scale)
            ctx.addPath(path.cgPath)
            ctx.setFillColor(color.uiColor.cgColor)
            ctx.setLineWidth(0)
            color.uiColor.setFill()
            ctx.fillPath()
        }
    }
    public static func shapRoundRectHollow(size: QXSize, radius: CGFloat, thickness: CGFloat, color: QXColor) -> QXImage {
        return QXImage.image(size: size) { (ctx, size, scale) in
            let t = thickness * scale
            let rect = CGRect(x: t / 2, y: t / 2, width: size.w - t, height: size.h - t)
            let path = UIBezierPath(roundedRect: rect, cornerRadius: radius * scale)
            ctx.addPath(path.cgPath)
            ctx.setLineWidth(t)
            color.uiColor.setStroke()
            ctx.strokePath()
        }
    }
    
    public static func shapLabelFill(text: String, font: QXFont, color: QXColor) -> QXImage {
        let e = QXEdgeInsets(font.size / 10, font.size / 3, font.size / 10, font.size / 3)
        return shapLabelFill(text: text, font: font, borderRadius: font.size / 5, borderPadding: e, color: color)
    }
    public static func shapLabelFill(text: String, font: QXFont, borderRadius: CGFloat, borderPadding: QXEdgeInsets, color: QXColor) -> QXImage {
        let wh = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font.uiFont]).qxSize
        let w = wh.width + borderPadding.left + borderPadding.right
        let h = wh.height + borderPadding.top + borderPadding.bottom
        return QXImage.image(size: QXSize(w, h)) { (ctx, size, scale) in
            let r = borderRadius * scale
            let rect = CGRect(x: 0, y: 0, width: size.w, height: size.h)
            let path = UIBezierPath(roundedRect: rect, cornerRadius: r)
            ctx.addPath(path.cgPath)
            ctx.setLineWidth(0)
            color.uiColor.setFill()
            ctx.fillPath()
            let scaleFont: UIFont
            if font.bold {
                scaleFont = UIFont.boldSystemFont(ofSize: font.size * scale)
            } else {
                scaleFont = UIFont.systemFont(ofSize: font.size * scale)
            }
            let dic: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: scaleFont,
                NSAttributedString.Key.foregroundColor: font.color.uiColor
            ]
            NSAttributedString(string: text, attributes: dic).draw(at: CGPoint(x: borderPadding.left * scale, y: borderPadding.top * scale))
        }
    }
    
    public static func shapLabelHollow(text: String, font: QXFont, color: QXColor) -> QXImage {
        let e = QXEdgeInsets(font.size / 10, font.size / 3, font.size / 10, font.size / 3)
        return shapLabelHollow(text: text, font: font, borderThickness: font.size / 10, borderRadius: font.size / 5, borderPadding: e, color: color)
    }
    public static func shapLabelHollow(text: String, font: QXFont, borderThickness: CGFloat, borderRadius: CGFloat, borderPadding: QXEdgeInsets, color: QXColor) -> QXImage {
        let wh = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font.uiFont]).qxSize
        let w = wh.width + borderPadding.left + borderPadding.right + borderThickness * 2
        let h = wh.height + borderPadding.top + borderPadding.bottom + borderThickness * 2
        return QXImage.image(size: QXSize(w, h)) { (ctx, size, scale) in
            let r = borderRadius * scale
            let b = borderThickness * scale
            let rect = CGRect(x: b / 2, y: b / 2, width: size.w - b, height: size.h - b)
            let path = UIBezierPath(roundedRect: rect, cornerRadius: r)
            ctx.addPath(path.cgPath)
            ctx.setLineWidth(b)
            color.uiColor.setStroke()
            ctx.strokePath()
            let scaleFont: UIFont
            if font.bold {
                scaleFont = UIFont.boldSystemFont(ofSize: font.size * scale)
            } else {
                scaleFont = UIFont.systemFont(ofSize: font.size * scale)
            }
            let dic: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.font: scaleFont,
                NSAttributedString.Key.foregroundColor: font.color.uiColor
            ]
            NSAttributedString(string: text, attributes: dic).draw(at: CGPoint(x: b + borderPadding.left * scale, y: b + borderPadding.top * scale))
        }
    }
    
}
