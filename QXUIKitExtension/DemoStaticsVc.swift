//
//  DemoStaticsVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/28.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

class DemoStaticsVc: QXTableViewController<Any> {
    
    lazy var headerView: QXStaticHeaderView = {
        let e = QXStaticHeaderView()
        e.label.text = "头部"
        return e
    }()

    lazy var textCell: QXStaticTextCell = {
        let e = QXStaticTextCell()
        e.label.text = "文本" + QXDebugText(999)
        return e
    }()
    
    lazy var buttonCell: QXStaticButtonCell = {
        let e = QXStaticButtonCell()
        return e
    }()
      
    lazy var footerView: QXStaticFooterView = {
        let e = QXStaticFooterView()
        e.label.text = "尾部"
        return e
    }()
    
    lazy var section: QXTableViewSection = {
        let e = QXTableViewSection([
            self.textCell,
            self.buttonCell,
        ], self.headerView, self.footerView)
        return e
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Statics"
        view.qxBackgroundColor = QXColor.white
        tableView.sections = [section]
        
                
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        view.qxDebugRandomColor()
    }

}

