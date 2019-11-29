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
    
    public final lazy var backButton: QXImageButton = {
        let e = QXImageButton()
        e.fixSize = QXSize(100, 100)
        e.padding = QXEdgeInsets(5, 5, 5, 5)
        e.image = QXUIKitExtensionResources.shared.image("icon_backward")
        e.isEnabled = false
        e.respondClick = { [weak self] in
            print("xxx")
        }
        return e
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backButton)
        backButton.IN(view).CENTER.MAKE()
            
        
        print("xxx")

    }
    
}
