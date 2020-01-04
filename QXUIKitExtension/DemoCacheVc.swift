//
//  DemoCacheVc.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2020/1/4.
//  Copyright © 2020 labi3285_lab. All rights reserved.
//

import UIKit

class DemoCacheVc: QXViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "QXCache"
        do {
            let cache = QXCache()
            try cache.setup(QXPath.temp /+ "QXCache.db")
           
            try cache.setInt("akey", nil)
            try cache.setDouble("akey", nil)
            try cache.setText("akey", "hello")
            let data = "hello".data(using: .utf8)
            try cache.setData("akey", data)
            
            print(try cache.getInt("akey"))
            print(try cache.getDouble("akey"))
//            print(try cache.getText("akey"))
//            print(try cache.getData("akey"))
            

        } catch {
            QXDebugPrint(error)
        }

    }
    
}
