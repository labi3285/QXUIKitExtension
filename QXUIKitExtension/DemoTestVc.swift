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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "测试"
    }
    
    override func didSetup() {
        super.didSetup()
        
        let g = DispatchGroup()
        
        for i in 0..<100 {
            g.enter()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                g.leave()
            }
        }
        
        g.notify(queue: DispatchQueue.main) {
            print("ok")
        }
        
        
//        let name = "截屏2020-07-28下午11.15.37.jepg"
//        let path = QXPath.cache /+ "upload" /+ name
//        let dir = path.qxString(start: 0, end: path.count - 1)
//        print(dir)        
    }

}
