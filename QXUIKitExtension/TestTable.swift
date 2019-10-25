//
//  TestTableVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

class TestTableVc: QXTableViewController<Any, QXLoadStatusView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TableVc"
        view.qxBackgroundColor = QXColor.yellow
        canRefresh = true
        canPage = true
        retry()
    }
    override func loadModels() {
        super.loadModels()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            let ms = (0..<10).map { _ in QXDebugRandomText(999) }
            self.onLoadModelsOk(ms)
//            self.onLoadModelsFailed(QXError.unknown)
        }
    }
    
    override func cellClass(_ model: Any?) -> QXTableViewCell.Type? {
        return QXDebugTableViewCell.self
    }
//    override func headerFooterViewClassFor(_ model: Any?) -> QXTableViewHeaderFooterView.Type? {
//        return QXStaticFooterView.self
//    }
    
}

