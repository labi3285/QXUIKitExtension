//
//  TestTableVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

class DemoTableVc: QXTableViewController<Any> {
    
    lazy var testView: QXModelsLoadStatusView<Any> = {
         let tableView = QXTableView()
         let statusView = QXLoadStatusView()
         let e = QXModelsLoadStatusView<Any>(contentView: tableView, loadStatusView: statusView)
         e.canPage = true
         e.canRefresh = true
         e.api = { ok, failed in
             DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                 let ms = (0..<5).map { _ in QXDebugRandomText(999) }
                 ok(ms, true)
             }
         }
         return e
     }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TableVc"
        view.qxBackgroundColor = QXColor.white
        contentView.canRefresh = true
        contentView.canPage = true
        contentView.api = { ok, failed in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                let ms = (0..<10).map { _ in QXDebugRandomText(999) }
                ok(ms, nil)
    //            self.onLoadModelsFailed(QXError.unknown)
            }
        }
        contentView.reloadData()
    }
    
    override func qxTableViewCellClass(_ model: Any?) -> QXTableViewCell.Type? {
        return QXDebugTableViewCell.self
    }
    
}

