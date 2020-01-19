//
//  DemoStaticsVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/28.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

class DemoStaticsVc: QXTableViewController<Any> {
    
    final lazy var headerView: QXStaticHeaderView = {
        let e = QXStaticHeaderView()
        e.label.text = "头部"
        return e
    }()
    
    final lazy var cardCell: QXStaticCardCell = {
        let e = QXStaticCardCell()
        let a = QXLabel()
        a.numberOfLines = 0
        a.text = QXDebugText(200)
        let b = QXLineView.breakLine
        b.padding = QXEdgeInsets(5, -10, 5, -10)
        let c = QXLabel()
        c.numberOfLines = 0
        c.text = QXDebugText(200)
        e.cardView.views = [a, b, c]
        return e
    }()

    final lazy var textCell: QXStaticTextCell = {
        let e = QXStaticTextCell()
        e.label.text = "文本" + QXDebugText(999)
        return e
    }()
    
    final lazy var imageCell: QXStaticImageCell = {
        let e = QXStaticImageCell()
        e.myImageView.image = QXImage("icon_mine_ask1")
        return e
    }()
        
    final lazy var buttonCell: QXStaticButtonCell = {
        let e = QXStaticButtonCell()
        return e
    }()
      
    final lazy var footerView: QXStaticFooterView = {
        let e = QXStaticFooterView()
        e.label.text = "尾部"
        return e
    }()
    
    final lazy var section: QXTableViewSection = {
        let e = QXTableViewSection([
            self.cardCell,
            self.textCell,
            self.imageCell,
            self.buttonCell,
        ], self.headerView, self.footerView)
        return e
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Statics"
//        view.qxBackgroundColor = QXColor.yellow
        contentView.staticModels = [section]
        
        contentView.reloadData()
        
//        contentView.filter.json
    }
    
    override func loadData(_ filter: QXFilter, _ done: @escaping (QXRequest.RespondPage<Any>) -> Void) {
        done(.failed(QXError.noData))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        view.qxDebugRandomColor()
    }

}

