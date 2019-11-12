//
//  DemoDefaultListVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/11/12.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

class DemoDefaultListVc: QXTableViewController<Any> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "DefaultListVc"
        view.qxBackgroundColor = QXColor.white
        tableView.sectionHeaderSpace = 10
        tableView.sectionFooterSpace = 10
        tableView.adapter = QXTableView.Adapter([
            (QXTableViewText.self, QXTableViewTextCell.self),
            (QXTableViewLine.self, QXTableViewLineCell.self),
            (QXTableViewImage.self, QXTableViewImageCell.self),
        ])
        
        let link = QXTableViewText()
        link.items = [
            QXRichLabel.Item.text(string: "www.baidu.com", font: QXFont(fmt: "14 #0000ff"), linkData: "xxx")
        ]
        link.respondTouchLink = { a in
            print(a)
        }
        
        
        self.contentView.models = [
            QXTableViewText(QXDebugRandomText(999)),
            QXTableViewImage(QXImage("icon_mine_ask1")),
            QXTableViewText(QXDebugRandomText(50)),
            link,
            QXTableViewLine(),
            QXTableViewText(QXDebugRandomText(999)),
        ]
    }

}

