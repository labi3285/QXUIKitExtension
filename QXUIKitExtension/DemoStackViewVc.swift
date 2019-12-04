//
//  TestStack.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import QXConsMaker

class DemoStackViewVc: QXViewController {
    
//    final lazy var num1: QXTitleButton = {
//        let e = QXTitleButton()
//        e.title = "12345"
//        e.font = QXFont(size: 19, fontName: "Arial-BoldMT", color: QXColor.fmtHex("#FF8F28"))
//        return e
//    }()
//    final lazy var label1: QXTitleButton = {
//        let e = QXTitleButton()
//        e.title = "12345"
//        e.font = QXFont(14, QXColor.dynamicTitle)
//        return e
//    }()
//
//    final lazy var num2: QXTitleButton = {
//        let e = QXTitleButton()
//        e.font = QXFont(size: 19, fontName: "Arial-BoldMT", color: QXColor.fmtHex("#FF8F28"))
//        e.title = "12345"
//        return e
//    }()
//    final lazy var label2: QXTitleButton = {
//        let e = QXTitleButton()
//        e.title = "12345"
//        e.font = QXFont(14, QXColor.dynamicTitle)
//        return e
//    }()
//
//    final lazy var num3: QXTitleButton = {
//        let e = QXTitleButton()
//        e.title = "12345"
//        e.font = QXFont(size: 19, fontName: "Arial-BoldMT", color: QXColor.fmtHex("#FF8F28"))
//        return e
//    }()
//    final lazy var label3: QXTitleButton = {
//        let e = QXTitleButton()
//        e.font = QXFont(14, QXColor.dynamicTitle)
//        e.title = "12345"
//        return e
//    }()
//
//    final lazy var stack1: QXStackView = {
//        let e = QXStackView()
//        e.isVertical = true
//        e.alignmentX = .center
//        e.setupViews(QXSpace(10), self.num1, QXFlexSpace(20), self.label1, QXSpace(5))
//        return e
//    }()
//    final lazy var stack2: QXStackView = {
//        let e = QXStackView()
//        e.isVertical = true
//        e.alignmentX = .center
//        e.setupViews(self.num2, self.label2)
//        return e
//    }()
//    final lazy var stack3: QXStackView = {
//        let e = QXStackView()
//        e.isVertical = true
//        e.alignmentX = .center
//        e.setupViews(self.num3, self.label3)
//        return e
//    }()
//
//    final lazy var stack: QXStackView = {
//        let e = QXStackView()
//        e.fixSize = QXSize(300, 300)
//        e.setupViews(self.stack1, QXFlexSpace(), self.stack2, QXFlexSpace(), self.stack3)
//        return e
//    }()
//
    final lazy var v1: QXView = {
        let e = QXView()
        e.extendHeight = true
        e.divideRatioX = 1
        return e
    }()
    final lazy var v2: QXView = {
        let e = QXView()
        e.extendHeight = true
        e.divideRatioX = 2
        return e
    }()
    final lazy var v3: QXView = {
        let e = QXView()
        e.extendHeight = true
        e.fixWidth = 10
        return e
    }()
    final lazy var stack: QXStackView = {
        let e = QXStackView()
        e.fixSize = QXSize(300, 300)
        e.viewMargin = 10
        e.padding = QXEdgeInsets(10, 10, 10, 10)
        e.views = [self.v1, self.v2, self.v3]
        return e
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Stack"
        view.addSubview(stack)
        stack.IN(view).CENTER.WIDTH(300).HEIGHT(100).MAKE()
        stack.qxDebugRandomColor()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch back")
    }

}
