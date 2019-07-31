//
//  ViewController.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/6/22.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: QXTableViewController<Any, QXLoadStatusView> {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.gray
        canRefresh = true
        canPage = true
        //        tableView.cellsDelegate = self
        retry()
    }

    override func loadModels() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            let ms = ["xxxxxxxxxxxxdwqdwqdwqdwqdwqxxxxxxxxxxxxdwqdwqdwqdwqdwqxxxxxxxxxxxxdwqdwqdwqdwqdwqxxxxxxxxxxxxdwqdwqdwqdwqdwqxxxxxxxxxxxxdwqdwqdwqdwqdwqxxxxxxxxxxxxdwqdwqdwqdwqdwqxxxxxxxxxxxxdwqdwqdwqdwqdwqxxxxxxxxxxxxdwqdwqdwqdwqdwq", 2, 3] as [Any]
            self.onLoadModelsOk(ms)
        }
        
//        let r = QXRequest(method: .get, encoding: .url)
//        r.url = "http://www.baidu.com"
//        weak var ws = self
//        r.fetchPage { (page) in
//            ws?.onLoadModelsComplete(page)
//        }
    }
}




