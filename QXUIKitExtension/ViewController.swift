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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarTitleFont = QXFont(fmt: "15 #ffff00")
        navigationBarTintColor = QXColor.blue
        isNavigationBarShow = true
        
        title = "测试"
        
        navigationBarBackItem = QXBarButtonItem.backItem(title: "xx", styles: nil)
        navigationBarBackgroundColor = QXColor.red
        navigationBarBackArrowImage = QXImage("QXUIKitExtensionResources.bundle/icon_refresh_arrow")
        
        view.backgroundColor = QXColor.backgroundGray.uiColor
        canRefresh = true
        canPage = true
        retry()
    }
    
    override func shouldPop() -> Bool {
        showWarning(msg: "请先保存")
        return false
    }
    
    override func loadModels() {
//        Product.getPageOfProducts { (page) in
//            self.onLoadModelsComplete(page)
//        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//            let ms: [Product] = [Product(),Product(),Product(),Product()]
//            self.models = ms
//            self.tableView.qxSetNeedsLayout()
//            self.onLoadModelsOk(ms)
            self.onLoadModelsFailed(QXError.unknown)
        }
    }
    
    override func qxTableViewCell(_ model: Any?, _ reuseId: String) -> QXTableViewCell {
        return ProductCell(reuseId)
    }

}

class ProductCell: QXTableViewCell {
    
    override var model: Any? {
        didSet {
            if let m = model as? Product {
                label1.isDisplay = Bool.random()
                label2.isDisplay = Bool.random()
                label3.isDisplay = Bool.random()
                label1.text = QXDebugRandomText(50)
                label2.text = QXDebugRandomText(60)
                label3.text = QXDebugRandomText(300)
                stackView.qxSetNeedsLayout()
            }
            qxSetNeedsLayout()
        }
    }
    lazy var label1: QXLabel = {
        let one = QXLabel()
        one.numberOfLines = 0
        one.intrinsicWidth = UIScreen.main.bounds.width
        return one
    }()
    lazy var label2: QXLabel = {
        let one = QXLabel()
        one.numberOfLines = 0
        one.intrinsicWidth = UIScreen.main.bounds.width
        return one
    }()
    lazy var label3: QXLabel = {
        let one = QXLabel()
        one.numberOfLines = 0
        one.intrinsicWidth = UIScreen.main.bounds.width
        return one
    }()
    
    lazy var stackView: QXStackView = {
        let one = QXStackView(self.label1, self.label2, self.label3)
        one.viewMargin = 10
//        one.alignmentX = .center
//        one.alignmentY = .center
        one.isVertical = true
        one.qxDebugRandomColor()
        one.padding = QXMargin(10, 10, 10, 10)
        return one
    }()
    required init(_ reuseId: String) {
        super.init(reuseId)
        contentView.addSubview(stackView)
        stackView.IN(contentView).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        contentView.qxDebugRandomColor()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: QXViewController {
    
   
    lazy var a: QXLabel = {
        let one = QXLabel()
        one.intrinsicSize = QXSize(50, 50)
        return one
    }()
    lazy var b: QXLabel = {
        let one = QXLabel()
        one.intrinsicSize = QXSize(50, 50)
        return one
    }()
    lazy var c: QXLabel = {
        let one = QXLabel()
        one.intrinsicSize = QXSize(50, 50)
        return one
    }()
    
    lazy var stackView: QXStackView = {
        let one = QXStackView(self.a, QXFlexView(), self.b, QXFlexView(), self.c)
        one.qxDebugRandomColor()
        one.isVertical = true
        one.viewMargin = 10
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(stackView)
        stackView.IN(view).CENTER.SIZE(300, 300).MAKE()
        
        
//        xxx.addSubview(label)
//        label.IN(xxx).CENTER.MAKE()
//        label.text = "xxxx"
        
//        navigationBarTitleFont = QXFont(fmt: "15 #ffff00")
//        navigationBarTintColor = QXColor.red
//        title = "首页"
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = TestVc()
//        let nav = QXNavigationController(rootViewController: vc)
//        present(nav)
        push(vc)
    }
}
