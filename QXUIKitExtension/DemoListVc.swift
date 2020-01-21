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
        tableView.isPlain = true
        contentView.canRefresh = true
        contentView.canPage = true
        //tableView.sectionHeaderSpace = 100
        //tableView.sectionFooterSpace = 100

        tableView.adapter = QXTableViewAdapter([
            String.self >> QXTableViewDebugCell.self,
        ])
        
        navigationBarRightItem = QXBarButtonItem.titleItem("xxx", {
            self._isLoad = true
            self.contentView.reloadData()
        })
    }
    
    override func tableViewDidSelectCell(_ cell: QXTableViewCell, for model: Any, in section: QXTableViewSection) {
        let vc = DemoTestVc()
        push(vc)
    }
    
    override func didSetup() {
        super.didSetup()
        contentView.filter.dictionary["123"] = 345
        contentView.reloadData()
    }
    
    private var _isLoad: Bool = false
    override func loadData(_ filter: QXFilter, _ done: @escaping (QXRequest.RespondPage<QXTableViewSection>) -> Void) {
        print(filter.dictionary)
        DispatchQueue.main.qxAsyncAfter(1) {
            if self._isLoad {
                done(.succeed([], false))
            } else {
                let ms = (0..<10).map { _ in QXDebugRandomText(999) }
                let s = QXTableViewSection(ms)
                done(.succeed([s], true))
            }
        }
    }
    
}

