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
    
    lazy var num1: QXLabel = {
        let e = QXLabel()
        e.text = "12345"
        e.font = QXFont(size: 19, fontName: "Arial-BoldMT", color: QXColor.fmtHex("#FF8F28"))
        return e
    }()
    lazy var label1: QXLabel = {
        let e = QXLabel()
        e.text = "12345"
        e.font = QXFont(size: 14, color: QXColor.fmtHex("#666666"))
        return e
    }()
    
    lazy var num2: QXLabel = {
        let e = QXLabel()
        e.font = QXFont(size: 19, fontName: "Arial-BoldMT", color: QXColor.fmtHex("#FF8F28"))
        e.text = "12345"
        return e
    }()
    lazy var label2: QXLabel = {
        let e = QXLabel()
        e.text = "12345"
        e.font = QXFont(size: 14, color: QXColor.fmtHex("#666666"))
        return e
    }()
    
    lazy var num3: QXLabel = {
        let e = QXLabel()
        e.text = "12345"
        e.font = QXFont(size: 19, fontName: "Arial-BoldMT", color: QXColor.fmtHex("#FF8F28"))
        return e
    }()
    lazy var label3: QXLabel = {
        let e = QXLabel()
        e.font = QXFont(size: 14, color: QXColor.fmtHex("#666666"))
        e.text = "12345"
        return e
    }()
    
    lazy var stack1: QXStackView = {
        let e = QXStackView()
        e.isVertical = true
        e.alignmentX = .center
        e.setupViews(self.num1, self.label1)
        return e
    }()
    lazy var stack2: QXStackView = {
        let e = QXStackView()
        e.isVertical = true
        e.alignmentX = .center
        e.setupViews(self.num2, self.label2)
        return e
    }()
    lazy var stack3: QXStackView = {
        let e = QXStackView()
        e.isVertical = true
        e.alignmentX = .center
        e.setupViews(self.num3, self.label3)
        return e
    }()
    
    lazy var stack: QXStackView = {
        let e = QXStackView()
        //e.intrinsicWidth = 300
        e.setupViews(self.stack1, QXFlexView(), self.stack2, QXFlexView(), self.stack3)
        return e
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Stack"
        view.qxBackgroundColor = QXColor.white
        view.addSubview(stack)
        stack.IN(view).CENTER.WIDTH(300).MAKE()
        stack.qxDebugRandomColor()
    }

}
