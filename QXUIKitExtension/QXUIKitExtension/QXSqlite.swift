//
//  QXSqlite.swift
//  QXUIKitExtension
//
//  Created by labi3285 on 2020/1/3.
//  Copyright © 2020 labi3285_lab. All rights reserved.
//

import Foundation
import SQLite3

/*
 声明：
 1、这是本项目对SQLite c数据库的简单封装，以适应swift语法
 2、每个数据库db，要对应一个本工具实体，不可混搭,建议只采用一个db
 3、支持的数据类型及转换关系：
    INT -> Int
    FLOAT -> Double
    BLOB -> Data
    TEXT -> String
 */

public class QXSQLite {
    
    public init() {
        
    }
    
    private var db: OpaquePointer? = nil
    
    /// 打开db
    public func openDB(_ path: String) throws {
        let code = sqlite3_open(path, &db)
        if let err = _qxError(code).error {
            throw err
        }
    }
    
    /// 执行语句
    public func execute(_ SQL: String) throws {
        let cSQL = SQL.cString(using: .utf8)
        let errMsg : UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>? = nil
        let code = sqlite3_exec(db, cSQL, nil, nil, errMsg)
        if let err = _qxError(code).error {
            throw err
        }
    }
    
    /// 查询数据库
    public func query(_ SQL: String) throws -> [[String: Any]] {
        if SQL.lengthOfBytes(using: String.Encoding.utf8) > 0 {
            if let cSQL = (SQL.cString(using: .utf8)) {
                var stmt: OpaquePointer? = nil
                let code = sqlite3_prepare_v2(db, cSQL, -1, &stmt, nil)
                if let err = _qxError(code).error {
                    throw err
                } else {
                    var mArr = [[String: Any]]()
                    while sqlite3_step(stmt) == SQLITE_ROW {
                        var dic = [String: Any]()
                        for i in 0..<sqlite3_column_count(stmt) {
                            var key: String?
                            if let cKey = sqlite3_column_name(stmt, i) {
                                if let _key = String(validatingUTF8: cKey) {
                                    key = _key
                                }
                            }
                            if let key = key {
                                switch sqlite3_column_type(stmt, i) {
                                case SQLITE_INTEGER:
                                    dic[key] = Int(sqlite3_column_int(stmt, i))
                                case SQLITE_FLOAT:
                                    dic[key] = sqlite3_column_double(stmt, i)
                                case SQLITE_BLOB:
                                    if let e = sqlite3_column_blob(stmt, i) {
                                        let c = sqlite3_column_bytes(stmt, i)
                                        dic[key] = Data(bytes: e, count: Int(c))
                                    }
                                case SQLITE_NULL:
                                    break
                                case SQLITE_TEXT, SQLITE3_TEXT:
                                    if let e = sqlite3_column_text(stmt, i) {
                                        dic[key] = String(cString:e)
                                    } else {
                                        dic[key] = ""
                                    }
                                default:
                                    if let e = sqlite3_column_text(stmt, i) {
                                        dic[key] = String(cString:e)
                                    } else {
                                        dic[key] = ""
                                    }
                                }
                            }
                        }
                        mArr.append(dic)
                    }
                    return mArr
                }
            } else {
                throw QXError(-1, "Error SQL")
            }
        } else {
            throw QXError(-1, "Empty SQL")
        }
    }
        
}


extension QXSQLite {
    
    fileprivate func _qxError(_ code: Int32) -> (error: QXError?, isThereNewRow: Bool?) {
        let err: QXError?
        var isThereNewRow: Bool? = nil
        switch code {
        case SQLITE_OK:
            err = nil
        case SQLITE_ERROR:
            err = QXError(code, "Generic error")
        case SQLITE_INTERNAL:
            err = QXError(code, "Internal logic error in SQLite")
        case SQLITE_PERM:
            err = QXError(code, "Access permission denied")
        case SQLITE_ABORT:
            err = QXError(code, "Callback routine requested an abort")
        case SQLITE_BUSY:
            err = QXError(code, "The database file is locked")
        case SQLITE_LOCKED:
            err = QXError(code, "A table in the database is locked")
        case SQLITE_NOMEM:
            err = QXError(code, "A malloc() failed")
        case SQLITE_READONLY:
            err = QXError(code, "Attempt to write a readonly database")
        case SQLITE_INTERRUPT:
            err = QXError(code, "Operation terminated by sqlite3_interrupt()")
        case SQLITE_IOERR:
            err = QXError(code, "Some kind of disk I/O error occurred")
        case SQLITE_CORRUPT:
            err = QXError(code, "The database disk image is malformed")
        case SQLITE_NOTFOUND:
            err = QXError(code, "Unknown opcode in sqlite3_file_control()")
        case SQLITE_FULL:
            err = QXError(code, "Insertion failed because database is full")
        case SQLITE_CANTOPEN:
            err = QXError(code, "Unable to open the database file")
        case SQLITE_PROTOCOL:
            err = QXError(code, "Database lock protocol error")
        case SQLITE_EMPTY:
            err = QXError(code, "Internal use only")
        case SQLITE_SCHEMA:
            err = QXError(code, "The database schema changed")
        case SQLITE_TOOBIG:
            err = QXError(code, "String or BLOB exceeds size limit")
        case SQLITE_CONSTRAINT:
            err = QXError(code, "Abort due to constraint violation")
        case SQLITE_MISMATCH:
            err = QXError(code, "Data type mismatch")
        case SQLITE_MISUSE:
            err = QXError(code, "Library used incorrectly")
        case SQLITE_NOLFS:
            err = QXError(code, "Uses OS features not supported on host")
        case SQLITE_AUTH:
            err = QXError(code, "Authorization denied")
        case SQLITE_FORMAT:
            err = QXError(code, "Not used")
        case SQLITE_RANGE:
            err = QXError(code, "2nd parameter to sqlite3_bind out of range")
        case SQLITE_NOTADB:
            err = QXError(code, "File opened that is not a database file")
        case SQLITE_NOTICE:
            err = QXError(code, "Notifications from sqlite3_log()")
        case SQLITE_WARNING:
            err = QXError(code, "Warnings from sqlite3_log()")
        case SQLITE_ROW:
            err = nil
            isThereNewRow = true
        case SQLITE_DONE:
            err = nil
            isThereNewRow = false
        default:
            err = QXError(code, "unkown error \(code)")
        }
        return (err, isThereNewRow)
    }
    
}
