//
//  DemoTestVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/29.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import WebKit

class DemoTestVc: QXViewController {
    
//    public final lazy var arrowView: QXImageButton = {
//        let e = QXImageButton()
//        e.image = QXImage("icon_mine_ask1")
//        e.fixSize = QXSize(60, 60)
//        e.padding = QXEdgeInsets(5, 5, 5, 5)
//        e.qxDebugRandomColor()
//        return e
//    }()
    
    public final lazy var lineView: QXLineView = {
        let e = QXLineView()
        e.lineWidth = 10
        e.fixWidth = 100
        return e
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIImage(named: "test_dot")?.qxMainColor
        
        view.addSubview(lineView)
        lineView.IN(view).CENTER.MAKE()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        for i in 0..<1000 {
            let c = UIImage(named: "test_dot")?.qxMainColor
            print("xxx - \(c)")
        }
    }
    
}
