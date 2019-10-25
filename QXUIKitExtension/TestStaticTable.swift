//
//  TestStaticTable.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/24.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

class TestStaticTableVc: QXTableViewController<Any, QXLoadStatusView> {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "静态单元格"
    
        view.qxBackgroundColor = QXColor.yellow
        navigationBarBackTitle = ""
        
        let s = QXTableViewSection([
            {
                let cell = QXStaticTextCell()
                cell.label.text = "自适应文本" + QXDebugRandomText(99)
                return cell
            }(),
            {
               let cell = QXStaticButtonCell()
               return cell
            }(),
        ], {
                let header = QXStaticHeaderView()
                header.label.text = "header 自适应"
                return header
        }(),
           {
                let footer = QXStaticFooterView()
                footer.label.text = "footer固定高度"
                return footer
        }()
        )
        
        tableView.sections = [s]
        
        let item = QXBarButtonItem.titleItem(title: "测试", styles: nil)
        item.respondClick = { [weak self] in
            self?.view.qxDebugRandomColor()
        }
        navigationItem.rightBarButtonItem = item
    
    }
    
    
    
    
}
