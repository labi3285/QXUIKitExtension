//
//  ViewController.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/6/22.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import Kingfisher

class Product: QXModel {
    
    static func getPageOfProducts(done: @escaping (_ respond: QXRespond<QXPage<Product>>) -> ()) {
        let r = QXRequest(method: .post, encoding: .json)
        r.url = "xxx"
        r.params = [:]
        r.fetchPage(done: done)
    }
    
}


class TestVc: QXTableViewController<Product, QXLoadStatusView> {
    
    lazy var xxx: QXView = {
        let one = QXView()
        one.backgroundColor = UIColor.yellow
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarTitleFont = QXFont(fmt: "15 #ffff00")
        navigationBarTintColor = QXColor.blue
        isNavigationBarShow = false
        title = "测试"
        
        navigationBarBackItem = QXBarButtonItem.backItem(title: "xx", styles: nil)
        navigationBarBackgroundColor = QXColor.red
        navigationBarBackArrowImage = QXImage("QXUIKitExtensionResources.bundle/icon_refresh_arrow")
        
        view.backgroundColor = QXColor.backgroundGray.uiColor
//        canRefresh = true
//        canPage = true
//        retry()
        
        view.addSubview(xxx)
        xxx.IN(view).CENTER.SIZE(200, 200).MAKE()
    }
    
//    override func loadModels() {
//        Product.getPageOfProducts { (page) in
//            self.onLoadModelsComplete(page)
//        }
//    }

}

class ViewController: QXViewController {
    
    lazy var xxx: QXImageButton = {
        let one = QXImageButton()
        one.backgroundColor = UIColor.yellow
        one.image = QXImage("icon_mine_ask1")
        one.imageHighlighted = QXImage("icon_mine_recommend")
        one.respondClick = {
            print("xxx")
        }
        return one
    }()
    
    lazy var label: QXLabel = {
        let one = QXLabel()
        one.margin = QXMargin(10, 10, 10, 10)
        one.qxDebugRandomColor()
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(xxx)
        xxx.IN(view).CENTER.MAKE()
        
//        xxx.addSubview(label)
//        label.IN(xxx).CENTER.MAKE()
//        label.text = "xxxx"
        
//        navigationBarTitleFont = QXFont(fmt: "15 #ffff00")
//        navigationBarTintColor = QXColor.red
//        title = "首页"
    }
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let vc = TestVc()
//        push(vc)
//        navigationController?.pushViewController(vc, animated: true)
//    }
}
