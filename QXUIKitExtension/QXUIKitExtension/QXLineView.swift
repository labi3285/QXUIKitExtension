//
//  QXLineView.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/8/20.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

extension QXLineView {
    
    public static var breakLine: QXLineView {
        let e = QXLineView()
        e.lineWidth = 0.5
        e.lineColor = QXColor.dynamicLine
        return e
    }
}

open class QXLineView: QXView {
    
    public var lineWidth: CGFloat {
        set {
            lineLayer.lineWidth = newValue
        }
        get {
            return lineLayer.lineWidth
        }
    }
    public var lineColor: QXColor {
        set {
            lineLayer.strokeColor = newValue.uiColor.cgColor
        }
        get {
            if let e = lineLayer.strokeColor {
                return QXColor.cgColor(e)
            }
            return QXColor.cgColor(UIColor.black.cgColor)
        }
    }
    public var lineCap: CGLineCap {
        set {
            switch newValue {
            case .butt:
                lineLayer.lineCap = CAShapeLayerLineCap(rawValue: "butt")
            case .round:
                lineLayer.lineCap = CAShapeLayerLineCap(rawValue: "round")
            case .square:
                lineLayer.lineCap = CAShapeLayerLineCap(rawValue: "square")
            @unknown default:
                lineLayer.lineCap = CAShapeLayerLineCap(rawValue: "round")
            }
        }
        get {
            switch lineLayer.lineCap.rawValue {
            case "round":
                return .round
            case "square":
                return .square
            default:
                return .butt
            }
        }
    
    }
    public var lineDashPhase: CGFloat? {
        set {
            lineLayer.lineDashPhase = newValue ?? 0
        }
        get {
            return lineLayer.lineDashPhase
        }
    }
    public var lineDashPattern: [CGFloat]? {
        set {
            lineLayer.lineDashPattern = newValue as [NSNumber]?
        }
        get {
            return lineLayer.lineDashPattern as? [CGFloat]
        }
    }

    public var isVertical: Bool = false
        
    public final lazy var lineLayer: CAShapeLayer = {
        let e = CAShapeLayer()
        e.lineWidth = 1
        e.strokeColor = UIColor.black.cgColor
        e.lineCap = CAShapeLayerLineCap(rawValue: "round")
        return e
    }()
        
    public override init() {
        super.init()
        layer.addSublayer(lineLayer)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func natureContentSize() -> QXSize {
        if let e = fixWidth ?? maxWidth {
            if isVertical {
                return QXSize(e, QXView.extendLength)
            } else {
                return QXSize(e, lineWidth + padding.top + padding.bottom)
            }
        } else if let e = fixHeight ?? maxHeight {
            if isVertical {
                return QXSize(lineWidth + padding.left + padding.right, e)
            } else {
                return QXSize(QXView.extendLength, e)
            }
        } else {
            if isVertical {
                return QXSize(lineWidth + padding.left + padding.right, QXView.extendLength)
            } else {
                return QXSize(QXView.extendLength, lineWidth + padding.top + padding.bottom)
            }
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        if isVertical {
            let y = padding.top
            let x = padding.left + (bounds.width - padding.left - padding.right) / 2
            let h = bounds.height - padding.top - padding.bottom
            let path = UIBezierPath()
            path.move(to: CGPoint.zero)
            path.addLine(to: CGPoint(x: 0, y: h))
            lineLayer.path = path.cgPath
            lineLayer.frame = CGRect(x: x, y: y, width: lineLayer.lineWidth, height: h)
        } else {
            let x = padding.left
            let y = padding.top + (bounds.height - padding.top - padding.bottom) / 2
            let w = bounds.width - padding.left - padding.right
            let path = UIBezierPath()
            path.move(to: CGPoint.zero)
            path.addLine(to: CGPoint(x: w, y: 0))
            lineLayer.path = path.cgPath
            lineLayer.frame = CGRect(x: x, y: y, width: w, height: lineLayer.lineWidth)
        }
    }
    
}
