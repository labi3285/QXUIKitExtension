//
//  DemoTestVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/29.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

class DemoTestVc: QXLoadStatusViewController<Any> {
    
    lazy var btn: QXIconButton = {
        let e = QXIconButton()
        e.isVertical = true
        e.icon = QXImage("icon_mine_recommend").setSize(40, 40)
        e.name = "菜单"
        return e
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "测试模型解析"
        view.addSubview(btn)
        btn.IN(view).CENTER.MAKE()
        
        
        contentView.reloadData()
    }
    
    override func loadData(_ done: @escaping (QXRequest.Respond<Any>) -> ()) {
        
        done(.succeed(123))
        
    }
    
}
