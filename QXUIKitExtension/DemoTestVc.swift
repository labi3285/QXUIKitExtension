//
//  DemoTestVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/29.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import SQLite3

class DemoTestVc: QXTableViewController<Any> {
    
    final lazy var cardCell: QXStaticCardCell = {
        let e = QXStaticCardCell()
        let a = QXLabel()
        a.numberOfLines = 0
        a.text = QXDebugText(200)
        let b = QXLineView.breakLine
        b.padding = QXEdgeInsets(5, -10, 5, -10)
        let c = QXLabel()
        c.numberOfLines = 0
        c.text = QXDebugText(200)
        e.cardView.views = [a, b, c]
        return e
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "测试"
        
        contentView.canRefresh = true
        contentView.canPage = true
        
        contentView.staticModels = [
            cardCell
        ]
    }
    
    override func didSetup() {
        super.didSetup()
        contentView.reloadData()
    }

    override func loadData(_ filter: QXFilter, _ done: @escaping (QXRequest.RespondPage<Any>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            done(.failed(QXError.noData))
        }
    }
    
}
