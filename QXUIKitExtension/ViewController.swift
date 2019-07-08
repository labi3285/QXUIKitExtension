//
//  ViewController.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/6/22.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

class TestVc: QXViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "xx"
        view.qxColor = QXColor.backgroundGray
        navigationBarBackArrowImage = QXImage("icon_back")
        navigationBarBackItem = QXBarButtonItem.titleItem(title: "x", styles: nil)
        isNavigationBarLineShow = false
        navigationBarBackgroundColor = QXColor.green
        navigationBarTitle = "test"
        navigationBarTitleFont = QXFont(size: 20, color: QXColor.brown)
        navigationBarTintColor = QXColor.red
        isNavigationBarShow = true
    }
    
    @objc func dismiss1() {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        navigationController?.qxRemoveViewController(0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

class ViewController: QXViewController {

    lazy var label: UILabel = {
        let one = UILabel()
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarTitle = "Home"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = TestVc()
        push(vc)
    }


}

