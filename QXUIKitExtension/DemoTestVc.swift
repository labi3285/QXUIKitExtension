//
//  DemoTestVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/29.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

class DemoTestVc: QXLoadStatusViewController<Any> {
    
    lazy var btn: QXFoldButton = {
        let e = QXFoldButton()
        e.title = "菜单"
        e.respondClick = { [unowned e] in
            e.isFold = !e.isFold 
        }
        return e
    }()
    
    lazy var mask: QXMaskButton = {
        let e = QXMaskButton(view: btn)
        return e
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "测试"
        view.backgroundColor = UIColor.yellow
//        view.addSubview(mask)
//        mask.IN(view).CENTER.SIZE(300, 300).MAKE()
        
//        let mask = CAShapeLayer()
//        mask.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//        let path = UIBezierPath()
//        path.move(to: CGPoint(x: 0, y: 44))
//        path.addLine(to: CGPoint(x: 100, y: 44))
//        path.addLine(to: CGPoint(x: 100, y: 0))
//        path.addLine(to: CGPoint(x: 30, y: 0))
//        path.close()
//        mask.path = path.cgPath
//        view.layer.mask = mask
        
//        back.layer.mask = mask
                
        contentView.reloadData()
    }
    
    override func loadData(_ done: @escaping (QXRequest.Respond<Any>) -> ()) {
        
        done(.succeed(123))
        
    }
    
}
