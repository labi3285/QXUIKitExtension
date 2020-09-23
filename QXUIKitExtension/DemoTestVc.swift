//
//  DemoTestVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/29.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import SQLite3

let kr = UIScreen.main.bounds.width / 375

class DemoTestVc: QXTableViewController<Any> {
    
    lazy var textCell: QXStaticTextCell = {
        let e = QXStaticTextCell()
        e.label.font = QXFont(16 * kr, QXColor.red)
        e.label.padding = QXEdgeInsets(16 * kr, 24 * kr, 16 * kr, 24 * kr)
        e.label.text = "呵呵呵：\n分类为你奉为你发呢为你奉为丰富温暖"
        e.label.qxDebugRandomColor()
        return e
    }()
    
    lazy var xx: QXRichLabel = {
        let e = QXRichLabel()
        e.maxWidth = 200
        e.numberOfLines = 0
        e.text = "呵呵呵：\n分类为你奉为你发呢为你奉为丰富温暖"
        e.padding = QXEdgeInsets(10, 24, 10, 24)
        e.qxDebugRandomColor()
        return e
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "测试"
//        view.addSubview(xx)
//        xx.IN(view).CENTER.MAKE()
        
        contentView.models = [
            textCell
        ]
    }
    
    override func didSetup() {
        super.didSetup()
        
        
//        let name = "截屏2020-07-28下午11.15.37.jepg"
//        let path = QXPath.cache /+ "upload" /+ name
//        let dir = path.qxString(start: 0, end: path.count - 1)
//        print(dir)        
    }

}
