//
//  ViewController.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/6/22.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: QXTableViewController<QXModel, QXLoadStatusView> {

    override func viewDidLoad() {
        super.viewDidLoad()
        canRefresh = true
        canPage = true
        retry()
    }
    
    override func qxTableViewCell(_ model: Any?, _ reuseId: String) -> QXTableViewCell {
        let c = DebugTableViewCell(reuseId: reuseId)
        c.contentView.qxDebugRandomColor()
        return c
    }
    override func loadModels() {
        let r = QXRequest(method: .get, encoding: .url)
        r.url = "http://www.baidu.com"
        weak var ws = self
        r.fetchPage { (page) in
            ws?.onLoadModelsComplete(page)
        }
    }
}


