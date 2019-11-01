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
        let one = QXStaticHeaderView()
        one.label.text = "头部"
        return one
    }()

    lazy var textCell: QXStaticTextCell = {
        let one = QXStaticTextCell()
        one.label.text = "文本" + QXDebugText(999)
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
            self.buttonCell,
        ], self.headerView, self.footerView)
        return one
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

