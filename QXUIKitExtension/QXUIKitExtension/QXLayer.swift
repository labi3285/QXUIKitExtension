//
//  QXLayer.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/12/9.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

open class QXLayer {

    public let layer: CALayer
    
    public required init(_ layer: CALayer) {
        self.layer = layer
    }

    public static func lineGradientLayer(colors: [QXColor], isVertical: Bool) -> QXLayer {
        if isVertical {
            return lineGradientLayer(colors: colors, locations: nil, startAnchor: QXPoint(0.5, 0), endAnchor: QXPoint(0.5, 1))
        } else {
            return lineGradientLayer(colors: colors, locations: nil, startAnchor: QXPoint(0, 0.5), endAnchor: QXPoint(1, 0.5))
        }
    }
    
    /// locations: 0-1
    public static func lineGradientLayer(colors: [QXColor], locations: [CGFloat]?, startAnchor: QXPoint, endAnchor: QXPoint) -> QXLayer {
        let e = CAGradientLayer()
        e.colors = colors.map { $0.uiColor.cgColor }
        if let arr = locations {
            e.locations = arr as [NSNumber]
        }
        e.startPoint = startAnchor.cgPoint
        e.endPoint = endAnchor.cgPoint
        return QXLayer(e)
    }
    
    public static func imageLayer(image: QXImage) -> QXLayer {
        let e = CALayer()
        e.contents = image.uiImage?.cgImage
        return QXLayer(e)
    }
 
}


open class QXLayersView: QXView {
    
    public let qxLayers: [QXLayer]
    public required init(_ qxLayers: [QXLayer]) {
        self.qxLayers = qxLayers
        super.init()
        for e in qxLayers {
            layer.addSublayer(e.layer)
        }
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        for e in qxLayers {
            e.layer.frame = bounds.qxFrameByAdd(padding.uiEdgeInsets)
        }
    }
    
}

