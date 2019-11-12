//
//  DemoTestVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/29.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

class DemoTestVc: QXViewController {
    
    lazy var num1: QXLabel = {
        let e = QXLabel()
        e.text = "输入内容"
        e.text = "xxxxxxxxx"

//        e.font = QXFont(fmt: "16 #999999")
        e.padding = QXEdgeInsets(7, 5, 7, 5)
        e.isCopyEnabled = true
        e.qxDebugRandomColor()
        return e
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yellow
        view.addSubview(num1)
        num1.IN(view).CENTER.MAKE()
    }
    
}
