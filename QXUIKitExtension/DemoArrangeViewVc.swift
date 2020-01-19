//
//  DemoArrangeVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/29.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

class DemoArrangeViewVc: QXViewController {
    
    final lazy var arrangeView: QXArrangeView = {
        let e = QXArrangeView()
        e.padding = QXEdgeInsets(10, 10, 10, 10)
        e.fixWidth = 300
        e.alignmentX = .right
        var arr = [QXViewProtocol]()
        for i in 0..<10 {
            let e = QXTitleButton()
            //e.numberOfLines = 0
            e.title = QXDebugRandomText(14)
            e.respondClick = {
                print("xxx\(i)")
            }
            arr.append(e)
            
            if i == 0 {
                arr.append(QXFlexSpace(5))
            }
        }
        e.views = arr
        e.qxDebugRandomColor()
        return e
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch back")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.yellow
        
        view.addSubview(arrangeView)
        
        arrangeView.IN(view).CENTER.MAKE()
    }
    
}
