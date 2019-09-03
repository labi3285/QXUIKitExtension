//
//  ViewController.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/6/22.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: QXTableViewController<Any, QXLoadStatusView> {
    
    lazy var lineView: QXLineView = {
        let one = QXLineView()
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "首页"
        view.backgroundColor = UIColor.white
        
        let bar = QXNavigationBar()
        let btn = QXTitleButton()
        btn.title = "测试"
        btn.respondClick = { [weak self] in
            let vc = TestVc()
            self?.push(vc)
        }
        bar.rightViewA = btn
        
        customNavigationBar = bar
        
        canRefresh = true
        canPage = true
        retry()
    }
    override func loadModels() {
        super.loadModels()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            let ms: [Any] = [1, 2, 3, 4, 5, 6, 7, 8, 9, "a", "b", "c", "d", "e", "f"]
            self.onLoadModelsOk(ms)
            //            self.onLoadModelsFailed(QXError.unknown)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = TestVc()
        let nav = QXNavigationController(rootViewController: vc)
        present(nav)
    }
    
    override func shouldPop() -> Bool {
        showWarning(msg: "home")
        return true
    }
    
}

class TestVc: QXTableViewController<Int, QXLoadStatusView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "测试"
        navigationBarBackTitle = "返回"
        navigationBarBackgroundColor = QXColor.blue
        view.backgroundColor = UIColor.white
        navigationBarTintColor = QXColor.red
        customNavigationBar = QXNavigationBar()
        canRefresh = true
        canPage = true
        retry()
    }
    override func loadModels() {
        super.loadModels()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            let ms = [1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6]
            self.onLoadModelsOk(ms)
//            self.onLoadModelsFailed(QXError.unknown)
        }
    }
    
    override func shouldPop() -> Bool {
        showWarning(msg: "test")
        return true
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let vc = TestVc()
//        let nav = QXNavigationController(rootViewController: vc)
//        present(nav)
//    }
}


