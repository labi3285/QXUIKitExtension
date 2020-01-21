//
//  DemoTestVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2019/10/29.
//  Copyright © 2019 labi3285_lab. All rights reserved.
//

import UIKit
import SQLite3

class DemoTestVc: QXViewController {
    
    
    lazy var tableView: QXTableView = {
        let e = QXTableView()
        e.fixWidth = 300
        return e
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "测试"
        
        view.addSubview(tableView)
        tableView.IN(view).CENTER.MAKE()
        
        tableView.sections = [
            QXTableViewSection([
                QXDebugText(200),
                
            ])
        ]
        
    
        
    }

}
