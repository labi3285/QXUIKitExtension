//
//  DemoShapeVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/12/5.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

class DemoShapeVc: QXViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "QXShape"
        
        let v = QXImageView()
        v.qxBackgroundColor = QXColor.yellow
        let v1 = QXImageView()
        v1.qxBackgroundColor = QXColor.yellow
        view.addSubview(v)
        view.addSubview(v1)
        v.IN(view).CENTER.TOP(100).MAKE()
        v1.BOTTOM(v).CENTER.OFFSET(10).MAKE()
                        
        
        v.image = QXImage.shapLabelHollow(text: "标签", font: QXFont(100, QXColor.red), color: QXColor.green)
        v1.image = QXImage.shapLabelFill(text: "标签", font: QXFont(100, QXColor.red), color: QXColor.green)
        
        
        v.image = QXImage.shapRoundRectHollow(size: QXSize(100, 50), radius: 5, thickness: 3, color: QXColor.red)
        v1.image = QXImage.shapRoundRectFill(size: QXSize(100, 50), radius: 5, color: QXColor.green)
        
        v.image = QXImage.shapTriangleFill(w: 280, h: 160, direction: .left, color: QXColor.red)
        v1.image = QXImage.shapTriangleHollow(w: 280, h: 160, thickness: 30, direction: .left, color: QXColor.green)
    }
    
}
