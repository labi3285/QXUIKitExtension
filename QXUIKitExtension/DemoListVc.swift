//
//  TestTableVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

class DemoListVc: QXTableViewController<QXTableViewSection> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ListVc"
        view.qxBackgroundColor = QXColor.white
        contentView.canRefresh = true
        contentView.canPage = true
        tableView.sectionHeaderSpace = 100
        tableView.sectionFooterSpace = 100
        
        tableView.adapter = QXTableView.Adapter([
            (String.self, QXTableViewDebugCell.self)
        ])
        
        contentView.api = { page, size, ok, failed in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                let ms = (0..<10).map { _ in QXDebugRandomText(999) }
                let s = QXTableViewSection(ms, QXSpace(10), QXSpace(10))
                ok([s], nil)
    //            self.onLoadModelsFailed(QXError.unknown)
            }
        }
        contentView.reloadData()
    }
    
//    override func qxTableViewCellClass(_ model: Any?) -> QXTableViewCell.Type? {
//        return QXTableViewDebugCell.self
//    }
    override func qxTableViewDidSelectCell(_ model: Any?) {
         print("cell")
    }
    override func qxTableViewDidSelectHeaderView(_ model: Any?) {
        print("header")
    }
    override func qxTableViewDidSelectFooterView(_ model: Any?) {
        print("footer")
    }

}

