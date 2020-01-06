//
//  DemoTestVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/29.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import SQLite3


class DemoTestVc: QXViewController {
    
    lazy var textField: QXTextField = {
        let e = QXTextField()
        
        let icon = QXImageView()
        icon.image = QXUIKitExtensionResources.shared.image("icon_clear")
            .setSize(20, 20)
        icon.padding = QXEdgeInsets(7, 7, 7, 7)
        e.iconView = icon
        
        let btn = QXIconButton()
        btn.padding = QXEdgeInsets(7, 7, 7, 7)
        btn.icon = QXUIKitExtensionResources.shared.image("icon_clear")
            .setSize(20, 20)
        e.clearButton = btn
        
        let btn1 = QXIconButton()
        btn1.padding = QXEdgeInsets(7, 7, 7, 7)
        btn1.icon = QXUIKitExtensionResources.shared.image("icon_clear")
            .setSize(20, 20)
        e.handleButton = btn1
        
        e.filter = QXTextFilter.phone
        return e
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "测试"
        

        navigationBarBackTitle = "x"
        
        view.backgroundColor = UIColor.yellow
        
        view.addSubview(textField)
        textField.IN(view).CENTER.SIZE(300, 50).MAKE()
        textField.backgroundColor = UIColor.white

    }
    
    @objc func xxx() {
        print("xxx")
    }
}
