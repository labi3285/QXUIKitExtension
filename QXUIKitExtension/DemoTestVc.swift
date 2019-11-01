//
//  DemoTestVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/29.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit

class DemoTestVc: QXViewController {
        
    lazy var testView: QXModelsLoadStatusView<Any> = {
        let tableView = QXTableView()
        let statusView = QXLoadStatusView()
        let one = QXModelsLoadStatusView<Any>(contentView: tableView, loadStatusView: statusView)
        one.canPage = true
        one.canRefresh = true
        one.api = { ok, failed in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                let ms = (0..<5).map { _ in QXDebugRandomText(999) }
                ok(ms, true)
            }
        }
        return one
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Test"
        view.backgroundColor = UIColor.yellow
        view.addSubview(testView)
        testView.IN(view).LEFT.RIGHT.TOP.BOTTOM.MAKE()
        testView.reloadData()
    }
    
}
