//
//  QXCache.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2020/1/4.
//  Copyright © 2020 labi3285_lab. All rights reserved.
//

import UIKit

public struct QXCache {
        
    public init() {
        
    }
    
    public func setup(_ path: String) throws {
        try db.openDB(path)
        var sql = ""
        sql = "CREATE TABLE IF NOT EXISTS 'table_data' ("
        sql += "'key' TEXT NOT NULL PRIMARY KEY, "
        sql += "'value' BLOB "
        sql += ");"
        try db.execute(sql)
        sql = "CREATE TABLE IF NOT EXISTS 'table_text' ("
        sql += "'key' TEXT NOT NULL PRIMARY KEY, "
        sql += "'value' TEXT "
        sql += ");"
        try db.execute(sql)
        sql = "CREATE TABLE IF NOT EXISTS 'table_int' ("
        sql += "'key' TEXT NOT NULL PRIMARY KEY, "
        sql += "'value' INT "
        sql += ");"
        try db.execute(sql)
        sql = "CREATE TABLE IF NOT EXISTS 'table_float' ("
        sql += "'key' TEXT NOT NULL PRIMARY KEY, "
        sql += "'value' FLOAT "
        sql += ");"
        try db.execute(sql)
    }
    
    public func setInt(_ key: String, _ value: Int?) throws {
        if let e = value {
            try db.execute("REPLACE INTO 'table_int' (key, value) VALUES ( '\(key)', '\(e)' );")
        } else {
            try db.execute("DELETE FROM 'table_int' WHERE key = '\(key)';")
        }
    }
    public func getInt(_ key: String) throws -> Int? {
        if let e = try db.queryDB("SELECT * FROM 'table_int' WHERE key = '\(key)';").first {
            return e["value"] as? Int
        }
        return nil
    }
    
    public func setText(_ key: String, _ value: String?) throws {
        if let e = value {
            try db.execute("REPLACE INTO 'table_text' (key, value) VALUES ( '\(key)', '\(e)' );")
        } else {
            try db.execute("DELETE FROM 'table_text' WHERE key = '\(key)';")
        }
    }
    public func getText(_ key: String) throws -> String? {
        if let e = try db.queryDB("SELECT * FROM 'table_text' WHERE key = '\(key)';").first {
            return e["value"] as? String
        }
        return nil
    }
    
    public func setDouble(_ key: String, _ value: Double?) throws {
        if let e = value {
            try db.execute("REPLACE INTO 'table_float' (key, value) VALUES ( '\(key)', '\(e)' );")
        } else {
            try db.execute("DELETE FROM 'table_float' WHERE key = '\(key)';")
        }
    }
    public func getDouble(_ key: String) throws -> Double? {
        if let e = try db.queryDB("SELECT * FROM 'table_float' WHERE key = '\(key)';").first {
            return e["value"] as? Double
        }
        return nil
    }
    
    public func setData(_ key: String, _ value: Data?) throws {
        if let e = value {
            let e = e.base64EncodedString()
            try db.execute("REPLACE INTO 'table_data' (key, value) VALUES ( '\(key)', '\(e)' );")
        } else {
            try db.execute("DELETE FROM 'table_data' WHERE key = '\(key)';")
        }
    }
    public func getData(_ key: String) throws -> Data? {
        if let e = try db.queryDB("SELECT * FROM 'table_data' WHERE key = '\(key)';").first {
            if let e = e["value"] as? String {
                return Data(base64Encoded: e)
            }
        }
        return nil
    }

    public let db = QXSQLite()
    
}


extension QXCache {
    
    public func setModel<T: QXModelProtocol>(_ key: String, _ value: T?) throws {
        do {
            if let e = value {
                let data = try JSONSerialization.data(withJSONObject: e.toDictionary(), options: JSONSerialization.WritingOptions(rawValue: 0))
                try setData(key, data)
            } else {
                try setData(key, nil)
            }
        } catch {
            throw error
        }
    }
    
    public func getModel<T: QXModelProtocol>(_ key: String, _ type: T.Type) throws -> T? {
        do {
            if let data = try getData(key) {
                if let dic = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    let e = T.init(dictionary: dic)
                    return e
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } catch {
            throw error
        }
    }
    
}
