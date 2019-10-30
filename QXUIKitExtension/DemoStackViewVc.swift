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
        let one = QXLabel()
        one.text = "12345"
        one.font = QXFont(size: 19, fontName: "Arial-BoldMT", color: QXColor.fmtHex("#FF8F28"))
        return one
    }()
    lazy var label1: QXLabel = {
        let one = QXLabel()
        one.text = "12345"
        one.font = QXFont(size: 14, color: QXColor.fmtHex("#666666"))
        return one
    }()
    
    lazy var num2: QXLabel = {
        let one = QXLabel()
        one.font = QXFont(size: 19, fontName: "Arial-BoldMT", color: QXColor.fmtHex("#FF8F28"))
        one.text = "12345"
        return one
    }()
    lazy var label2: QXLabel = {
        let one = QXLabel()
        one.text = "12345"
        one.font = QXFont(size: 14, color: QXColor.fmtHex("#666666"))
        return one
    }()
    
    lazy var num3: QXLabel = {
        let one = QXLabel()
        one.text = "12345"
        one.font = QXFont(size: 19, fontName: "Arial-BoldMT", color: QXColor.fmtHex("#FF8F28"))
        return one
    }()
    lazy var label3: QXLabel = {
        let one = QXLabel()
        one.font = QXFont(size: 14, color: QXColor.fmtHex("#666666"))
        one.text = "12345"
        return one
    }()
    
    lazy var stack1: QXStackView = {
        let one = QXStackView()
        one.isVertical = true
        one.alignmentX = .center
        one.setupViews(self.num1, self.label1)
        return one
    }()
    lazy var stack2: QXStackView = {
        let one = QXStackView()
        one.isVertical = true
        one.alignmentX = .center
        one.setupViews(self.num2, self.label2)
        return one
    }()
    lazy var stack3: QXStackView = {
        let one = QXStackView()
        one.isVertical = true
        one.alignmentX = .center
        one.setupViews(self.num3, self.label3)
        return one
    }()
    
    lazy var stack: QXStackView = {
        let one = QXStackView()
        //one.intrinsicWidth = 300
        one.setupViews(self.stack1, QXFlexView(), self.stack2, QXFlexView(), self.stack3)
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Stack"
        view.qxBackgroundColor = QXColor.white
        contentView.addSubview(stack)
        stack.IN(contentView).CENTER.WIDTH(300).MAKE()
        stack.qxDebugRandomColor()
    }

}
