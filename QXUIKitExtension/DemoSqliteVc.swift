//
//  DemoSqlite.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2020/1/4.
//  Copyright © 2020 labi3285_lab. All rights reserved.
//

import UIKit

class DemoSqliteVc: QXViewController {
    
    let db = QXSQLite()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "QXSqlite"
        
        initDatabase()

        for i in 0...100 {
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    self.insert(i)
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.query()
        }
        
    }
    
    func initDatabase() {
        do {
            try db.openDB(QXPath.temp /+ "test.db")

            var sql = ""
            sql = "CREATE TABLE IF NOT EXISTS 'student' ("
            sql += "'id' INT NOT NULL PRIMARY KEY, "
            sql += "'name' TEXT, "
            sql += "'age' INT "
            sql += ");"
            try db.execute(sql)
                        
        } catch {
            QXDebugPrint(error)
        }
    }
    
    func insert(_ id: Int) {
        do {
            var sql = ""

            sql = "REPLACE INTO 'student' (id, name, age) VALUES ("
            sql += "'\(id)', "
            sql += "'\("小明")', "
            sql += "'\(16)' "
            sql += ");"
            try db.execute(sql)
            
            sql = "SELECT * FROM 'student' WHERE id = '\(id)';"
            
            if let e = try db.query(sql).first {
                print(e)
            }
                        
        } catch {
            QXDebugPrint(error)
        }
    }
    
    func query() {
        do {
            var sql = ""
            sql = "SELECT * FROM 'student';"
            let arr = try db.query(sql)
            print(arr)
        } catch {
            QXDebugPrint(error)
        }
    }
    
}
