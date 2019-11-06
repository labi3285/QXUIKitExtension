//
//  DemoArrangeVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/29.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

class DemoArrangeViewVc: QXViewController {
    
    lazy var arrangeView: QXArrangeView = {
        let e = QXArrangeView()
        e.padding = QXEdgeInsets(10, 10, 10, 10)
        e.intrinsicWidth = 300
        var arr = [QXView]()
        for i in 0..<10 {
            let e = QXLabel()
            e.numberOfLines = 0
            e.intrinsicWidth = 60
            e.text = QXDebugRandomText(14)
            arr.append(e)
        }
        e.setupViews(arr)
        return e
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yellow
        
        view.addSubview(arrangeView)
        
        arrangeView.IN(view).CENTER.MAKE()
    }
    
}
