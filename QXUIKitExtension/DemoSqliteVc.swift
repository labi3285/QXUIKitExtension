//
//  DemoSqlite.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2020/1/4.
//  Copyright © 2020 labi3285_lab. All rights reserved.
//

import UIKit

class DemoSqliteVc: QXViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "QXSqlite"
        do {
            var sql = ""

            let db = QXSQLite()
            try db.openDB(QXPath.temp /+ "test.db")
            
            sql = "CREATE TABLE IF NOT EXISTS 'student' ("
            sql += "'id' INT NOT NULL PRIMARY KEY, "
            sql += "'name' TEXT, "
            sql += "'age' INT "
            sql += ");"
            try db.execute(sql)
            
            sql = "REPLACE INTO 'student' (id, name, age) VALUES ("
            sql += "'\(1)', "
            sql += "'\("小明")', "
            sql += "'\(16)' "
            sql += ");"
            try db.execute(sql)
            
            sql = "SELECT * FROM 'student' WHERE id = '\(1)';"
            
            let arr = try db.queryDB(sql)
            print(arr)
                        
        } catch {
            QXDebugPrint(error)
        }

    }
    
}
