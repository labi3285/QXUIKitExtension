//
//  DemoStaticsVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/28.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

class DemoStaticsVc: QXTableViewController<Any, QXLoadStatusView> {
    
    lazy var headerView: QXStaticHeaderView = {
        let one = QXStaticHeaderView()
        one.label.text = "头部"
        return one
    }()

    lazy var textCell: QXStaticTextCell = {
        let one = QXStaticTextCell()
        one.label.text = "文本" + QXDebugText(999)
        return one
    }()
    lazy var pictrueCell: QXStaticPictureCell = {
        let one = QXStaticPictureCell()
        one.pictureView.image = QXUIKitExtensionResources.shared.image("icon_load_empty")
        return one
    }()
    
    lazy var pictruesCell: QXStaticPicturesCell = {
        let one = QXStaticPicturesCell()
        
        let e = "http://gss0.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/d788d43f8794a4c240e9466f0ef41bd5ac6e39af.jpg"

//        one.pictures = [QXImage(url: e)]
        one.picturesView.pictures = [QXImage(url: e), QXImage(url: e)]
//        one.pictures = [QXImage(url: e), QXImage(url: e), QXImage(url: e)]
        return one
    }()
    
    
    
    
    lazy var buttonCell: QXStaticButtonCell = {
        let one = QXStaticButtonCell()
        return one
    }()
      
    lazy var footerView: QXStaticFooterView = {
        let one = QXStaticFooterView()
        one.label.text = "尾部"
        return one
    }()
    
    lazy var section: QXTableViewSection = {
        let one = QXTableViewSection([
            self.textCell,
            self.pictrueCell,
            self.pictruesCell,
            self.buttonCell,
        ], self.headerView, self.footerView)
        return one
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Statics"
        view.qxBackgroundColor = QXColor.white
        tableView.sections = [section]
        
        let item = QXBarButtonItem.titleItem(title: "xxx", styles: nil)
        item.respondClick = { [weak self] in

            self?.pictrueCell.pictureView.image = nil
        }

        navigationItem.rightBarButtonItem = item
        

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        view.qxDebugRandomColor()
    }

}

